#!/bin/sh

SERVER_RUNNING=`ps -ax | grep "slimserver\.pl\|slimserver\|squeezecenter\.pl" | grep -v grep | cat`

if [ z"$SERVER_RUNNING" != z ] ; then
    echo "Please stop the SqueezeCenter before running the installer."
    exit 1
fi

SERVER_RUNNING=`ps -ax | grep "System Preferences" | grep -v grep | cat`
if [ z"$SERVER_RUNNING" != z ] ; then
    echo "Please quit System Preferences before running the installer."
    exit 1
fi

if [ -e /Library/PreferencePanes/SLIMP3\ Server.prefPane ] ; then
    rm -r /Library/PreferencePanes/SLIMP3\ Server.prefPane 2>&1
fi

if [ -e ~/Library/PreferencePanes/SLIMP3\ Server.prefPane ] ; then
    rm -r ~/Library/PreferencePanes/SLIMP3\ Server.prefPane 2>&1
fi

if [ -e /Library/PreferencePanes/Slim\ Server.prefPane ] ; then
    rm -r /Library/PreferencePanes/Slim\ Server.prefPane 2>&1
fi

if [ -e ~/Library/PreferencePanes/Slim\ Server.prefPane ] ; then
    rm -r ~/Library/PreferencePanes/Slim\ Server.prefPane 2>&1
fi

if [ -e /Library/PreferencePanes/SqueezeCenter.prefPane ] ; then
    rm -r /Library/PreferencePanes/SqueezeCenter.prefPane 2>&1
fi

if [ -e ~/Library/PreferencePanes/SqueezeCenter.prefPane ] ; then
    rm -r ~/Library/PreferencePanes/SqueezeCenter.prefPane 2>&1
fi

if [ -e /Library/PreferencePanes/SlimServer.prefPane ] ; then
    rm -r /Library/PreferencePanes/SlimServer.prefPane 2>&1
fi

if [ -e ~/Library/PreferencePanes/SlimServer.prefPane ] ; then
    rm -r ~/Library/PreferencePanes/SlimServer.prefPane 2>&1
fi

# Check for OSX 10.5 or later, and strip quarantine information if so
if [ `sw_vers -productVersion | grep -o "^10\.[5678]"` ] ; then
    ditto --noqtn "$1" "$2"
else
    ditto "$1" "$2"
fi

if [ -e "$2" ] ; then
	# install cleanup tool
	ln -s "$2/Contents/Resources/Cleanup.app" "/Applications/SqueezeCenter Cleanup"

	cd "$2/Contents/server"

	# install SC to start at boot time if it hasn't been configured yet
	if [ ! -e ~/Library/Preferences/com.slimdevices.slim.plist ] ; then
		../Resources/create-startup.sh
	fi

	sudo -b -H -u $USER "../Resources/start-server.sh"

    echo "SqueezeCenter installed successfully."
    exit 0
else
    echo "SqueezeCenter install failed."
    exit 1
fi
