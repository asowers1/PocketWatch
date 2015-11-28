#!/bin/bash

# Meant for post archive run script. Borrows heavily from:
# https://gist.github.com/c0diq/2213571

export LC_CTYPE=C 
export LANG=C

# Setup logging stuff...
LOG="/tmp/package.log"
/bin/rm -f $LOG

echo >> $LOG
 
echo "CODE_SIGN_IDENTITY: $CODE_SIGN_IDENTITY" >> $LOG
echo "WRAPPER_NAME: $WRAPPER_NAME" >> $LOG
echo "ARCHIVE_DSYMS_PATH: $ARCHIVE_DSYMS_PATH" >> $LOG
echo "ARCHIVE_PRODUCTS_PATH: $ARCHIVE_PRODUCTS_PATH" >> $LOG
echo "DWARF_DSYM_FILE_NAME: $DWARF_DSYM_FILE_NAME" >> $LOG
echo "INSTALL_PATH: $INSTALL_PATH" >> $LOG
echo "PRODUCT_NAME: $PRODUCT_NAME" >> $LOG

# Ask if we need to proceed to package the application using an AppleScript dialog in Xcode:
SHOULD_PACKAGE=`osascript -e "tell application \"Xcode\"" -e "set noButton to \"No, Thanks\"" -e "set yesButton to \"Yes!\"" -e "set upload_dialog to display dialog \"Do you want to package this build?\" buttons {noButton, yesButton} default button yesButton with icon 1" -e "set button to button returned of upload_dialog" -e "if button is equal to yesButton then" -e "return 1" -e "else" -e "return 0" -e "end if" -e "end tell"`

# Exit this script if the user indicated we shouldn't upload:
if [ "$SHOULD_PACKAGE" = "0" ]; then
    echo "User indicated not to package this archive. Quitting." >> $LOG
    exit 0
fi #SHOULD_PACKAGE

# Build paths from build settings environment vars:
DSYM_PATH="$ARCHIVE_DSYMS_PATH"
APP="$ARCHIVE_PRODUCTS_PATH/$INSTALL_PATH/$WRAPPER_NAME"

# Ask to auto sign
SHOULD_AUTOSIGN=`osascript -e "tell application \"Xcode\"" -e "set noButton to \"No, Thanks\"" -e "set yesButton to \"Yes!\"" -e "set autosign_dialog to display dialog \"Do you want to automatically sign?\" buttons {noButton, yesButton} default button yesButton with icon 1" -e "set button to button returned of autosign_dialog" -e "if button is equal to yesButton then" -e "return 1" -e "else" -e "return 0" -e "end if" -e "end tell"`

if [ "$SHOULD_AUTOSIGN" = "0" ]; then

    # Signing
    echo "Finding signing identities..." >> $LOG

    # Get all the user's code signing identities. Filter the response to get a neat list of quoted strings:
    SIGNING_IDENTITIES_LIST=`security find-identity -v -p codesigning | egrep -oE '"[^"]+"'`
    echo >> $LOG
    echo "Found identities:" >> $LOG
    echo "$SIGNING_IDENTITIES_LIST" >> $LOG

    # Replace the newline characters in the list with commas and remove the last comma:
    SIGNING_IDENTITIES_COMMA_SEPARATED_LIST=`echo "$SIGNING_IDENTITIES_LIST" | tr '\n' ',' | sed 's/,$//'`
    # Present dialog with list of code signing identites and let the user pick one. The identity that from the build settings is selected by default.
    CODE_SIGN_IDENTITY=`osascript -e "tell application \"Xcode\"" -e "set selected_identity to {choose from list {$SIGNING_IDENTITIES_COMMA_SEPARATED_LIST} with prompt \"Choose code signing identity:\" default items {\"$CODE_SIGN_IDENTITY\"}}" -e "end tell" -e "return selected_identity"`

    echo >> $LOG
    if [ "$CODE_SIGN_IDENTITY" = "false" ]; then
        echo "User cancelled." >> $LOG
        exit 0
    fi

    TEMP_MOBILEPROVISION_PLIST_PATH=/tmp/mobileprovision.plist
    TEMP_CERTIFICATE_PATH=/tmp/certificate.cer

    MOBILEDEVICE_PROVISIONING_PROFILES_FOLDER="${HOME}/Library/MobileDevice/Provisioning Profiles"
    MATCHING_PROFILES_LIST=""
    MATCHING_NAMES_LIST=""
    cd "$MOBILEDEVICE_PROVISIONING_PROFILES_FOLDER"
    for MOBILEPROVISION_FILENAME in *.mobileprovision
    do
        # Use sed to rid the signature data that is padding the plist and store clean plist to temp file:
        sed -n '/<!DOCTYPE plist/,/<\/plist>/ p' \
            < "$MOBILEPROVISION_FILENAME" \
            > "$TEMP_MOBILEPROVISION_PLIST_PATH"
        # The plist root dict contains an array called 'DeveloperCertificates'. It seems to contain one element with the certificate data. Dump to temp file:
        /usr/libexec/PlistBuddy -c 'Print DeveloperCertificates:0' $TEMP_MOBILEPROVISION_PLIST_PATH > $TEMP_CERTIFICATE_PATH
        # Get the common name (CN) from the certificate (regex capture between 'CN=' and '/OU'):
        MOBILEPROVISION_IDENTITY_NAME=`openssl x509 -inform DER -in $TEMP_CERTIFICATE_PATH -subject -noout | perl -n -e '/CN=(.+)\/OU/ && print "$1"'`

        if [ "$CODE_SIGN_IDENTITY" = "$MOBILEPROVISION_IDENTITY_NAME" ]; then
            # Yay, this mobile provisioning profile matches up with the selected signing identity, let's continue...
            # Get the name of the provisioning profile:
            MOBILEPROVISION_PROFILE_NAME=`/usr/libexec/PlistBuddy -c 'Print Name' $TEMP_MOBILEPROVISION_PLIST_PATH`         
            MATCHING_PROFILES_LIST=`echo "$MATCHING_PROFILES_LIST\"$MOBILEPROVISION_PROFILE_NAME\"|\"$MOBILEPROVISION_FILENAME\","`
            MATCHING_NAMES_LIST=`echo "$MATCHING_NAMES_LIST\"$MOBILEPROVISION_PROFILE_NAME\","`
        fi
    done
    # Remove last comma:
    MATCHING_NAMES_LIST=`echo "$MATCHING_NAMES_LIST" | sed 's/,$//'`
    # Remove last pipe:
    MATCHING_PROFILES_LIST=`echo "$MATCHING_PROFILES_LIST" | sed 's/,$//'`

    # Add the (default) value for using the existing embedded.mobileprovision:
    USE_EXISTING_PROFILE="\"Don't overwrite the current provisioning profile\""
    MATCHING_NAMES_LIST=`echo "$USE_EXISTING_PROFILE,$MATCHING_NAMES_LIST"`
    # Present dialog with list of matching provisioning profiles and let the user pick one.
    SELECTED_PROFILE_NAME=`osascript -e "tell application \"Xcode\"" -e "set selected_profile to {choose from list {$MATCHING_NAMES_LIST} with prompt \"Choose provisioning profile:\" default items {$USE_EXISTING_PROFILE}}" -e "end tell" -e "return selected_profile"`
    if [ "$SELECTED_PROFILE_NAME" = "false" ]; then
        echo "User cancelled." >> $LOG
        exit 0
    fi

    SELECTED_PROFILE_FILE=`echo "$MATCHING_PROFILES_LIST" | tr "," "\n" | grep "$SELECTED_PROFILE_NAME" | tr "|" "\n" | sed -n 2p`
else
    # Autosign

    echo "Finding current signature to automatically sign..." >> $LOG
    echo >> $LOG

    CODE_SIGN_IDENTITY=`codesign -d -vvv "$APP" 2>&1 | grep -a -o "iPhone.*"`
    SELECTED_PROFILE_FILE=""
fi

echo "Selected code signing identity:" >> $LOG
echo "$CODE_SIGN_IDENTITY" >> $LOG

echo >> $LOG
echo "Selected provisioning profile:" >> $LOG
if [ "$SELECTED_PROFILE_FILE" != "" ]; then
    # Remove quotes (needed before for AppleScript): 
    SELECTED_PROFILE_FILE=`echo "$SELECTED_PROFILE_FILE" | tr -d "\""`
    EMBED_PROFILE="$MOBILEDEVICE_PROVISIONING_PROFILES_FOLDER/$SELECTED_PROFILE_FILE"
    echo "$SELECTED_PROFILE_FILE : $SELECTED_PROFILE_NAME" >> $LOG
    echo "$EMBED_PROFILE" >> $LOG
else
    EMBED_PROFILE="$APP/embedded.mobileprovision"
    echo "None selected. Keeping existing embedded.mobileprovision file:" >> $LOG
    echo "$EMBED_PROFILE" >> $LOG
fi

# Ask the user where to save the IPA
SELECTED_FILE=`osascript -e "tell application \"Xcode\"" -e "set selected_file to {choose file name with prompt \"Where to save the IPA file?\" default name \"$PRODUCT_NAME.ipa\"}" -e "end tell" -e "return POSIX path of selected_file"`
echo >> $LOG
echo "Selected destination filename:" >> $LOG
echo $SELECTED_FILE >> $LOG

/usr/bin/xcrun -sdk iphoneos PackageApplication "${APP}" -o "${SELECTED_FILE}" --embed "$EMBED_PROFILE" --sign "${CODE_SIGN_IDENTITY}" >> $LOG 2>&1
