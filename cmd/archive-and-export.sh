# Variables
SCHEME=CatsUI
CONFIG=Release
DEST="generic/platform=iOS"
VERSION="v1.0.0"

WORKSPACE_PATH=".."
WORKSPACE="${WORKSPACE_PATH}/CatsAndModules_KaterynaVerkhohliad.xcworkspace"
ARCHIVES="${WORKSPACE_PATH}/Archives"
ARCHIVE_PATH="${ARCHIVES}/${VERSION}.xcarchive"
PLIST="exportOptions.plist"
INFO_PLIST="${WORKSPACE_PATH}/Info.plist"

# Edit export options
alias PlistBuddy=/usr/libexec/PlistBuddy

cp exportOptionsTemplate.plist $PLIST

PlistBuddy -c "set :destination export" $PLIST
PlistBuddy -c "set :method development" $PLIST
PlistBuddy -c "set :signingStyle manual" $PLIST
PlistBuddy -c "set :teamID D85QWSUNYA" $PLIST
PlistBuddy -c "set :signingCertificate iPhone Developer: Kateryna Verkhohliad (5BNRV8LHCL)" $PLIST
PlistBuddy -c "delete :provisioningProfiles:%BUNDLE_ID%" $PLIST
PlistBuddy -c "add :provisioningProfiles:ua.edu.ukma.apple-env.verkhohliad.CatsUI string 1712dd8b-5713-4f4b-acca-8ee671c5f8bd" $PLIST


# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS
arg1_possible_values=("CATS" "DOGS")

if [[ $(echo ${arg1_possible_values[@]} | fgrep -w $1) ]]
then
  PlistBuddy -c "set :animal ${1}" $INFO_PLIST || \
  (echo "Will add: key :animal" && \
  PlistBuddy -c "add :animal string ${1}" $INFO_PLIST)
else
  echo "Positional argument should be one of the following: ${arg1_possible_values[@]}"
  exit 0
fi


# Clean build folder
xcodebuild clean -workspace "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}"


# Create archive
xcodebuild archive -archivePath "$ARCHIVE_PATH" \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}" \
-destination "${DEST}"


# Export archive
EXPORT_PATH="${WORKSPACE_PATH}/Exported_${1}"

xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${EXPORT_PATH}" \
-exportOptionsPlist "${PLIST}"


# Delete temp files
rm $PLIST
rm -rf $ARCHIVES
