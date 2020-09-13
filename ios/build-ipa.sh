# run this in ios directory
mkdir -p Payload
cp -pr ../build/ios/iphoneos/Runner.app Payload
zip -r -y Payload.zip Payload/Runner.app
mv Payload.zip ../build/ios/Payload.ipa
# the following are options, remove Payload folder
rm -Rf Payload