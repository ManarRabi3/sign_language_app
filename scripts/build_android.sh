#!/bin/bash
# scripts/build_android.sh
echo "           Building Android APK..."
# Clean
flutter clean
# Get dependencies
flutter pub get
# Build APK
flutter build apk --release --split-per-abi
# Build App Bundle for Play Store
flutter build appbundle --release
echo "✅ Build complete!"
echo "      APKs: build/app/outputs/flutter-apk/"
echo "      Bundle: build/app/outputs/bundle/release/"
