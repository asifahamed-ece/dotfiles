#!/bin/bash
updates=$(yay -Qu 2>/dev/null | wc -l)
if [ "$updates" -gt 0 ]; then
    echo "{\"text\": \"$updates\", \"tooltip\": \"$updates packages to update\", \"class\": \"updates\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"System is up to date!\", \"class\": \"updated\"}"
fi
