# Credentials
export samba_user="john" # not best practise, samba_user should be the same as system_user
export system_user="mike"
export samba_password="password"

export log_dir="/home/$user/logs"

# Source directory
export shared_folder_dir="/home/$user/my-shared-folder"
export source_dir="/home/$user/my-src-dir"
export source_mount_target="/home/my-mount-target"

# Destination directory
export destination_dir="/run/media/john/my-device"
export mount_device_location="/dev/sda1"