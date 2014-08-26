#!/bin/bash

cd /home/changmin/android/system_mr0

if ! [ -e .repo ]; then
    echo "change to build directory"
    exit
fi

#repo sync -j16
repo sync -j4

SYNC_FILE=~/android/cmbuild.txt
SYNC_KST="[cm-10] repo sync: $(LC_TIME=ko_KR.UTF-8 date) ($(LC_TIME=ko_KR.UTF-8 date +%m%d))"
SYNC_UTC="[cm-10] repo sync: $(LC_TIME=en date -u) ($(LC_TIME=en date -u +%m%d))"

echo $SYNC_KST
echo $SYNC_UTC

echo "#########################################" >> $SYNC_FILE
echo $SYNC_KST >> $SYNC_FILE
echo $SYNC_UTC >> $SYNC_FILE

# sed -i \
#     -e "s/\[cm-10\] repo.*/$SYNC_UTC/g" \
#     ~/android/README
