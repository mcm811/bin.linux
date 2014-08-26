#!/bin/bash

if cat /sys/block/sda/queue/scheduler | grep row > /dev/null; then
    sudo sh -c "echo row >  /sys/block/sda/queue/scheduler"
elif cat /sys/block/sda/queue/scheduler | grep deadline > /dev/null; then
    sudo sh -c "echo deadline >  /sys/block/sda/queue/scheduler"
fi
if cat /sys/block/sdb/queue/scheduler | grep cfq > /dev/null; then
    sudo sh -c "echo cfq > /sys/block/sdb/queue/scheduler"
fi
echo "sda: $(cat /sys/block/sda/queue/scheduler)"
echo "sdb: $(cat /sys/block/sdb/queue/scheduler)"
