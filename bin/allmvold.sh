#!/bin/bash

cd /home/users/c/ch/changmin811
for i in mr0 mr1 kernel; do
    cd $i
    mvold
done
cd -
clean.sh
