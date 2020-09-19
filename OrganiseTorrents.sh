#!/bin/bash
# GNU bash, version 4.4.20
defaultLogPath=/tmp/logs
defaultOrganisedRootPath=/mnt/torrents/organised

rootpath=$1
video=$2
logPath=${3:-$defaultLogPath}
organisedRootPath=${4:-$defaultOrganisedRootPath}

# Wait for the file to finish moving into the watched location. I couldnt get incron to only start the process once it completed.
sleep 5

echo "$(date)" >> $logPath/organiseTorrent.log
echo "Path: " $rootpath ", Video: " $video ", Log Path: " $logPath ", Organised Root Path: " $organisedRootPath >> $logPath/organiseTorrent.log

if [ "$rootpath" == "$video" ] || [ -z "$video" ]; then
   exit 1
fi

# Extract the name before SxxEyy eg. Extract Hello.World from Hello.World.S01E03.xyz
fileSuffix=$(echo "$video" | grep -oP '.+?(?=\.S\d\dE\d\d\.)')

# Series have a specific format so add them to their relevant folder.
# If it doesnt follow the format then its likely a movie so copy it there.
if [ -z "$fileSuffix" ]
then
   fileSuffix="Movies"
fi

# Replace . with space
targetPath=${fileSuffix//./ }

echo "New Folder: " $targetPath >> $logPath/organiseTorrent.log

cd $organisedRootPath
mkdir -p "$targetPath"

echo "Move From: '$rootpath/$video'" " To: '$organisedRootPath/$targetPath/$video'" >> $logPath/organiseTorrent.log
mv "$rootpath/$video" "$organisedRootPath/$targetPath/$video"