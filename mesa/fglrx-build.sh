echo 7z x ~/download/amd-driver-installer-catalyst-13.1-linux-x86.x86_64.zip
echo sh ./amd-driver-installer-*-x86.x86_64.run --listpkg
sh ./amd-driver-installer-*-x86.x86_64.run --buildpkg Ubuntu/precise
sudo dpkg -i *.deb
sudo aticonfig -f --initial
rm *.run *.changes
