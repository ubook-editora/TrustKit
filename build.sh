#!/bin/bash

#################
# ATTENTION:
# - Xcode with devices and simulators for
# iOS, tvOS, and watchOS needs to be installed
#################

# Function to compile for a specific platform
compile_for_platform() {
    platform=$1
    target=$2
    output_folder=$3

    xcodebuild -project TrustKit.xcodeproj \
               -scheme "$target" \
               -destination "$platform" \
               -configuration Release \
               build \
               CONFIGURATION_BUILD_DIR="$output_folder" \
               ONLY_ACTIVE_ARCH=YES
}

# Create directories for compilation outputs
rm -rf "build"
mkdir -p "build"

# Compile for iOS devices
compile_for_platform "generic/platform=iOS" "TrustKit" "build/Release-iphoneos"

# Compile for iOS Simulator
compile_for_platform "generic/platform=iOS Simulator" "TrustKit" "build/Release-iphonesimulator"

# Compile for tvOS devices
compile_for_platform "generic/platform=tvOS" "TrustKit tvOS" "build/Release-appletvos"

# Compile for tvOS Simulator
compile_for_platform "generic/platform=tvOS Simulator" "TrustKit tvOS" "build/Release-appletvsimulator"

# Compile for watchOS devices
compile_for_platform "generic/platform=watchOS" "TrustKit watchOS" "build/Release-watchos"

# Compile for watchOS Simulator
compile_for_platform "generic/platform=watchOS Simulator" "TrustKit watchOS" "build/Release-watchsimulator"

# Compile for macOS
compile_for_platform "platform=macOS" "TrustKit OS X" "build/Release-macos"

# Compile for macCatalyst
compile_for_platform "platform=macOS,variant=Mac Catalyst" "TrustKit" "build/Release-mac-catalyst"

# Create xcframework
rm -rf "TrustKit.xcframework"
xcodebuild -create-xcframework \
           -framework "build/Release-iphoneos/TrustKit.framework" \
           -framework "build/Release-iphonesimulator/TrustKit.framework" \
           -framework "build/Release-appletvos/TrustKit.framework" \
           -framework "build/Release-appletvsimulator/TrustKit.framework" \
           -framework "build/Release-watchos/TrustKit.framework" \
           -framework "build/Release-watchsimulator/TrustKit.framework" \
           -framework "build/Release-macos/TrustKit.framework" \
           -framework "build/Release-mac-catalyst/TrustKit.framework" \
           -output "TrustKit.xcframework"

# Compress
tar -czf "TrustKit.tar.gz" "TrustKit.xcframework"
