echo "Start UI Automation"

DEVICE_NAME="Fuzz Dev | iPhone 6+"
DIR=$(ls)
Automation="$XCS_SOURCE_DIR/$DIR/automation"
PLISTPATH="$XCS_OUTPUT_DIR/Archive.xcarchive/Demo-Info.plist"

Version=$(/usr/libexec/plistbuddy -c  Print:ApplicationProperties:CFBundleVersion:  "$PLISTPATH")
Version="1.1"
VERSIONFOLDER="/Users/fuzzbuild/Public/Drop Box/$Version"

# was failing if the directory is not made first
mkdir "$VERSIONFOLDER"

echo "BEGINNING UI AUTOMATION TEST"
/Applications/Xcode.app/Contents/Developer/usr/bin/instruments -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" \
-w "$DEVICE_NAME" "$XCS_ARCHIVE/Products/Applications/Demo.app" \
-e UIASCRIPT "$Automation/script.js" \
-e UIARESULTSPATH "$VERSIONFOLDER"
echo "UI AUTOMATION TEST CONCLUDED"
