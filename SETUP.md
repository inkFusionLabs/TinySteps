# TinySteps - Local Development Setup Guide

This guide will help you set up TinySteps locally for testing and development.

## 🛠 Prerequisites

### Required Software
- **macOS 14.0 or later**
- **Xcode 16.0 or later** (download from [App Store](https://apps.apple.com/us/app/xcode/id497799835))
- **iOS 18.0+ Simulator** (included with Xcode)
- **Git** (usually pre-installed on macOS)

### Optional but Recommended
- **iOS Device** for real device testing
- **Apple Developer Account** ($99/year) for device testing and App Store distribution

## 📥 Installation Steps

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/inkFusionLabs/TinySteps.git

# Navigate to the project directory
cd TinySteps
```

### 2. Open in Xcode

```bash
# Open the project in Xcode
open TinySteps.xcodeproj
```

Or manually:
1. Open Xcode
2. Go to `File > Open...`
3. Navigate to the `TinySteps` folder
4. Select `TinySteps.xcodeproj`
5. Click `Open`

### 3. Configure Bundle Identifier

**Important**: You must change the bundle identifier to avoid conflicts.

1. In Xcode, select the `TinySteps` project in the navigator
2. Select the `TinySteps` target
3. Go to the `Signing & Capabilities` tab
4. Change the Bundle Identifier to something unique:
   - Example: `com.yourname.TinySteps`
   - Example: `com.yourcompany.TinySteps`
   - Example: `com.yourdomain.TinySteps`

### 4. Configure Development Team

1. In the same `Signing & Capabilities` tab:
2. Under `Team`, select your Apple Developer account
3. If you don't have one, select `Personal Team` (for simulator testing only)

### 5. Select Target Device

1. In Xcode's toolbar, click the device selector (next to the play button)
2. Choose one of the following:
   - **iOS Simulator** (recommended for testing)
   - **Your iOS Device** (if you have one connected)

### 6. Build and Run

1. Press `⌘ + R` or click the ▶️ play button
2. Wait for the build to complete
3. The app will launch in the simulator or on your device

## 🎯 First Launch Experience

When you first run the app:

1. **Welcome Screen**: You'll see the TinySteps welcome screen
2. **Name Entry**: Enter your name (this will be used throughout the app)
3. **Main Dashboard**: You'll see the dad-focused dashboard
4. **Hamburger Menu**: Tap the ☰ icon in the top right to access all features

## 🔧 Troubleshooting

### Common Issues

#### "No provisioning profile found"
- **Solution**: Make sure you've selected your development team
- **Alternative**: Use iOS Simulator instead of a physical device

#### "Bundle identifier conflicts"
- **Solution**: Change the bundle identifier to something unique
- **Example**: `com.yourname.TinySteps`

#### "Build fails with Swift errors"
- **Solution**: Make sure you're using Xcode 16.0 or later
- **Check**: iOS deployment target is set to 18.0 or later

#### "Simulator not available"
- **Solution**: Open Xcode > Preferences > Components
- **Download**: The iOS 18.0+ simulator

### Xcode Tips

#### Clean Build Folder
If you encounter strange build issues:
1. Go to `Product > Clean Build Folder` (`⌘ + Shift + K`)
2. Try building again

#### Reset Simulator
To start fresh with the simulator:
1. Go to `Device > Erase All Content and Settings`
2. This will reset the simulator to factory settings

#### View Console Logs
To see app logs and debug information:
1. Go to `Window > Devices and Simulators`
2. Select your device/simulator
3. Click `Open Console`

## 📱 Testing Features

### Core Features to Test

1. **Navigation**: Use the hamburger menu to navigate between sections
2. **Baby Data Entry**: Add baby information and track activities
3. **Journal**: Create diary entries and milestones
4. **UK Services**: Explore the integrated UK neonatal services
5. **Settings**: Test the settings and profile features

### Simulator vs Device Testing

#### iOS Simulator (Recommended for Development)
- ✅ Fast iteration
- ✅ No device setup required
- ✅ Easy debugging
- ❌ Limited camera/photo features
- ❌ No push notifications

#### Physical Device (Recommended for Final Testing)
- ✅ Full feature testing
- ✅ Real performance testing
- ✅ Camera and photo features work
- ✅ Push notifications work
- ❌ Requires Apple Developer account
- ❌ More setup required

## 🚀 Development Workflow

### Making Changes

1. **Create a new branch** (recommended):
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** in Xcode

3. **Test thoroughly** on simulator and device

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add your feature description"
   ```

5. **Push to GitHub**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Contributing Back

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Make your changes**
4. **Create a pull request**

## 📚 Additional Resources

### Documentation
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [iOS App Development](https://developer.apple.com/develop/)
- [Xcode User Guide](https://developer.apple.com/xcode/)

### Community
- [GitHub Issues](https://github.com/inkFusionLabs/TinySteps/issues) - Report bugs
- [GitHub Discussions](https://github.com/inkFusionLabs/TinySteps/discussions) - Ask questions

## 🆘 Getting Help

If you encounter issues:

1. **Check this setup guide** first
2. **Search existing issues** on GitHub
3. **Create a new issue** with:
   - Your macOS version
   - Your Xcode version
   - The exact error message
   - Steps to reproduce the issue

## 🎉 Success!

Once you've completed these steps, you should have TinySteps running locally and be ready to contribute to this important project for dads with babies in neonatal care!

---

**Happy coding! 🚀** 