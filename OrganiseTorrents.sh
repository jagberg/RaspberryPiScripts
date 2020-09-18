
#!/bin/bash
# GNU bash, version 4.4.20
defaultLogPath=/tmp/logs

rootpath=$1
video=$2
logPath=${3:-$defaultLogPath}

echo "Path: " $rootpath ", Video: " $video ", Log Path: " $logPath

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

# TODO: Change to local timezone
echo "$(date)" >> $logPath/organiseTorrent.log
echo "New Folder: " $targetPath >> $logPath/organiseTorrent.log

cd $rootpath
mkdir -p "$targetPath"

echo "Move From: '$rootpath/$video'" " To: '$rootpath/$targetPath/$video'" >> $logPath/organiseTorrent.logmv "$rootpath/$video" "$rootpath/$targetPath/$video"