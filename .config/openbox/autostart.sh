#/bin/bash

xfce4-panel &
/opt/ibm/ibmsam/bin/ibmsaml -q & 
#/bin/bash /opt/ibm/c4eb/wst/bin/wst-applet & 
feh --bg-scale Pictures/space-wallpaper2-2560x1600.jpg
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)

