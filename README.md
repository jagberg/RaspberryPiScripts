# Raspberry Pi Scripts
Collection of scripts running on pi

## Installed Apps

* [Setup PrivateInternetAccess (OpenVPN), Deluge, Samba](https://techwiztime.com/article/best-raspberry-pi-torrentbox)
    * PIA Config
        * Might need to setup permission `chmod +w -R openvpn`
        * Rename "AU Sydney" to "AUSydney" because when it had the space it didnt recognise the right name in `/etc/default/openvpn` `AUTOSTART="AUSydney"`
    * Deluge Config
        * Setup file permissions to the /mnt/torrents folder created 
            * `cd /mnt` and then `sudo chmod -R 777 torrents/`
* [Plex Server](https://www.youtube.com/watch?v=zRj9mrwISZ8)

### Kodi Setup

#### Raspbian Buster
Follow the instructions in [[Guide] Kodi on Raspberry Pi OS / Raspbian Buster](https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=251645)
* Run `sudo apt-get uninstall kodi`
* Update your memory split as Kodi needs a min of 160MB
    * Run `sudo raspi-config`
    * Go to **Advanced Settings** 
        * -> **Memory Split** -> Change to a min of 160MB, Ive done 320MB
        * -> **Resolution** -> Change to 1024x768. 1920x1024 resulted in a black screen through HDMI. You get a black screen in VNC but this time with a cursor.

#### LibreElec Installation
* Plug in HDMI into the port next to the power port on the Raspberry Pi
* Install from LibreElec website onto an SD card
* Open `config.txt` in the SD Card and add the following otherwise you will just get a black screen when connecting to HDMI through the TV
    ```
    hdmi_group=2
    hdmi_mode=16
    ```
> :warning: **If using VNC**: You cant run Kodi through it. See the [issue](https://www.raspberrypi.org/forums/viewtopic.php?t=255148)

##### Mapping to Windows Share
* Follow: https://libreelec.wiki/how_to/mount_network_share
* On Windows create a new **Share** directory. My computer network address is **192.168.1.21**
* Add a new local windows account (not a Microsoft login one)
    * Username: `libreeelec`
    * Password: `<yeh right>`
* `mkdir /storage/files`
* `nano /storage/.config/system.d/storage-files.mount`
* Use the following settings
    ```
    [Unit]
    Description=cifs mount script
    Requires=network-online.service
    After=network-online.service
    Before=kodi.service
    
    [Mount]
    What=//192.168.1.21/Share
    Where=/storage/files
    Options=username=libreelec,password=<yeh right>,rw,vers=2.1
    Type=cifs
    
    [Install]
    WantedBy=multi-user.target
    ```
* Enable the mount: `systemctl enable storage-files.mount`
* `reboot`
* Check if its working: `systemctl status storage-files.mount`

##### Netflix Installation
* The option to use username/password didnt work for me so I had to use the Auth Key option instead.
[Login with Auth Key](https://github.com/CastagnaIT/plugin.video.netflix/wiki/Login-with-Authentication-key)

## OrganiseTorrent.sh

This command is kicked off from incron where the path its watching and the filename is passed in.

### Setup

#### Setup Incron File Watcher

* Install [incron](https://github.com/ar-/incron) `sudo apt-get install incron`
    * Setup permissions `sudo nano /etc/incron.allow`
        * Add `pi` and save the file 
* Edit Incron config `incrontab -e`
   * Add `/mnt/torrents/completed IN_CLOSE_NOWRITE,recursive=false,loopable=true sudo bash /usr/local/bin/incron-cmds/organise-torrent.sh $@ $#` 
       * Watch location is `/mnt/torrents/completed`
       * The type of event to watch is the file being moved to that location and finished `IN_CLOSE_NOWRITE`. This didnt work without the sleep. Using `loopable=true` I thought would wait until finished but didnt work without the sleep too.
       * Just check the root of the path, not all the files in it `recursive=false`
       * Command to run when the file is detected `sudo bash /usr/local/bin/incron-cmds/organise-torrent.sh`. The args are:
           * `s@` which is the path of the file
           * `s#` which is the filename 
* Setup file water

* `cd /usr/local/bin`
* `mkdir incron-cmds`
* copy script to:
`/usr/local/bin/incron-cmds/organise-torrent.sh`

It will:
* Create directory in path given using the suffix in the filename. If it doesnt match the regex SxxEyy then it creates a Movies folder
* Move the file to the new folder
* Logs relevant actions in a rolling log way

TODO:
* Use a proper logger
* Change log timezone from UTC to local
