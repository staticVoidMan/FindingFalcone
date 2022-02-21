#!/bin/bash

echo '-=-= Running Swift Package Unit Tests =-=-'
cd FindingFalcone
swift test

echo '-=-= Running iOS Unit Tests =-=-'
cd ../FindingFalcone-iOS
xcodebuild test \
-project FindingFalcone-iOS.xcodeproj \
-scheme FindingFalcone-iOS \
-destination 'platform=iOS Simulator,name=iPhone 12'
