#!/bin/sh
export "PATH=.:t:$PATH"

printf '1..6\n'
printf '# secho\n'

tap3 "single string" <<'EOF'
secho hello
>>>
hello
EOF

tap3 "two strings" <<'EOF'
secho hello random
>>>
hello random
EOF

tap3 "no arguments" <<'EOF'
secho
>>>

EOF

tap3 "empty argument" <<'EOF'
secho foo '' bar
>>>
foo  bar
EOF

tap3 "string with minus" <<'EOF'
secho -n -e
>>>
-n -e
EOF

tap3 "string with double minus" <<'EOF'
secho -n -- -e
>>>
-n -- -e
EOF
