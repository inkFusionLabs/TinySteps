# TinySteps - iOS Parenting App

A comprehensive iOS app designed to help new parents track their baby's development, manage appointments, and access parenting resources.

## 🚀 Features

### Core Functionality
- **Baby Tracking**: Monitor feeding, sleeping, diaper changes, and growth milestones
- **Appointment Management**: Calendar integration for health visits and checkups
- **Journal & Diary**: Document precious moments and daily activities
- **Reminders**: Set up important notifications for feeding, medication, etc.
- **Milestones Tracking**: Track developmental milestones with visual progress
- **Health Visitor Integration**: UK-specific health visitor appointment management

### User Experience
- **Modern UI**: Clean, intuitive interface with custom design system
- **Hamburger Menu**: Easy navigation with slide-out menu from top right
- **Personalized Dashboard**: Welcome screen with user's name and baby info
- **Data Export**: Share baby data with healthcare providers
- **Dark/Light Mode Support**: Adaptive to system preferences

### Information Hub
- **Parenting Tips**: Curated advice and best practices
- **UK Services**: Information about available parenting support services
- **Health Resources**: Access to reliable parenting information
- **Support System**: Built-in help and guidance

## 📱 Screenshots

*Screenshots will be added here*

## 🛠 Technical Details

- **Platform**: iOS 18.0+
- **Language**: Swift 5
- **Architecture**: SwiftUI with MVVM pattern
- **Data Persistence**: UserDefaults and Core Data
- **Design System**: Custom TinyStepsDesign with consistent colors, typography, and spacing

## 📁 Project Structure

```
TinySteps/
├── TinySteps/                    # Main app source
│   ├── Views/                    # SwiftUI views
│   │   ├── ContentView.swift     # Main navigation
│   │   ├── HomeView.swift        # Dashboard
│   │   ├── TrackingView.swift    # Baby tracking
│   │   ├── JournalView.swift     # Diary functionality
│   │   └── ...                   # Other view files
│   ├── Models/                   # Data models
│   │   ├── BabyData.swift        # Baby information
│   │   └── ActivityModels.swift  # Activity tracking
│   ├── DesignSystem.swift        # UI design system
│   └── Assets.xcassets/          # App icons and colors
├── TinyStepsTests/               # Unit tests
└── TinyStepsUITests/             # UI tests
```

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0 or later
- iOS 18.0+ deployment target
- macOS 14.0 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/TinySteps.git
   cd TinySteps
   ```

2. **Open in Xcode**
   ```bash
   open TinySteps.xcodeproj
   ```

3. **Configure your development team**
   - Select the TinySteps project in Xcode
   - Go to Signing & Capabilities
   - Update the Bundle Identifier to your domain
   - Select your development team

4. **Build and Run**
   - Select your target device or simulator
   - Press ⌘+R to build and run

## 🔧 Configuration

### Bundle Identifier
Update the bundle identifier in the project settings:
- Current: `com.yournewprofile.TinySteps`
- Change to: `com.yourdomain.TinySteps`

### Development Team
- Select your Apple Developer account in project settings
- Ensure you have the necessary provisioning profiles

## 📝 Usage

1. **First Launch**: Enter your name and baby's information
2. **Dashboard**: View quick stats and recent activities
3. **Navigation**: Use the hamburger menu (☰) in the top right to access all features
4. **Tracking**: Log daily activities like feeding, sleeping, and diaper changes
5. **Journal**: Document special moments and milestones
6. **Appointments**: Schedule and manage health visits

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Designed for new parents navigating the exciting journey of parenthood
- Built with modern iOS development practices
- Focused on user experience and accessibility

## 📞 Support

For support and questions:
- Create an issue in this repository
- Contact: [Your Contact Information]

---

**Made with ❤️ for parents everywhere** 