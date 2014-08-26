#!/bin/sh

# 특정 패키지를 컴파일 할때 필요한 패키지를 자동으로 설치해주는 
sudo apt-get build-dep $*
