#!/bin/bash
echo "Starting backup script..."

# import variables
source config.sh

# Source mount directory
mkdir -p $shared_dir_mount_target # create the dir where will be mounted the shared network device(which is the source_dir)
chown -R "$system_user":"$system_user" "$shared_dir_mount_target"

# Destination directory
mkdir -p "$destination_dir"
chown -R "$system_user":"$system_user" "$destination_dir"

# Log directory
mkdir -p "$log_dir"
chown -R "$system_user":"$system_user" "$log_dir"


#removes old log files
find "$log_dir" -type f -name "----*" -mtime +30 -exec rm {} \;


# Timestamp for the log file
timestamp=$(date +"%Y-%m-%d-%H-%M")
log_file="$log_dir/rsync_log_$timestamp.txt"


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
    mount -t cifs "$shared_dir_source" "$shared_dir_mount_target" -o username="$samba_user",password="$samba_password",uid=$(id -u),gid=$(id -g)
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
        mount "$destination_mount_device_location" "$destination_dir"
        if [ $? -eq 0 ]; then
            echo "Destiny mount successful."
        else
            echo "Destiny mounting failed. Check your destination path."
            exit 1
        fi
    fi
fi

# Rsync command
# You can pass the --delete flag if you want to delete old files from the backup, but if target incorrectly the destination directory, there might be data loss in the backup
echo "Starting rsync command..."
rsync -av --progress --info=progress1 "$shared_dir_mount_target" "$destination_dir" 2>&1 | tee >(display_rsync_messages)

chown "$system_user":"$system_user" "$log_file"

# Check the rsync exit status
if [ $? -eq 0 ]; then
    echo "Rsync completed successfully. Log saved to: $log_file"
else
    echo "Rsync encountered an error. Check the log file for details: $log_file"
fi

echo "Unmounting shared directory..."
umount "$shared_dir_mount_target"
echo "Unmounting destination dir..."
umount "$destination_dir"
