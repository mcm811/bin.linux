#!/bin/bash

upload_cm10mr1() {
    DMD=$(date -u +%Y%m%d);cd ~/download/cm-10.1;scp *$DMD*sysfs*.zip* changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/cm-10.1
}

upload-kernel() {
    DMD=$(date -u +%Y%m%d);cd ~/download/kernel;scp *$DMD*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/kernel/
    DMD=$(date -u +%Y%m%d);cd ~/download/kernel;scp k*-10.1-*$DMD*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/kernel/
    DMD=$(date -u +%Y%m%d);cd ~/download/kernel;scp k*-10-*$DMD*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/kernel/
    DMD=$(date -u +%Y%m%d);cd ~/download/kernel;scp *v4*sysfs*$DMD*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/kernel/
    DMD=$(date -u +%Y%m%d);cd ~/download/kernel;scp *v5*sysfs*$DMD*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/kernel/
}

upload_cm10mr0() {
    DMD=$(date -u +%Y%m%d);cd ~/download/cm-10;scp *$DMD*sysfs*.zip* changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/cm-10
}

upload-gapps() {
    DMD=$(date -u +%Y%m%d);cd ~/download/cm-10.1;scp gapps*.zip changmin811@frs.sourceforge.net:/home/frs/project/cm10i9100vsync/cm-10.1
}

sf_mv_old() {
    #cm-10.1
    rm /home/frs/project/cm10i9100vsync/cm-10.1/[ck]*

    # rom only
    rm /home/frs/project/cm10i9100vsync/old/[ck]*
    mv /home/frs/project/cm10i9100vsync/cm-10/[ck]* /home/frs/project/cm10i9100vsync/old/
    # rom & kernel
    rm /home/frs/project/cm10i9100vsync/old/[ckS]*
    mv /home/frs/project/cm10i9100vsync/cm-10/[ckS]* /home/frs/project/cm10i9100vsync/old/
    # kernel only
    mv /home/frs/project/cm10i9100vsync/cm-10/[kS]* /home/frs/project/cm10i9100vsync/old/
}

sfcreate() {
# Interactive Shell sessions persist for 4 hours once created. Authorized developers that have been granted shell access for a project can create/connect to an Interactive Shell with:
# ssh -i PATH-TO-PRIV-KEY -t USER,PROJECT@shell.sourceforge.net create
# ssh -t USER,PROJECT@shell.sourceforge.net create
# shell service : timeleft, shutdown
    ssh -t changmin811,cm10i9100vsync@shell.sourceforge.net create
    ssh changmin811@shell.sourceforge.net
    cd /home/frs/project/cm10i9100vsync
    return $?
}

cmbuild
em ~/bin/sf.sh ~/android/README
sleep 1;konsole -e ssh -t changmin811,cm10i9100vsync@shell.sourceforge.net create > /dev/null 2>&1
echo 'DMD=$(date -u +%Y%m%d);cd ~/download/cm10mr0'
echo 'DMD=$(date -u +%Y%m%d);cd ~/download/cm10mr1'
