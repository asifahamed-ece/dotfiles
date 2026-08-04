#!/bin/bash
# Waybar Update Manager: Lists updates and shows live execution

# 1. Fetch updates (Official Repos + AUR)
updates=$(yay -Qu 2>/dev/null)

# 2. If no updates, show a notification and exit
if [ -z "$updates" ]; then
    notify-send -i "software-update-available" "System Up to Date" "No updates available."
    exit 0
fi

# 3. Save the list to a temporary file
tmp_file=$(mktemp)
echo "$updates" > "$tmp_file"
count=$(echo "$updates" | wc -l)

# 4. Open Kitty to display the list and ask for permission
# (explicit size so the hand-centered "====" borders below actually line up —
# without it kitty opens at whatever its default size is, and the borders
# were being centered for a fixed column width)
kitty -o initial_window_width=800 -o initial_window_height=600 -e bash -c "
    clear
    echo '========================================='
    echo '   AVAILABLE SYSTEM UPDATES ($count packages)'
    echo '========================================='
    cat '$tmp_file'
    echo ''
    echo 'Press ENTER to install, or Ctrl+C to cancel.'
    read -p '> '

    # 5. Run yay with debug output showing live execution
    # (dropped -d here — that flag is --nodeps, i.e. skip dependency checks,
    # not verbose/debug output, and shouldn't be on by default)
    echo ''
    echo '========================================='
    echo '       EXECUTING UPDATES'
    echo '========================================='
    echo ''

    yay -Svu --noconfirm --debug
    exit_code=\$?

    echo ''
    echo '========================================='
    if [ \$exit_code -eq 0 ]; then
        echo '       UPDATE COMPLETED SUCCESSFULLY'
    else
        echo '       UPDATE FINISHED WITH ERRORS'
    fi
    echo '========================================='
    echo ''
    echo 'Press ENTER to close.'
    read
"

# 6. Cleanup
rm -f "$tmp_file"
