# RaspberryPiScripts
Collection of scripts running on pi

## OrganiseTorrent.sh

This command is kicked off from incron where the path its watching and the filename is passed in.

It will:
* Create directory in path given using the suffix in the filename. If it doesnt match the regex SxxEyy then it creates a Movies folder
* Move the file to the new folder
* Logs relevant actions in a rolling log way

TODO:
* Use a proper logger
* Change log timezone from UTC to local
