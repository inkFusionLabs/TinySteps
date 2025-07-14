# TinySteps - Neonatal Dad Support App

A specialized iOS app designed by a dad, for dads with babies in neonatal care. Provides comprehensive support, information, and resources specifically tailored for fathers navigating the challenging journey of having a baby in neonatal intensive care.

## 🏥 Purpose

TinySteps was created by a dad who experienced the emotional and practical challenges of having a baby in neonatal care. This app serves as a comprehensive support system, bringing together trusted UK neonatal services and resources in one accessible platform.

## 🚀 Features

### Core Functionality
- **Neonatal Tracking**: Monitor your baby's progress, feeding, weight, and medical updates
- **Dad-Specific Support**: Resources and information tailored specifically for fathers
- **UK Neonatal Services**: Direct access to information from leading UK organizations
- **Appointment Management**: Track medical appointments, consultant meetings, and follow-ups
- **Daily Journal**: Document precious moments and milestones in your baby's journey
- **Reminders**: Set up important notifications for feeding times, medication, and appointments

### UK Service Integration
- **Bliss**: Information and support for babies born premature or sick
- **DadPad**: Father-specific parenting resources and guidance
- **Mush**: Connect with other dads in similar situations
- **Baby Buddy**: NHS-approved baby development tracking
- **PANDA's**: Perinatal mental health support for dads
- **NHS Healthier Together**: Official NHS guidance and resources

### User Experience
- **Dad-Focused Design**: Interface designed specifically for fathers' needs
- **Hamburger Menu**: Easy navigation with slide-out menu from top right
- **Personalized Dashboard**: Welcome screen with dad's name and baby info
- **Data Export**: Share baby data with healthcare providers
- **Dark/Light Mode Support**: Adaptive to system preferences

### Information Hub
- **Neonatal Care Guidance**: Expert advice for caring for premature/sick babies
- **Mental Health Support**: Resources for dads' emotional wellbeing
- **Practical Tips**: Day-to-day advice for neonatal parenting
- **Emergency Contacts**: Quick access to important medical contacts
- **Support Networks**: Connect with other dads in similar situations

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
│   │   ├── ContentView.swift     # Main navigation with hamburger menu
│   │   ├── HomeView.swift        # Dad's dashboard
│   │   ├── TrackingView.swift    # Baby tracking and monitoring
│   │   ├── JournalView.swift     # Daily journal and milestones
│   │   ├── HealthVisitorView.swift # UK health visitor integration
│   │   ├── UKServicesView.swift  # UK neonatal services information
│   │   ├── SupportView.swift     # Mental health and support resources
│   │   └── ...                   # Other view files
│   ├── Models/                   # Data models
│   │   ├── BabyData.swift        # Baby information and medical data
│   │   └── ActivityModels.swift  # Activity tracking and milestones
│   ├── DesignSystem.swift        # UI design system
│   └── Assets.xcassets/          # App icons and colors
├── TinyStepsTests/               # Unit tests
└── TinyStepsUITests/             # UI tests
```

## 🚀 Getting Started

For detailed setup instructions, see [SETUP.md](SETUP.md).

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/inkFusionLabs/TinySteps.git
   cd TinySteps
   ```

2. **Open in Xcode**
   ```bash
   open TinySteps.xcodeproj
   ```

3. **Configure for testing**
   - Change the Bundle Identifier to avoid conflicts
   - Select your development team
   - Choose iOS Simulator or your device

4. **Build and Run**
   - Press ⌘+R to build and run

### Prerequisites
- Xcode 16.0 or later
- iOS 18.0+ deployment target
- macOS 14.0 or later

## 🔧 Configuration

### Bundle Identifier
Update the bundle identifier in the project settings:
- Current: `com.inkFusionLabs.TinySteps`
- Change to: `com.yourdomain.TinySteps` (for your own testing)

### Development Team
- Select your Apple Developer account in project settings
- Ensure you have the necessary provisioning profiles

## 📝 Usage

1. **First Launch**: Enter your name and baby's information
2. **Dashboard**: View quick stats and recent activities
3. **Navigation**: Use the hamburger menu (☰) in the top right to access all features
4. **Tracking**: Log daily activities like feeding, weight, and medical updates
5. **Journal**: Document special moments and milestones
6. **UK Services**: Access information from Bliss, DadPad, NHS, and other trusted sources
7. **Support**: Find mental health resources and connect with other dads

## 🤝 Contributing

This app was created by a dad for dads. We welcome contributions from:
- Dads with neonatal experience
- Healthcare professionals
- Developers who want to support the neonatal community

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Created by a dad, for dads** navigating the challenging journey of neonatal care
- **Bliss**: For their invaluable support and resources for premature babies
- **DadPad**: For father-specific parenting guidance
- **Mush**: For connecting dads in similar situations
- **Baby Buddy**: For NHS-approved baby development tracking
- **PANDA's**: For perinatal mental health support
- **NHS Healthier Together**: For official healthcare guidance
- **All the dads** who shared their experiences and inspired this app

## 📞 Support

For support and questions:
- Create an issue in this repository
- Contact: [Your Contact Information]

## 🏥 UK Neonatal Resources

This app integrates information from these trusted UK organizations:
- **Bliss**: Supporting babies born premature or sick
- **DadPad**: Father-focused parenting resources
- **Mush**: Connecting parents and building communities
- **Baby Buddy**: NHS-approved baby development app
- **PANDA's**: Perinatal mental health support
- **NHS Healthier Together**: Official NHS guidance

---

**Made with ❤️ by a dad, for dads everywhere** 