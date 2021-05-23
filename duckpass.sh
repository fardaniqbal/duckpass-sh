#!/bin/sh
# Random password generator.
len=12
if [ x"$1" != x ]; then
  if !(echo "$1" | grep '[0-9]\+') >/dev/null; then
    echo "Usage: $(basename -- "$0") [PASSLEN]" >&2
    echo "Generate password of length PASSLEN (default $len)" >&2
    exit 1
  fi
  len="$1"
fi
[ $len -lt 4 ] && len=4

# Need at least 1 char each of lowercase, uppercase, number, and punctuation.
lower=$(sed 's|[^a-z]||g' </dev/urandom | head -c1)
upper=$(sed 's|[^A-Z]||g' </dev/urandom | head -c1)
num=$(sed   's|[^0-9]||g' </dev/urandom | head -c1)
punct=$(sed 's|[^!#$%^&*?:;_]||g' </dev/urandom | head -c1)
pass="$lower$upper$num$punct"

# Generate the rest of the characters so total length is $len
pass=$(sed 's|[^a-zA-Z0-9!#$%^&*?:;_]||g' </dev/urandom |
       tr -d '\r\n' | head -c $(($len - 4)))$pass

# Randomly shuffle the characters.
pass=$(printf "%s" "$pass" | fold -w1 | shuf | tr -d '\n')
printf "%s\n" "$pass"