# backup-automator
backup automator for linux computers connected into a local SMB/CIFS server

Useful for generating local backups from your SMB/CIFS server. 
After the first backup is created, it will only update the backup with the cifs server, being must faster than creating a new backup from scratch.

## Requirements
- A SMB/CIFS server running in your local network. I used Samba, you can configure it [here](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)
- A block device such as a HDD/SSD to store your backup files. It should be recognized by the OS but not necessarily mounted (if mounted a busy error may occur).
- A GNU/Linux OS on your backup computer


# How to use
- Download the project in your Linux computer
- Create your config.sh file base on the config-example.sh
- Change the config.sh variables to your own.
  - **shared_dir_source** is the network path to connect to your local server. You can find it using the *hostname* command in your server. You might need to provide the user and hostname path to work plus *.local* plus *sharename*, just like in the config-example file.
  - **shared_dir_mount_target** is the path to where the server shared folder will be mounted on the backup computer. It's up to you to decide the path.
  - **destination_mount_device_location** is your block device location. You can find it with the command *lsblk* on your backup computer.
  - **destination_dir** is where your backup files will be in your system.
- Run the script in the project folder with the command *./backup-script.sh*
- You can check the logs in the path provided on your config.sh *log_dir* variable
- You can also create a systemd service for this project so the backup is always synced with the server. Heres how:
  - Create a file with a `.service` extension, for example, `backup-script.service`. You can place it in the `/etc/systemd/system/` directory. Use the available service-example.service in this repo, you just need to change the path of ExecStart and WorkingDirectory. You can use this command: *sudo nano /etc/systemd/system/yourfile.service*;
  - After saving your service file, reload the systemd manager configuration: *sudo systemctl daemon-reload*;
  - Start your service with the following command: *sudo systemctl start yourfile.service*
  - To ensure that your service starts on boot, enable it: *sudo systemctl enable yourfile.service*
  - From now, everytime your pc boots, it will sync with the cifs server and create/update your backup!


Windows and docker versions coming soon...
