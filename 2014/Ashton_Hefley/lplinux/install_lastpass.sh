#!/bin/bash
command -v sudo > /dev/null || {
  echo "This script requires sudo.  Please install sudo."
  exit 1
}
command -v wget > /dev/null || {
  command -v apt-get > /dev/null && sudo apt-get install wget
  command -v yum > /dev/null && sudo yum install wget
  command -v zypper > /dev/null && sudo zypper install wget
}
command -v wget > /dev/null || {
  echo "This script requires wget.  Please install wget."
  exit 1
}
command -v unzip > /dev/null || {
  command -v apt-get > /dev/null && sudo apt-get install unzip
  command -v yum > /dev/null && sudo yum install unzip
  command -v zypper > /dev/null && sudo zypper install unzip
}
command -v unzip > /dev/null || {
  echo "This script requires unzip.  Please install unzip."
  exit 1
}

mkdir -p /tmp/lpinstall
cp -f nplastpass nplastpass64 /tmp/lpinstall
cd /tmp/lpinstall

if [ -d ~/.mozilla/firefox ]
then
  rm -f lp_linux.xpi
  wget https://lastpass.com/lp_linux.xpi
  if [ $? != 0 ]
  then
    echo "Failed to download Firefox extension!"
    exit
  fi

  if [ -f ~/.mozilla/firefox/profiles.ini ]
  then
    for i in `egrep "^Path=.*" ~/.mozilla/firefox/profiles.ini | cut -c 6-`
    do
      i=~/.mozilla/firefox/$i
      if [ -d $i ]
      then
        mkdir -p "$i/extensions/support@lastpass.com"
        unzip -o "lp_linux.xpi" -d "$i/extensions/support@lastpass.com"
      fi
    done
  fi
fi

rm -f lpchrome_linux.crx
wget https://lastpass.com/lpchrome_linux.crx
if [ $? != 0 ]
then
  echo "Failed to download Chrome extension!"
  exit
fi

if [ -d ~/.config/google-chrome -o -d ~/.config/chromium ]
then
  mkdir -p ~/.lastpass
  #sudo mkdir -p /opt/google/chrome/
  #CRX=/opt/google/chrome/lpchrome.crx
  #sudo cp lpchrome_linux.crx $CRX
  #VERSION=`unzip -c $CRX manifest.json 2>/dev/null | egrep "\"version\"" | egrep -o [0-9.]+`
  #echo "{ \"external_crx\": \"$CRX\", \"external_version\": \"$VERSION\" }" > hdokiejnpimakedhajhdlcegeplioahd.json
  #sudo mkdir -p /opt/google/chrome/extensions/
  #sudo chmod a+rx /opt/google/chrome/extensions/
  #sudo cp -f hdokiejnpimakedhajhdlcegeplioahd.json /opt/google/chrome/extensions/
  #sudo chmod a+r /opt/google/chrome/extensions/hdokiejnpimakedhajhdlcegeplioahd.json
  #sudo mkdir -p /usr/share/chromium/extensions/
  #sudo chmod a+rx /usr/share/chromium/extensions/
  #sudo mv -f hdokiejnpimakedhajhdlcegeplioahd.json /usr/share/chromium/extensions/
  #sudo chmod a+r /usr/share/chromium/extensions/hdokiejnpimakedhajhdlcegeplioahd.json

  echo "{ \"ExtensionInstallSources\": [\"https://lastpass.com/*\", \"https://*.lastpass.com/*\", \"https://*.cloudfront.net/lastpass/*\"] }" > lastpass_policy.json
  sudo mkdir -p /etc/opt/chrome/policies/managed/
  sudo chmod a+rx /etc/opt/chrome/policies/managed/
  sudo cp -f lastpass_policy.json /etc/opt/chrome/policies/managed/
  sudo chmod a+r /etc/opt/chrome/policies/managed/lastpass_policy.json
  sudo mkdir -p /etc/chromium/policies/managed/
  sudo chmod a+rx /etc/chromium/policies/managed/
  sudo mv -f lastpass_policy.json /etc/chromium/policies/managed/
  sudo chmod a+r /etc/chromium/policies/managed/lastpass_policy.json

  if [ `uname -m` = "x86_64" ]
  then
    NPLASTPASS=nplastpass64
  else
    NPLASTPASS=nplastpass
  fi

  echo "{ \"name\": \"com.lastpass.nplastpass\", \"description\": \"LastPass\", \"path\": \"/etc/opt/chrome/native-messaging-hosts/$NPLASTPASS\", \"type\": \"stdio\", \"allowed_origins\": [ \"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/\", \"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/\", \"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/\", \"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/\" ] }" > com.lastpass.nplastpass.json
  sudo mkdir -p  /etc/opt/chrome/native-messaging-hosts/
  sudo chmod a+rx  /etc/opt/chrome/native-messaging-hosts/
  sudo cp -f $NPLASTPASS /etc/opt/chrome/native-messaging-hosts/
  sudo chmod a+rx /etc/opt/chrome/native-messaging-hosts/$NPLASTPASS
  sudo mv -f com.lastpass.nplastpass.json /etc/opt/chrome/native-messaging-hosts/
  sudo chmod a+r /etc/opt/chrome/native-messaging-hosts/com.lastpass.nplastpass.json

  echo "{ \"name\": \"com.lastpass.nplastpass\", \"description\": \"LastPass\", \"path\": \"/etc/chromium/native-messaging-hosts/$NPLASTPASS\", \"type\": \"stdio\", \"allowed_origins\": [ \"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/\", \"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/\", \"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/\" ] }" > com.lastpass.nplastpass.json
  sudo mkdir -p /etc/chromium/native-messaging-hosts/
  sudo chmod a+rx /etc/chromium/native-messaging-hosts/
  sudo cp -f $NPLASTPASS /etc/chromium/native-messaging-hosts/
  sudo chmod a+rx /etc/chromium/native-messaging-hosts/$NPLASTPASS
  sudo mv -f com.lastpass.nplastpass.json /etc/chromium/native-messaging-hosts/
  sudo chmod a+r /etc/chromium/native-messaging-hosts/com.lastpass.nplastpass.json

  HOME=~

  echo "{ \"name\": \"com.lastpass.nplastpass\", \"description\": \"LastPass\", \"path\": \"$HOME/.config/google-chrome/NativeMessagingHosts/$NPLASTPASS\", \"type\": \"stdio\", \"allowed_origins\": [ \"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/\", \"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/\", \"chrome-extension://hnjalnkldgigidggphhmacmimbdlafdo/\", \"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/\" ] }" > com.lastpass.nplastpass.json
  mkdir -p  ~/.config/google-chrome/NativeMessagingHosts/
  chmod a+rx  ~/.config/google-chrome/NativeMessagingHosts/
  cp -f $NPLASTPASS ~/.config/google-chrome/NativeMessagingHosts/
  chmod a+rx ~/.config/google-chrome/NativeMessagingHosts/$NPLASTPASS
  mv -f com.lastpass.nplastpass.json ~/.config/google-chrome/NativeMessagingHosts/
  chmod a+r ~/.config/google-chrome/NativeMessagingHosts/com.lastpass.nplastpass.json

  echo "{ \"name\": \"com.lastpass.nplastpass\", \"description\": \"LastPass\", \"path\": \"$HOME/.config/chromium/NativeMessagingHosts/$NPLASTPASS\", \"type\": \"stdio\", \"allowed_origins\": [ \"chrome-extension://hdokiejnpimakedhajhdlcegeplioahd/\", \"chrome-extension://debgaelkhoipmbjnhpoblmbacnmmgbeg/\", \"chrome-extension://hgnkdfamjgnljokmokheijphenjjhkjc/\" ] }" > com.lastpass.nplastpass.json
  mkdir -p ~/.config/chromium/NativeMessagingHosts/
  chmod a+rx ~/.config/chromium/NativeMessagingHosts/
  cp -f $NPLASTPASS ~/.config/chromium/NativeMessagingHosts/
  chmod a+rx ~/.config/chromium/NativeMessagingHosts/$NPLASTPASS
  mv -f com.lastpass.nplastpass.json ~/.config/chromium/NativeMessagingHosts/
  chmod a+r ~/.config/chromium/NativeMessagingHosts/com.lastpass.nplastpass.json
fi

mkdir -p chrome
unzip -o "lpchrome_linux.crx" -d "chrome" 2>/dev/null
if [ -d /usr/lib64/opera/plugins/ ]
then
  sudo cp -f chrome/libnplastpass64.so /usr/lib64/opera/plugins/
  sudo chmod a+r /usr/lib64/opera/plugins/libnplastpass64.so
fi
if [ -d /usr/lib64/opera-next/plugins/ ]
then
  sudo cp -f chrome/libnplastpass64.so /usr/lib64/opera-next/plugins/
  sudo chmod a+r /usr/lib64/opera-next/plugins/libnplastpass64.so
fi
if [ -d /usr/lib64/operanext/plugins/ ]
then
  sudo cp -f chrome/libnplastpass64.so /usr/lib64/operanext/plugins/
  sudo chmod a+r /usr/lib64/operanext/plugins/libnplastpass64.so
fi
if [ -d /usr/lib64/ ]
then
  sudo mkdir -p /usr/lib64/mozilla/plugins/
  sudo cp -f chrome/libnplastpass64.so /usr/lib64/mozilla/plugins/
  sudo chmod a+r /usr/lib64/mozilla/plugins/libnplastpass64.so
fi
if [ `uname -m` = "x86_64" ]
then
  NPLASTPASS=libnplastpass64.so
else
  NPLASTPASS=libnplastpass.so
fi
if [ -d /usr/lib/opera/plugins/ ]
then
  sudo cp -f chrome/$NPLASTPASS /usr/lib/opera/plugins/
  sudo chmod a+r /usr/lib/opera/plugins/$NPLASTPASS
fi
if [ -d /usr/lib/opera-next/plugins/ ]
then
  sudo cp -f chrome/$NPLASTPASS /usr/lib/opera-next/plugins/
  sudo chmod a+r /usr/lib/opera-next/plugins/$NPLASTPASS
fi
if [ -d /usr/lib/operanext/plugins/ ]
then
  sudo cp -f chrome/$NPLASTPASS /usr/lib/operanext/plugins/
  sudo chmod a+r /usr/lib/operanext/plugins/$NPLASTPASS
fi
if [ -d /usr/lib/ -a ! -d /usr/lib64/ ]
then
  sudo mkdir -p /usr/lib/mozilla/plugins/
  sudo cp -f chrome/$NPLASTPASS /usr/lib/mozilla/plugins/
  sudo chmod a+r /usr/lib/mozilla/plugins/$NPLASTPASS
else
  sudo rm -f /usr/lib/mozilla/plugins/libnplastpass64.so
fi

command -v opera > /dev/null && {
  opera https://lastpass.com/dl/ &
}

command -v google-chrome > /dev/null && {
  google-chrome https://lastpass.com/dl/inline/?full=1 &
}

command -v chromium-browser > /dev/null && {
  chromium-browser https://lastpass.com/dl/inline/?full=1 &
}

echo ""
echo "LastPass installation complete!"
