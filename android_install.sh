cat >> ~/.profile <<EOF
PATH="$HOME/android-sdks/tools:$PATH"
PATH="$HOME/android-sdks/platform-tools:$PATH"
EOF

cat >> ~/.xsession <<EOF
gnome-session --session=ubuntu-2d
EOF

sudo apt-get install ia32-libs
