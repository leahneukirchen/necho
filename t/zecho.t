#!/bin/sh
export "PATH=.:t:$PATH"

printf '1..6\n'
printf '# zecho\n'

tap3 "single string" <<'EOF'
zecho hello | tr '\000\012X' '\012X'
>>>
hello
EOF

tap3 "two strings" <<'EOF'
zecho hello random | tr '\000\012X' '\012X'
>>>
hello
random
EOF

tap3 "no arguments" <<'EOF'
zecho | tr '\000\012X' '\012X'
>>>
EOF

tap3 "empty argument" <<'EOF'
zecho foo '' bar | tr '\000\012X' '\012X'
>>>
foo

bar
EOF

tap3 "string with minus" <<'EOF'
zecho -n -e | tr '\000\012X' '\012X'
>>>
-n
-e
EOF

tap3 "string with double minus" <<'EOF'
zecho -n -- -e | tr '\000\012X' '\012X'
>>>
-n
--
-e
EOF
