#!/bin/sh
export "PATH=.:t:$PATH"

printf '1..6\n'
printf '# necho\n'

tap3 "single string" <<'EOF'
necho hello
>>>
hello
EOF

tap3 "two strings" <<'EOF'
necho hello random
>>>
hello
random
EOF

tap3 "no arguments" <<'EOF'
necho
>>>
EOF

tap3 "empty argument" <<'EOF'
necho foo '' bar
>>>
foo

bar
EOF

tap3 "string with minus" <<'EOF'
necho -n -e
>>>
-n
-e
EOF

tap3 "string with double minus" <<'EOF'
necho -n -- -e
>>>
-n
--
-e
EOF
