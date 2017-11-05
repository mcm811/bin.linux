#!/bin/sh

[ -z $1 ] && echo "signapk: no args" && exit 1
[ ! -f $1 ] && echo "signapk: No such file" && exit 1

SIGNAPK=/home/changmin/bin/signapk_key
TMP_ZIP=/home/changmin/tmp/$(basename $1)
TMP_ZIP=${TMP_ZIP%\.*}_signed.${TMP_ZIP##*.}

SIGNJAR="java -jar $SIGNAPK/signapk.jar $SIGNAPK/certificate.pem $SIGNAPK/key.pk8 $1 $TMP_ZIP"

#echo $SIGNJAR
$SIGNJAR && mv -f $TMP_ZIP $1 && echo "Signapk: $(basename $1) OK"
