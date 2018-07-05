cd ../bin

rm -rf Joywok.app

cp -r QDebug/Joywok.app Joywok.app

rm Joywok.app/Contents/Resources/joywok.ini
cp ../setup/packagedata/aws/mac.ini Joywok.app/Contents/Resources/joywok.ini
rm -rf Joywok.app/Contents/Resources/skin/*
mkdir Joywok.app/Contents/Resources/skin
cp -r ./QDebug/skin/. Joywok.app/Contents/Resources/skin
rm -rf Joywok.app/Contents/Resources/sound/*
mkdir Joywok.app/Contents/Resources/sound
cp -r ./QDebug/sound/. Joywok.app/Contents/Resources/sound

mkdir Joywok.app/Contents/Library
cp -r ~/Program/Library/. Joywok.app/Contents/Library


mkdir Joywok.app/Contents/Frameworks
rm Joywok.app/Contents/Frameworks/libqxmpp_d.0.dylib
cp ../src/lib/Debug/libqxmpp_d.0.9.3.dylib Joywok.app/Contents/Frameworks/libqxmpp_d.0.dylib
rm Joywok.app/Contents/Frameworks/libJWLib_qt.1.dylib
cp ../src/lib/Debug/libJWLib_qt.1.0.0.dylib Joywok.app/Contents/Frameworks/libJWLib_qt.1.dylib
rm Joywok.app/Contents/Frameworks/libUGlobalHotkey.1.dylib
cp ../src/lib/Debug/libUGlobalHotkey.1.0.0.dylib Joywok.app/Contents/Frameworks/libUGlobalHotkey.1.dylib

install_name_tool -change "libqxmpp_d.0.dylib" "@executable_path/../Frameworks/libqxmpp_d.0.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libJWLib_qt.1.dylib" "@executable_path/../Frameworks/libJWLib_qt.1.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libUGlobalHotkey.1.dylib" "@executable_path/../Frameworks/libUGlobalHotkey.1.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libqxmpp_d.0.dylib" "@executable_path/../Frameworks/libqxmpp_d.0.dylib"  Joywok.app/Contents/Frameworks/libJWLib_qt.1.dylib

# install_name_tool -change "@rpath/VLCQtCore.framework/Versions/1.2.0/VLCQtCore" "/usr/local/Frameworks/VLCQtCore.framework/Versions/1.2.0/VLCQtCore" Joywok.app/Contents/MacOS/Joywok
# install_name_tool -change "@rpath/VLCQtWidgets.framework/Versions/1.2.0/VLCQtWidgets" "/usr/local/Frameworks/VLCQtWidgets.framework/Versions/1.2.0/VLCQtWidgets" Joywok.app/Contents/MacOS/Joywok

TMPDIR=$(pwd);

/Users/lixiaoning/Qt5.7.1/5.7/clang_64/bin/macdeployqt Joywok.app -qmldir=/Users/lixiaoning/Program/desktopclient/src/joywok_qt/Resources/timeline

cp -r ../lib/VLCQtCore.framework Joywok.app/Contents/Frameworks
rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/Headers
rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/Resources
rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/VLCQtCore
rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/Versions/Current
cp -r /usr/local/Frameworks/VLCQtWidgets.framework Joywok.app/Contents/Frameworks
rm -rf Joywok.app/Contents/Frameworks/VLCQtWidgets.framework/Headers
rm -rf Joywok.app/Contents/Frameworks/VLCQtWidgets.framework/Resources
rm -rf Joywok.app/Contents/Frameworks/VLCQtWidgets.framework/VLCQtWidgets
rm -rf Joywok.app/Contents/Frameworks/VLCQtWidgets.framework/Versions/Current


# cp /usr/local/Frameworks/VLCQtCore.framework/Versions/1.2.0/lib/vlc/plugins/*.dylib Joywok.app/Contents/PlugIns
# cp /usr/local/Frameworks/VLCQtCore.framework/Versions/1.2.0/lib/*.dylib Joywok.app/Contents/Frameworks

rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/Versions/1.2.0/Headers
# rm -rf Joywok.app/Contents/Frameworks/VLCQtCore.framework/Versions/1.2.0/lib
rm -rf Joywok.app/Contents/Frameworks/VLCQtWidgets.framework/Versions/1.2.0/Headers

###
cd Joywok.app/Contents/Frameworks/VLCQtCore.framework/Versions
ln -s 1.2.0 Current
cd ..
ln -s Versions/Current/Resources Resources
ln -s Versions/Current/VLCQtCore VLCQtCore


cd ../VLCQtWidgets.framework/Versions
ln -s 1.2.0 Current
cd ..
ln -s Versions/1.2.0/Resources Resources
ln -s Versions/1.2.0/VLCQtWidgets VLCQtWidgets



cd $TMPDIR

python ../setup/codesign.py

