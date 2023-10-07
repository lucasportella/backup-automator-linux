#!/bin/bash
echo "Starting backup script..."

# import variables
source config.sh

# CREATE DIRECTORIES
# Source mount directory
mkdir -p $shared_dir_mount_target # create the dir where will be mounted the shared network device(which is the source_dir)
# Destination directory
mkdir -p "$destination_dir" # use sudo if dir is in root folder
# Log directory
mkdir -p "$log_dir" # use sudo if dir is in root folder

# Timestamp for the log file
timestamp=$(date +"%Y%m%d%H%M%S")
log_file="$log_dir/rsync_log_$timestamp.txt"
date_format=$(date +"%d-%m-%Y")


echo "Variables created."

display_rsync_messages() {
    while IFS= read -r line; do
        echo "$line"   # Print the rsync message to the terminal
        echo "$line" >> "$log_file"  # Log the message to the log file
    done
}

# Check if source and destination directories are already mounted
if [ -d "$shared_dir_source" ]; then
    echo "Source directory already mounted."
else
    sudo mount -t cifs "$shared_dir_source" "$shared_dir_mount_target" -o username="$samba_user",password="$samba_password",uid=$(id -u),gid=$(id -g)
    if [ $? -eq 0 ]; then
        echo "Source mount successful."
    else
        echo "Source mounting failed. Check your source path."
        exit 1
    fi
fi

if [ -d "$destination_dir" ]; then
    if mountpoint -q "$destination_dir"; then
        echo "Destiny directory already mounted."
    else
        sudo mount "$destination_mount_device_location" "$destination_dir"
        if [ $? -eq 0 ]; then
            echo "Destiny mount successful."
        else
            echo "Destiny mounting failed. Check your destination path."
            exit 1
        fi
    fi
fi

# Rsync command
echo "Starting rsync command..."
rsync -av --delete --progress --info=progress2 "$shared_dir_mount_target" "$destination_dir" > "$log_file" 2>&1

# Check the rsync exit status
if [ $? -eq 0 ]; then
    echo "Rsync completed successfully. Log saved to: $log_file"
else
    echo "Rsync encountered an error. Check the log file for details: $log_file"
fi

echo "Unmounting shared directory..."
sudo umount "$shared_dir_mount_target"
echo "Unmounting destination dir..."
sudo umount "$destination_dir"

