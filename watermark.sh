#! /bin/bash
DRIVER=$(find /usr/lib*/xorg/modules/drivers -name "fglrx_drv.so" | head -1)
SEDCMD=$(objdump -d $DRIVER | awk '/call/&&/EnableLogo/ {printf "s|\\x%s\\x%s\\x%s\\x%s\\x%s|\\x90\\x90\\x90\\x90\\x90|;", $2, $3, $4, $5, $6}')
cp $DRIVER{,.org}
sed -i "$SEDCMD" ${DRIVER}
