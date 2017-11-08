CFLAGS=-g -O2 -Wall -Wno-switch -Wextra

DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
MANDIR=$(PREFIX)/share/man

ALL = necho
LINKS = zecho qecho jecho secho

all: $(ALL) $(LINKS) $(LINKS:=.1)

README: necho.1
	mandoc -Tutf8 $< | col -bx >$@

necho: necho.c

$(LINKS): necho
	ln -sf necho $@

$(LINKS:=.1): necho.1
	ln -sf necho.1 $@

install: FRC all
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(MANDIR)/man1
	install -m0755 $(ALL) $(DESTDIR)$(BINDIR)
	install -m0644 $(ALL:=.1) $(DESTDIR)$(MANDIR)/man1
	for l in $(LINKS); do \
		ln -sf necho $(DESTDIR)$(BINDIR)/$$l; \
		ln -sf necho.1 $(DESTDIR)$(MANDIR)/man1/$$l.1; \
	done

clean: FRC
	rm -f $(ALL) $(LINKS) $(LINKS:=.1)

FRC:
