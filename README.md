# RaspberryPiScripts
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

## OrganiseTorrent.sh

This command is kicked off from incron where the path its watching and the filename is passed in.

### Setup

#### Setup Incron File Watcher

* Install incron `sudo apt-get install incron`
    * Setup permissions `sudo nano /etc/incron.allow`
        * Add `pi` and save the file 
* Edit Incron config `incrontab -e`
   * Add `/mnt/torrents/completed IN_MOVED_TO     sudo bash /usr/local/bin/incron-cmds/organise-torrent.sh $@ $#`
       * Watch location is `/mnt/torrents/completed`
       * The type of event to watch is the file being moved to that location `IN_MOVED_TO`
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
