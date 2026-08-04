#!/bin/bash
# Waybar Update Manager: Lists updates and shows live execution

# 1. Fetch updates (Official Repos + AUR)
echo "Fetching available updates..."
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
kitty -e bash -c "
    clear
    echo ''
    echo '========================================='
    echo "       AVAILABLE SYSTEM UPDATES ($count packages)"
    echo '========================================='
    echo ''
    cat '$tmp_file'
    echo ''
    echo '========================================='
    echo 'Press ENTER to install updates'
    echo 'Press Ctrl+C to cancel'
    echo '========================================='
    echo ''
    read -p 'Your choice: '
    
    # 5. Run yay with verbose output
    echo ''
    echo '========================================='
    echo '       STARTING UPDATE PROCESS'
    echo '========================================='
    echo ''
    
    # Execute the update - this will show live output
    yay -Svu --noconfirm
    
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
    read -p 'Press ENTER to close...'
"

# 6. Cleanup
rm -f "$tmp_file"
