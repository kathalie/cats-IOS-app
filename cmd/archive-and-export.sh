# Variables
SCHEME=CatsUI
CONFIG=Release
DEST="generic/platform=iOS"
VERSION="v1.0.0"

WORKSPACE_PATH=".."
WORKSPACE="${WORKSPACE_PATH}/CatsAndModules_KaterynaVerkhohliad.xcworkspace"
ARCHIVES="${WORKSPACE_PATH}/Archives"
ARCHIVE_PATH="${ARCHIVES}/${VERSION}.xcarchive"
EXPORT_OPTIONS_PLIST_TEMPLATE="exportOptionsTemplate.plist"
EXPORT_OPTIONS_PLIST="exportOptions.plist"
INFO_PLIST="${WORKSPACE_PATH}/CatsUI/CatsUI/Info.plist"

# Edit export options
alias PlistBuddy=/usr/libexec/PlistBuddy

cp $EXPORT_OPTIONS_PLIST_TEMPLATE $EXPORT_OPTIONS_PLIST

PlistBuddy -c "set :destination export" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :method development" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :signingStyle manual" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :teamID D85QWSUNYA" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :signingCertificate iPhone Developer: Kateryna Verkhohliad (5BNRV8LHCL)" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "delete :provisioningProfiles:%BUNDLE_ID%" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "add :provisioningProfiles:ua.edu.ukma.apple-env.verkhohliad.CatsUI string 1712dd8b-5713-4f4b-acca-8ee671c5f8bd" $EXPORT_OPTIONS_PLIST


# Read script input parameter and add it to your Info.plist. Values can be either CATS or DOGS
arg1_possible_values=("CATS" "DOGS")

if [[ $(echo ${arg1_possible_values[@]} | fgrep -w $1) ]]
then
  PlistBuddy -c "set :mode ${1}" $INFO_PLIST || \
  (echo "Will add: key :mode" && \
  PlistBuddy -c "add :mode string ${1}" $INFO_PLIST)
else
  echo "Positional argument should be one of the following: ${arg1_possible_values[@]}"
  exit 1
fi


# Clean build folder
xcodebuild clean \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}"


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
-exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"


# Delete temp files
rm $EXPORT_OPTIONS_PLIST
rm -rf $ARCHIVES
