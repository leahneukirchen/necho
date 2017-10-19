# POSIX sh implementations of necho and friends
#
# To the extent possible under law, the creator of this work has waived
# all copyright and related or neighboring rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

necho() { for a; do printf '%s\n' "$a"; done; }
zecho() { for a; do printf '%s\0' "$a"; done; }
qecho() { for a; do printf '\302\273%s\302\253 ' "$a"; done; printf '\n'; }
jecho() { printf '%s' "$@"; }
secho() {
  [ "$#" -ge 1 ] && { printf '%s' "$1"; shift; }
  for a; do printf ' %s' "$a"; done
  printf '\n'
}
