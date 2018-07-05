REV=`git rev-list HEAD | wc -l | awk '{print $1}'`
echo "build version : " $REV

echo $REV
current_date=`date "+%Y%m%d"`
ymd="${current_date}-b${REV}"

cd ./../src/JWLib_qt

versionStr=`cat Resource/version`
jwversion="AWS_${versionStr}_${current_date}_build${REV}"

rm buildversion.h
touch buildversion.h
echo "#ifndef JW_VERSION_H" >> buildversion.h
echo "#define JW_VERSION_H" >> buildversion.h
echo "#define JW_Version \"${jwversion}\"" >> buildversion.h
echo "#endif" >> buildversion.h

cd ../../setup

#复制个性化定制文件
rm ../src/joywok_qt/joywok.ico
cp ./packagedata/aws/joywok.ico ../src/joywok_qt
rm ../src/joywok_qt/joywok.icns
cp ./packagedata/aws/joywok.icns ../src/joywok_qt
rm ../src/joywok_qt/Resources/skin/logomac.png
cp ./packagedata/aws/logomac.png ../src/joywok_qt/Resources/skin
rm ../src/joywok_qt/Resources/skin/logo.png
cp ./packagedata/aws/logo.png ../src/joywok_qt/Resources/skin
rm ../src/joywok_qt/Resources/login/login_joywok.png
cp ./packagedata/aws/login_joywok.png ../src/joywok_qt/Resources/login
rm ../src/joywok_qt/Resources/login/login_joywok@2x.png
cp ./packagedata/aws/login_joywok@2x.png ../src/joywok_qt/Resources/login

qmake=/Users/lixiaoning/Qt5.7.1/5.7/clang_64/bin/qmake

rm -Rf ../buildutils
mkdir ../buildutils
cd ../buildutils
$qmake ../Utils/Utils.pro -spec macx-clang CONFIG+=x86_64 CONFIG-=debug "CONFIG+=release force_debug_info"
/usr/bin/make qmake_all
/usr/bin/make

rm -Rf ../src/buildlib
mkdir ../src/buildlib
cd ../src/buildlib
$qmake ../JWLib_qt/JWLib_qt.pro -spec macx-clang CONFIG+=x86_64 CONFIG-=debug "CONFIG+=release force_debug_info" "DEFINES+=JW_AWS"
/usr/bin/make qmake_all
/usr/bin/make -f Makefile


rm -Rf ../buildjoy
mkdir ../buildjoy
cd ../buildjoy
$qmake ../joywok_qt/joywok_qt.pro -spec macx-clang CONFIG+=x86_64 CONFIG-=debug "CONFIG+=release force_debug_info" "DEFINES+=JW_AWS"
/usr/bin/make qmake_all
/usr/bin/make -f Makefile

cd ./../../bin

rm -rf Joywok.app
cp -r Release/Joywok.app Joywok.app


cp ../setup/packagedata/aws/mac.ini Joywok.app/Contents/Resources/joywok.ini
cp -r ./QDebug/skin Joywok.app/Contents/Resources
cp -r ./QDebug/sound Joywok.app/Contents/Resources

mkdir Joywok.app/Contents/Library
cp -r ~/Program/Library/. Joywok.app/Contents/Library

mkdir Joywok.app/Contents/Frameworks
cp ../src/lib/Release/libqxmpp.0.9.3.dylib Joywok.app/Contents/Frameworks/libqxmpp.0.dylib
cp ../src/lib/Release/libJWLib_qt.1.0.0.dylib Joywok.app/Contents/Frameworks/libJWLib_qt.1.dylib
cp ../src/lib/Release/libUGlobalHotkey.1.0.0.dylib Joywok.app/Contents/Frameworks/libUGlobalHotkey.1.dylib

install_name_tool -change "libqxmpp.0.dylib" "@executable_path/../Frameworks/libqxmpp.0.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libJWLib_qt.1.dylib" "@executable_path/../Frameworks/libJWLib_qt.1.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libUGlobalHotkey.1.dylib" "@executable_path/../Frameworks/libUGlobalHotkey.1.dylib"  Joywok.app/Contents/MacOS/Joywok
install_name_tool -change "libqxmpp.0.dylib" "@executable_path/../Frameworks/libqxmpp.0.dylib"  Joywok.app/Contents/Frameworks/libJWLib_qt.1.dylib

/Users/lixiaoning/Qt5.7.1/5.7/clang_64/bin/macdeployqt Joywok.app -qmldir=/Users/lixiaoning/Program/desktopclient/src/joywok_qt/Resources/timeline

python ../setup/codesign.py

