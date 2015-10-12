#!/bin/sh

PATH=/usr/bin:/bin ; export PATH

# variables that may be replaced upstream
DOBINARY=1
COMPANY=LastPass
FIREFOX_ID="support@lastpass.com"
CHROME_ID="hdokiejnpimakedhajhdlcegeplioahd"
PLUGIN_NAME="nplastpass.plugin"

DOOPERA=0
DOCHROME=1
DOFIREFOX=1
RESTART_SAFARI=0
RESTART_FIREFOX=0
RESTART_CHROME=0
RESTART_OPERA=0

######################################################################
## delete files
HOMEDIRS="$HOME"
for i in /Users/*; do
  # edge case: non-dirs in /Users
  if [ "$i" != $HOME -a -d "$i" ]
  then
    # edge case: deleted users get their homedirs renamed to be 'USER (Deleted)'
    # so, just skip dirs with spaces in them.
    if [ `/bin/expr "$i" : '.* .*'` -eq 0 ]; then
      HOMEDIRS="$HOMEDIRS $i"
    fi
  fi
done

for HOMEDIR in $HOMEDIRS; do
  ## SAFARI
  /bin/rm -rf $HOMEDIR/Library/Safari/Extensions/*LastPass*.safariextz
  /bin/rm -rf $HOMEDIR/Library/Application\ Support/SIMBL/Plugins/LastPass.bundle

  ## FIREFOX
  if [ -d "$HOMEDIR/Library/Application Support/Firefox/Profiles" ]; then
    for i in $HOMEDIR/Library/Application\ Support/Firefox/Profiles/*; do
        /bin/rm -rf "$i/extensions/$FIREFOX_ID"
    done
    /bin/rm -rf "$HOMEDIR/Library/Application Support/LastPass"
  fi

  ## CHROME
  # this will be present if a pre-build was installed manually by user, but
  # this appears to be insufficient
  # /bin/rm -rf $HOMEDIR/Library/Application\ Support/Google/Chrome/Default/Extensions/${CHROME_ID}/
done

## CHROME
if [ -f "/Applications/Google Chrome.app/Contents/Extensions/external_extensions.json" ]; then
    if [ -f "/Library/Application Support/SIMBL/Plugins/LastPass.bundle/Contents/Resources/chrome_json" ]; then
      /Library/Application\ Support/SIMBL/Plugins/LastPass.bundle/Contents/Resources/chrome_json remove
    elif [ -f /Library/Application\ Support/LastPass/Contents/Resources/chrome_json ]; then
      /Library/Application\ Support/LastPass/Contents/Resources/chrome_json remove
    fi
fi
/bin/rm -f /Library/Application\ Support/Google/Chrome/External\ Extensions/${CHROME_ID}.json

## BINARY PLUGIN
if [ "$DOBINARY" = "1" ]; then
   /bin/rm -rf /Library/Internet\ Plug-Ins/$PLUGIN_NAME
fi

rm -f /Library/Google/Chrome/NativeMessagingHosts/com.lastpass.nplastpass.json
rm -rf /Library/Google/Chrome/NativeMessagingHosts/nplastpass.app/

rm -f /Library/Application\ Support/Chromium/NativeMessagingHosts/com.lastpass.nplastpass.json
rm -rf /Library/Application\ Support/Chromium/NativeMessagingHosts/nplastpass.app/

/bin/rm -rf /Library/Application\ Support/SIMBL/Plugins/LastPass.bundle

/bin/rm -rf "/Library/Application Support/LastPass"


launchctl remove com.lastpass.LastPassHelper.plist
rm -f ~/Library/LaunchAgents/com.lastpass.LastPassHelper.plist
/usr/bin/killall LastPassHelper


######################################################################
## kill web-browsers, and restart 
# presume only the current user is running these browsers
/bin/ps auxww | /usr/bin/grep /Applications/Safari.app 2>/dev/null | /usr/bin/grep -v grep > /dev/null 2>&1
if [ $? -eq 0 ]; then
  RESTART_SAFARI=1
fi
if [ "$DOFIREFOX" -eq 1 ]; then
  /bin/ps auxww | /usr/bin/grep /Applications/Firefox.app 2>/dev/null | /usr/bin/grep -v grep > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    RESTART_FIREFOX=1
  fi
fi
if [ "$DOCHROME" -eq 1 ]; then
  /bin/ps auxww | /usr/bin/grep /Applications/Google\ Chrome.app 2>/dev/null | /usr/bin/grep -v grep > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    RESTART_CHROME=1
  fi
fi
## opera ?

( /usr/bin/killall Safari || exit 0 )
( /usr/bin/killall Camino || exit 0 )

if [ "$DOFIREFOX" -eq 1 ]; then
  ( /usr/bin/killall firefox-bin|| exit 0 )
  ( /usr/bin/killall firefox || exit 0 )
fi
if [ "$DOCHROME" -eq 1 ]; then
  ( /usr/bin/killall "Google Chrome" || exit 0 )
  ( /usr/bin/killall "Google Chrome Helper" || exit 0 )
fi
# opera?

/bin/sleep 1

# force-kill the browser on slow acting systems
( /usr/bin/killall -9 Safari || exit 0 )
( /usr/bin/killall -9 Camino || exit 0 )
if [ "$DOFIREFOX" -eq 1 ]; then
  ( /usr/bin/killall -9 firefox-bin|| exit 0 )
fi
if [ "$DOCHROME" -eq 1 ]; then
  ( /usr/bin/killall -9 "Google Chrome" || exit 0 )
  ( /usr/bin/killall -9 "Google Chrome Helper" || exit 0 )
fi
# opera?

# need a little wait here for the kill to complete before
# a restart can occur
sleep 2
cd $HOME

# now, only restart the web-browsers that were running at the time
# this job started, as the user likely wants to see it again
if [ $RESTART_SAFARI -eq 1 ]; then
  (/usr/bin/open -g /Applications/Safari.app & )
fi
if [ $RESTART_FIREFOX -eq 1 ]; then
  (/usr/bin/open -g /Applications/Firefox.app &)
fi
if [ $RESTART_CHROME -eq 1 ]; then
  (/usr/bin/open -g /Applications/Google\ Chrome.app &)
fi
#if [ $RESTART_OPERA -eq 1 ]; then
#  (/usr/bin/open /Applications/Opera.app)
#fi

exit 0
