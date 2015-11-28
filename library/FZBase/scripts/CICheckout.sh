export LC_ALL="en_US.UTF-8"

cd *
git submodule update --init --recursive
cd Demo
pod install
