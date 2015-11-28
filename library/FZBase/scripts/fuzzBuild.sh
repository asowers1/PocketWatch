#!/bin/sh    

#############
# Constants 
#############
buildTypeLongBeta="Beta Build"
buildTypeLongRelease="Release Candidate"
buildTypeLongEngineering="Engineering Build"
rootDir="FuzzBuild"
buildAreaDir="${rootDir}/Builds"
profileDir="${rootDir}/Profiles"

#############
# Functions
#############
function fLog
{
    echo "[FB] - \t$1"
}

function getCommandLineArgs
{
    set -- $(getopt erbSv:h "$@");
    while [ $# -gt 0 ]
    do
	case "$1" in
	    (-r) buildType="rc"; buildTypeLong=$buildTypeLongRelease;;
	    (-e) buildType="e";  buildTypeLong=$buildTypeLongEngineering;;
	    (-b) buildType="b";  buildTypeLong=$buildTypeLongBeta;;
	    (-v) versionOverRide="$2";;
	    (-S) skipBuild=1;;
            (-h) usage;;
	    (--) shift; break;;
	    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
	    (*)  break;;
	esac
	shift
    done
}

function loadConfig
{
    if [[ -f ${rootDir}/fuzzBuildConfig.${buildType}  ]]; then 
	source ${rootDir}/fuzzBuildConfig.${buildType}
    else
	createConfig
	source ${rootDir}fuzzBuildConfig.${buildType}
    fi
}

function createConfig
{

    fLog "There is not a config set up for build type: ${buildTypeLong}"

    newConfigPath="${rootDir}/fuzzBuildConfig.${buildType}"
    
    cat <<EOF
# Note this is just an example fill in your own info
buildWorkSpaceName="Wegmans
buildScheme="Wegmans"
buildTarget="Wegmans"
buildConfig="Debug"

buildProfile[0]="AllFuzzProvision"
buildSign[0]="Christopher Luu"

buildProfile[1]="AllFuzzEnterprise"
buildSign[1]="Fuzz Productions, LLC"
EOF
    echo "buildConfig=\"\"" >> ${newConfigPath}
    echo "buildTarget=\"\"" >> ${newConfigPath}
    echo "buildScheme=\"\"" >> ${newConfigPath}
    echo "buildWorkSpaceName=\"\"" >> ${newConfigPath}
    echo "buildProfile[0]=\"\"" >> ${newConfigPath}
    echo "buildProfile[1]=\"\"" >> ${newConfigPath}

    fLog "A blank config has been setup for you at newConfigPath, go fill it out and try again."
    read -p ""

    exit
}

function calulateLastAndNextTags
{

    lastBuildTag=`git tag | xargs -I@ git log --format=format:"%ci %h @%n" -1 @ | sort | grep ${version} | tail -n 1 | sed "s/.* ${version}/${version}/"`
    lastBuildNumber=`echo $lastBuildTag | sed "s/${version}[e|b|rc]//" | sed "s/.*\.//"`

    sprintFromLastBuild=`echo $lastBuildTag | sed "s/${version}[e|b|rc]//" | grep "\." | sed "s/\..*//"`
    currentSprintFromBranch=`git branch | grep \* | sed "s/\* //" | grep "${version}[b|e|rc]" | sed "s/${version}[b|e|rc]//"`

    if [[ $currentSprintFromBranch == "" && $sprintFromLastBuild == ""  ]]; then
	nextBuildNumber=$((lastBuildNumber + 1))
    elif [[ ( ! $currentSprintFromBranch == "" ) && $sprintFromLastBuild == ""  ]]; then
	nextBuildNumber=1
	nextSprintNumber=$((currentSprintFromBranch))
    elif [[  $currentSprintFromBranch == "" && ( ! $sprintFromLastBuild == "" )  ]]; then
	nextBuildNumber=$((lastBuildNumber + 1))
	nextSprintNumber=$((sprintFromLastBuild))
    elif [[  ( ! $currentSprintFromBranch == "" ) && ( ! $sprintFromLastBuild == "" ) ]]; then
	if [[  $currentSprintFromBranch == $sprintFromLastBuild  ]]; then
            nextBuildNumber=$((lastBuildNumber + 1))
            nextSprintNumber=$((sprintFromLastBuild))
	else
            nextBuildNumber=1
            nextSprintNumber=$((currentSprintFromBranch))
	fi
    fi

    if [[ $nextSprintNumber == "" ]]; then
	nextBuildTag="${version}${buildType}${nextBuildNumber}"  # Example {3.2}{b}{1}
    else
	nextBuildTag="${version}${buildType}${nextSprintNumber}.${nextBuildNumber}"  # Example {3.2}{b}{3}.{1}
    fi

    if [[ ! -z "$versionOverRide" ]]; then
	nextBuildTag=${versionOverRide}
    fi
}

function checkForBuildDirectoryAndInit
{
    if [[ ! -d ${rootDir}  ]]; then

	fLog "This project does not seem configured for the build script.  Are you running this from the root directory?  We need to:\n\tCreate FuzzBuild Dir\n\tAdd Builds to gitIgnore.\n\t\tShould we proceed?"
	read -p "(y/n): "
	if [ $REPLY == "y" ];then
	    mkdir -p "${buildAreaDir}"
	    mkdir -p "${profileDir}"
	    echo "${buildAreaDir}/**" >> .gitignore 
	else
	    fLog "Can not proceed no build directory."
	    exit 1
	fi
	
    fi
}

function usage
{
    echo "fuzzBuild -[erbh]

     This script will help configue and then build the deliverables for our three release types.  It should be run for the projects directory and will create the archive files needed for distrubtuion.
     Currently this script: 
          -Take in a user option to create a type of build
          -Will create a config file for the build type if it does not exist (In progress)
          -Will Clean and generate a arichive for the build type using the selected targe and scheme, placing it in xCodes organizer
          -Generate a set of release notes using the git commit message subjects
          -Tag and push the release to the orgin repo

     -e Engineering build.
     -b Beta build (Default)
     -r Release Candidate 
     -S Skip the build phase.
     -h Help (You are reading this)
"
    exit
}

#########
# Main
#########

# Defaults and Project Info
buildType="b"
buildTypeLong=$buildTypeLongBeta

checkForBuildDirectoryAndInit

getCommandLineArgs "$@"
loadConfig

# Setup Environment
infoPlistFile="${buildWorkSpaceName}/${buildWorkSpaceName}-Info.plist"
version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${infoPlistFile}`

calulateLastAndNextTags

fLog "BuildType:      \t${buildTypeLong}"
fLog "Last Build Tag: \t${lastBuildTag}"
fLog "Next Build:     \t${nextBuildTag}"
fLog "Scheme:         \t${buildScheme}"

fLog "Continue?"
read -p "(y/n): "
if [ $REPLY != "y" ];then
    exit
fi

# Check that Profiles Exist
i=0
pwd=`pwd`
for profile in "${buildProfile[@]}"
do
    fLog "Checking that Profile exists: $profile"

    if [ ! -f ${pwd}/${profileDir}/$profile.mobileprovision ]; then
      fLog "Could not find the Profile: ${pwd}/${profileDir}/$profile.mobileprovision"
      exit
    fi

    i=($i+1)
done

# Create Build Dir
buildDirectory=${buildAreaDir}/${nextBuildTag}
mkdir -p $buildDirectory

archiveName="${buildScheme}${nextBuildTag}_${buildConfig}"
archivePath="${HOME}/Library/Developer/Xcode/Archives/FuzzBuild/${buildTarget}/${archiveName}"

if [[ $skipBuild == 1 ]]; then
    fLog "skipping Build"
else 
    fLog "Start Build"
    xcodebuild -workspace ${buildWorkSpaceName}.xcworkspace -archivePath "${archivePath}" -scheme ${buildScheme} -config ${buildConfig}  archive > ${buildDirectory}/buildLog.txt

    if [ $? == 0 ];then
	fLog "Build Succeed"
    else
	fLog "Build Failed: $? see above for errors also check ${buildDirectory}/buildLog.txt"
	exit 1
    fi
fi 
# Update Archive Plist
fLog "Archive Placed in xCode Organizer" #TODO accounce the name of it in organizer

# Copy App
fLog "Copying App ${archivePath}.xcarchive/Products/Applications/${buildScheme}.app/ to  ${buildDirectory}/${archiveName}.app"
cp -r ${archivePath}.xcarchive/Products/Applications/${buildTarget}.app/ ${buildDirectory}/${archiveName}.app/

# Resign
i=0
pwd=`pwd`
for profile in "${buildProfile[@]}"
do
    fLog "Signing App with Profile: $profile"

# 1. Turn the provisioning profile into a plist
# 2. Get all of the names /usr/libexec/PlistBuddy -c "Print DeveloperCertificates" AllFuzzDevelopment.plist | grep -a -o "iPhone.*)"
# 3. Get list of all valid certs security -p codesigning  find-identity -v 
# 4. Compare.. I know this isn't fast.
# 5. Found one great. Otherwise continue

#    rm -fr ${buildDirectory}/Payload/
#    mkdir ${buildDirectory}/Payload/
#    cp ${buildDirectory}/${archiveName}.app/ ${buildDirectory}/Payload/${archiveName}.app/

    /usr/bin/codesign -f -s "${buildSign[$i]}" ${pwd}/${buildDirectory}/${archiveName}.app

    /usr/bin/xcrun -sdk iphoneos PackageApplication -v ${pwd}/${buildDirectory}/${archiveName}.app  -o ${pwd}/${buildDirectory}/${archiveName}\($profile\).ipa  --sign "${buildSign[$i]}" --embed ${pwd}/${profileDir}/$profile.mobileprovision >> ${buildDirectory}/buildLog.txt

    i=($i+1)
done

fLog "Generating Release Notes"
cat << EOF > ${buildDirectory}/email.txt
Links:

What's new and places that need attention:

Known Issues:

Release Notes:
EOF

git log ${lastBuildTag}..HEAD --pretty=format:"%s" | grep -v 'Merge branch' >> ${buildDirectory}/email.txt 

fLog "Build Complete!!!"

fLog "Would you like to tag this: ${nextBuildTag}?"
read -p "(y/n): "
if [ $REPLY == "y" ];then
    git tag -a ${nextBuildTag} -m "${version} ${buildTypeLong} ${nextBuildNumber}"
    git push --tags
fi

# There are three types of builds
#        Beta (Debug)
#        Release Candidate (Debug + RC)
#        Engineering Build (A specific build configurations, maybe specified at the commandline)


# Build Apps
   # Build Debug
   # Build Release (If RC)
   # Get Warnings

# Analyze Build

# Sign Apps

# Zip Source

# Upload to Flow

# Get dSym File

#Create Release Notes
    # For Beta or RC, Notes since last beta or RC
    # Engineering none

#Review and Tag

exit

#availableTargets=`xcodebuild -list 2>/dev/null | sed -n '/Target/ ,/^$/p' | grep -v Target`
#availableSchemes=`xcodebuild -list 2>/dev/null | sed -n '/Schemes/ ,/^$/p' | grep -v Schemes`



