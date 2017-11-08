#!/bin/sh
export "PATH=.:t:$PATH"

printf '1..6\n'
printf '# jecho\n'

tap3 "single string" <<'EOF'
jecho hello; echo
>>>
hello
EOF

tap3 "two strings" <<'EOF'
jecho hello random; echo
>>>
hellorandom
EOF

tap3 "no arguments" <<'EOF'
jecho
>>>
EOF

tap3 "empty argument" <<'EOF'
jecho foo '' bar; echo
>>>
foobar
EOF

tap3 "string with minus" <<'EOF'
jecho -n -e; echo
>>>
-n-e
EOF

tap3 "string with double minus" <<'EOF'
jecho -n -- -e; echo
>>>
-n---e
EOF
