/*
 * minimal, sensible alternatives to echo(1)
 *
 * necho - print arguments, one per line
 * zecho - print arguments, nul-terminated
 * qecho - print arguments surrounded in unicode quotation marks
 * jecho - print arguments joined together
 * secho - print arguments joined with spaces, and a newline
 *
 * These commands print all arguments as-is, and try to use
 * - one syscall per argument for necho, zecho, qecho
 * - few writev syscalls for jecho, secho
 *
 * secho is a POSIX-conforming, but not XSI-conforming implementation of echo(1).
 *
 * To the extent possible under law, the creator of this work has waived
 * all copyright and related or neighboring rights to this work.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

#define _XOPEN_SOURCE 700

#include <sys/uio.h>

#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>

/* struct iovec[IOV_MAX] should fit on the stack */
#if IOV_MAX > 1024
#define SENSIBLE_IOV_MAX 1024
#else
#define SENSIBLE_IOV_MAX IOV_MAX
#endif

/* like writev(2), but deal with short writes */
ssize_t
safe_writev(int fd, struct iovec *iov, int iovcnt)
{
	ssize_t len, wr;
	int i;

	for (i = 0, len = 0; i < iovcnt; i++)
		len += iov[i].iov_len;

	while (len > 0) {
		if ((wr = writev(fd, iov, iovcnt)) < 0)
			return -1;

		len -= wr;
		if (len <= 0)
			return 0;
		
		/* short write, clear emitted prefix of iovec */
		for (i = 0; i < iovcnt && wr < (ssize_t)iov[i].iov_len; i++) {
			wr -= iov[i].iov_len;
			iov[i].iov_base = 0;
			iov[i].iov_len = 0;
		}
		if (i < iovcnt) {
			iov[i].iov_base = (char *)iov[i].iov_base + wr;
			iov[i].iov_len -= wr;
		}
	}

	return 0;
}

int
main(int argc, char *argv[])
{
	int i;

	char *style = strrchr(argv[0], '/');
	if (style)
		style++;
	else
		style = argv[0];

	errno = 0;

	if (*style == 'q') {
		for (i = 1; i < argc; i++) {
			ssize_t len = strlen(argv[i]);
			struct iovec iov[] = {
/* U+00BB RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK */
				{ "\302\273", 2 },
				{ argv[i], len },
/* U+00AB LEFT-POINTING DOUBLE ANGLE QUOTATION MARK */
				{ "\302\253", 2 },
				{ i == argc - 1 ? "\n" : " ", 1 }
			};
			if (safe_writev(1, iov, 4) < 0)
				break;
		}
	} else if (*style == 'j' || (*style == 's' || *style == 'e')) {
		struct iovec iov[SENSIBLE_IOV_MAX];
		int j = 0;

		i = 1;
		if (argc == 1 && *style != 'j')
			goto just_nl;
		while (i < argc) {
			for (j = 0; i < argc && j < SENSIBLE_IOV_MAX - 1; j++) {
				iov[j].iov_base = argv[i];
				iov[j].iov_len = strlen(argv[i]);
				i++;
				if (*style != 'j') {
					j++;
just_nl:
					iov[j].iov_base = i == argc ? "\n" : " ";
					iov[j].iov_len = 1;
				}
			}
			if (safe_writev(1, iov, j) < 0)
				break;
		}
	} else { /* default to necho */
		for (i = 1; i < argc; i++) {
			struct iovec iov[] = {
				{ argv[i], strlen(argv[i]) },
				{ *style == 'z' ? "\0" : "\n", 1 }
			};
			if (safe_writev(1, iov, 2) < 0)
				break;
		}
	}

	if (errno) {
#ifndef TINY
		char *msg = strerror(errno);
		struct iovec iov[] = {
			{ style, strlen(style) },
			{ ": write error: ", 15 },
			{ msg, strlen(msg) },
			{ "\n", 1 },
		};
		(void)writev(2, iov, 4);
#endif
		return 1;
	}

	return 0;
}
