#!/bin/bash
# scripts/build_ios.sh
echo "           Building iOS..."
# Clean
flutter clean
# Get dependencies
flutter pub get
# Build iOS
flutter build ios --release --no-codesign
echo "✅ Build complete!"
echo "      Open ios/Runner.xcworkspace in Xcode to archive"
