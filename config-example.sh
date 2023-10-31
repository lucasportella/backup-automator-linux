# Credentials
export system_user="mike"
export samba_user="john" # not best practise, samba_user should be the same as system_user
export samba_password="password"

export log_dir="/home/$system_user/logs"

# Source directory
export shared_dir_source="//mike-mikepc12345.local/sambashare"
export shared_dir_mount_target="/home/$system_user/backup/shared-folder"

# Destination directory
export destination_mount_device_location="/dev/sda1"
export destination_dir="/home/$system_user/backup/$system_user-destination-backup/my-backup"