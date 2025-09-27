# ========================
# Quick Notes Script
# ========================

NOTES_DIR="$HOME/journal"
REMOTE_NAME="gdrive"      # change if you used a different rclone remote
REMOTE_FOLDER="notes"     # remote Google Drive folder (rclone will create it if needed)

# Ensure notes directory exists
mkdir -p "$NOTES_DIR"

# List existing notes
clear
echo "=== journal ==="
select NOTE in $(ls "$NOTES_DIR") "Create New Note"; do
    if [ "$NOTE" == "Create New Note" ]; then
        read -p "Enter new note name (without extension): " NEW_NOTE
        NOTE="$NEW_NOTE.md"
        touch "$NOTES_DIR/$NOTE"
        break
    elif [ -n "$NOTE" ]; then
        break
    else
        echo "Invalid option."
    fi
done

# Open note in nano editor
clear
nano"$NOTES_DIR/$NOTE"

# Check connectivity to remote using rclone
if rclone ls "$REMOTE_NAME:$REMOTE_FOLDER" &>/dev/null; then
    read -p "Do you want to upload/update '$NOTE' to Google Drive? (y/n): " CHOICE
    if [[ "$CHOICE" == "y" ]]; then
        rclone copy "$NOTES_DIR/$NOTE" "$REMOTE_NAME:$REMOTE_FOLDER" --update
        echo "✅"
    else
        echo "Note not uploaded."
    fi
else
    echo "❌🌐. Skipping upload."
fi
