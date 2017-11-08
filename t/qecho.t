#!/bin/sh
export "PATH=.:t:$PATH"

printf '1..6\n'
printf '# qecho\n'

tap3 "single string" <<'EOF'
qecho hello
>>>
»hello«
EOF

tap3 "two strings" <<'EOF'
qecho hello random
>>>
»hello« »random«
EOF

tap3 "no arguments" <<'EOF'
qecho
>>>
EOF

tap3 "empty argument" <<'EOF'
qecho foo '' bar
>>>
»foo« »« »bar«
EOF

tap3 "string with minus" <<'EOF'
qecho -n -e
>>>
»-n« »-e«
EOF

tap3 "string with double minus" <<'EOF'
qecho -n -- -e
>>>
»-n« »--« »-e«
EOF
