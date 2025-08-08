#!/bin/bash

# Auto-rebuild script for TinySteps
# This script will completely close the app, clear caches, rebuild it, and relaunch it

echo "🚀 Starting comprehensive auto-rebuild workflow..."

# Function to rebuild and relaunch
rebuild_and_launch() {
    echo "📱 Completely closing TinySteps app..."
    
    # Force close the app completely
    xcrun simctl terminate "iPhone 16" com.inkfusionlabs.tinysteps 2>/dev/null || true
    
    # Wait a moment for the app to fully close
    sleep 2
    
    # Clear any cached data
    echo "🧹 Clearing app cache..."
    xcrun simctl uninstall "iPhone 16" com.inkfusionlabs.tinysteps 2>/dev/null || true
    
    echo "📱 Building TinySteps app..."
    
    # Clean build to ensure all changes are included
    xcodebuild -project TinySteps.xcodeproj -scheme TinySteps -destination 'platform=iOS Simulator,name=iPhone 16' clean build
    
    if [ $? -eq 0 ]; then
        echo "✅ Build successful!"
        
        # Check if simulator is running, if not boot it
        if ! xcrun simctl list devices | grep "iPhone 16" | grep -q "Booted"; then
            echo "📱 Booting iPhone 16 simulator..."
            xcrun simctl boot "iPhone 16"
        fi
        
        # Wait for simulator to be ready
        echo "⏳ Waiting for simulator to be ready..."
        sleep 3
        
        # Install the fresh app
        echo "📱 Installing fresh app..."
        xcrun simctl install "iPhone 16" "/Users/inkfusionlabs-/Library/Developer/Xcode/DerivedData/TinySteps-bfmcqidpikodiiadbvxohjvpoznt/Build/Products/Debug-iphonesimulator/TinySteps.app"
        
        # Wait a moment for installation
        sleep 2
        
        # Launch the fresh app
        echo "🚀 Launching fresh TinySteps app..."
        xcrun simctl launch "iPhone 16" com.inkfusionlabs.tinysteps
        
        echo "🎉 App launched successfully!"
        echo "📱 Simulator is open and ready for testing"
        echo ""
        echo "🔄 Auto-rebuild is ready!"
        echo "💡 The simulator will stay open and the app will be rebuilt automatically"
        echo "📝 Make your changes and run this script again to rebuild"
    else
        echo "❌ Build failed! Please check the errors above."
        exit 1
    fi
}

# Run the rebuild and launch function
rebuild_and_launch 