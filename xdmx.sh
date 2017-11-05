#!/bin/sh

startx -- /usr/bin/Xdmx :1 \
+xinerama \
-display laptop:0.0 \
-display desktop:0.0 \
-input desktop:0.0 \
-norender

