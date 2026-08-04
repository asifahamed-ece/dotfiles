#!/bin/bash
tmp=$(mktemp)
cat > "$tmp"
# Skip browser HTML junk; store everything else
if ! head -c 300 "$tmp" | grep -qiE '<meta|<html|<img|<!doctype'; then
    /usr/bin/cliphist store < "$tmp"
fi
rm -f "$tmp"
