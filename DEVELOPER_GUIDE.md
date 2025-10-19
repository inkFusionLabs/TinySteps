# TinySteps Developer Guide

This guide provides comprehensive information for developers working on the TinySteps app.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Getting Started](#getting-started)
4. [Code Structure](#code-structure)
5. [Design System](#design-system)
6. [Data Management](#data-management)
7. [Testing](#testing)
8. [Performance](#performance)
9. [Deployment](#deployment)
10. [Contributing](#contributing)

## Project Overview

TinySteps is a SwiftUI-based iOS app for baby tracking, designed specifically for new dads. The app features a modern neumorphic design system and comprehensive tracking capabilities.

### Key Technologies
- **Framework**: SwiftUI
- **Language**: Swift 5.9+
- **Minimum iOS**: 17.0
- **Target iOS**: 18.0
- **Data Storage**: Core Data + UserDefaults
- **Testing**: XCTest + XCUITest

## Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architecture:

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│    View     │◄───┤   ViewModel  │◄───┤    Model    │
│ (SwiftUI)   │    │ (Observable) │    │ (Data)      │
└─────────────┘    └──────────────┘    └─────────────┘
```

### Core Components
- **Models**: Data structures and business logic
- **ViewModels**: Observable objects that manage state
- **Views**: SwiftUI user interface components
- **Services**: External dependencies and utilities
- **Managers**: Data persistence and business logic

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ Simulator or device
- macOS 14.0 or later
- Git for version control

### Setup
1. **Clone the repository**:
   ```bash
   git clone https://github.com/inkFusionLabs/TinySteps.git
   cd TinySteps
   ```

2. **Open in Xcode**:
   ```bash
   open TinySteps.xcodeproj
   ```

3. **Select target device**:
   - Choose iPhone 16 Pro simulator for testing
   - Or connect a physical device

4. **Build and run**:
   - Press `Cmd + R` to build and run
   - Or click the play button in Xcode

### Project Structure
```
TinySteps/
├── TinySteps/
│   ├── Models/
│   │   ├── BabyData.swift
│   │   └── AppModels.swift
│   ├── Views/
│   │   ├── HomeViewNeumorphic.swift
│   │   ├── TrackingView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels/
│   │   └── BabyDataManager.swift
│   ├── Services/
│   │   ├── SystemManager.swift
│   │   └── NotificationManager.swift
│   ├── Utilities/
│   │   ├── ScreenSizeUtility.swift
│   │   └── PerformanceOptimizer.swift
│   ├── DesignSystem/
│   │   └── DesignSystem.swift
│   └── Resources/
│       ├── Assets.xcassets
│       └── Info.plist
├── TinyStepsTests/
│   ├── UnitTests/
│   └── IntegrationTests/
├── TinyStepsUITests/
│   └── UITests/
└── Documentation/
    ├── README.md
    └── USER_GUIDE.md
```

## Code Structure

### Models
Models represent the data structures and business logic:

```swift
// Example: Baby model
struct Baby: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var birthDate: Date
    var weight: Double?
    var height: Double?
    var feedingMethod: String?
    
    // Computed properties
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
}
```

### ViewModels
ViewModels manage state and business logic:

```swift
// Example: BabyDataManager
class BabyDataManager: ObservableObject {
    @Published var baby: Baby?
    @Published var feedingRecords: [FeedingRecord] = []
    
    func addFeedingRecord(_ record: FeedingRecord) {
        feedingRecords.append(record)
        saveData()
    }
}
```

### Views
Views are SwiftUI components that display the user interface:

```swift
// Example: HomeView
struct HomeViewNeumorphic: View {
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        ScrollView {
            VStack {
                // UI components
            }
        }
    }
}
```

## Design System

### Neumorphic Design
The app uses a custom neumorphic design system with:

- **Colors**: Vibrant, accessible color palette
- **Typography**: System fonts with custom sizing
- **Spacing**: Consistent spacing scale
- **Components**: Reusable UI components
- **Animations**: Smooth, delightful transitions

### Color Palette
```swift
struct TinyStepsDesign {
    struct Colors {
        static let primary = Color(red: 0.2, green: 0.4, blue: 0.8)
        static let secondary = Color(red: 0.4, green: 0.6, blue: 1.0)
        static let accent = Color(red: 0.8, green: 0.4, blue: 0.2)
        // ... more colors
    }
}
```

### Typography
```swift
struct TinyStepsDesign {
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let headline = Font.headline.weight(.medium)
        // ... more typography
    }
}
```

### Components
Reusable UI components include:

- **TinyStepsButton**: Custom button with neumorphic styling
- **TinyStepsCard**: Card component with shadow effects
- **TinyStepsIconButton**: Icon button with animations
- **TinyStepsSectionHeader**: Section header with icons
- **TinyStepsInfoCard**: Information display card

## Data Management

### Data Persistence
The app uses multiple storage mechanisms:

1. **UserDefaults**: For user preferences and settings
2. **Core Data**: For complex data relationships
3. **File System**: For data export and backup

### Data Models
Key data models include:

- **Baby**: Core baby information
- **FeedingRecord**: Feeding session data
- **SleepRecord**: Sleep tracking data
- **NappyRecord**: Nappy change records
- **Milestone**: Developmental milestones
- **VaccinationRecord**: Vaccination tracking

### Data Flow
```
User Input → ViewModel → DataManager → Storage
     ↑                                    ↓
   View ← ObservableObject ← DataManager ← Storage
```

## Testing

### Unit Tests
Unit tests cover individual components and business logic:

```swift
func testAddFeedingRecord() throws {
    let dataManager = BabyDataManager()
    let feedingRecord = FeedingRecord(
        date: Date(),
        type: .bottle,
        amount: 120.0,
        duration: 15.0,
        notes: "Test feeding",
        side: nil
    )
    
    dataManager.addFeedingRecord(feedingRecord)
    XCTAssertEqual(dataManager.feedingRecords.count, 1)
}
```

### UI Tests
UI tests verify user interface functionality:

```swift
func testAddFeedingRecord() throws {
    let app = XCUIApplication()
    app.launch()
    
    let addFeedingButton = app.buttons["Add Feeding"]
    addFeedingButton.tap()
    
    let amountField = app.textFields["Amount"]
    amountField.tap()
    amountField.typeText("120")
    
    let saveButton = app.buttons["Save"]
    saveButton.tap()
}
```

### Integration Tests
Integration tests verify end-to-end functionality:

```swift
func testCompleteBabyTrackingFlow() throws {
    let dataManager = BabyDataManager()
    
    // Add baby profile
    let baby = Baby(name: "Test Baby", birthDate: Date(), weight: 3.5, height: 50.0, feedingMethod: "Bottle-fed")
    dataManager.baby = baby
    
    // Add feeding record
    let feedingRecord = FeedingRecord(date: Date(), type: .bottle, amount: 120.0, duration: 15.0, notes: "Test feeding", side: nil)
    dataManager.addFeedingRecord(feedingRecord)
    
    // Verify data persistence
    XCTAssertNotNil(dataManager.baby)
    XCTAssertEqual(dataManager.feedingRecords.count, 1)
}
```

## Performance

### Optimization Strategies
1. **Lazy Loading**: Load data only when needed
2. **Caching**: Cache frequently accessed data
3. **Memory Management**: Monitor and optimize memory usage
4. **Background Processing**: Move heavy operations to background queues

### Performance Monitoring
The app includes built-in performance monitoring:

```swift
class PerformanceOptimizer: ObservableObject {
    @Published var memoryUsage: Double = 0.0
    @Published var cpuUsage: Double = 0.0
    
    func optimizeMemoryUsage() {
        // Memory optimization logic
    }
}
```

### Best Practices
- Use `@State` for local view state
- Use `@ObservableObject` for shared state
- Avoid expensive operations in view body
- Use `LazyVStack` for large lists
- Implement proper memory management

## Deployment

### Build Configuration
The app supports multiple build configurations:

- **Debug**: Development builds with debugging enabled
- **Release**: Production builds optimized for performance
- **TestFlight**: Beta testing builds

### App Store Preparation
1. **Update version numbers** in Info.plist
2. **Create app icons** for all required sizes
3. **Generate screenshots** for all device sizes
4. **Update metadata** in App Store Connect
5. **Submit for review**

### CI/CD Pipeline
The project includes automated build and deployment:

```yaml
# Example GitHub Actions workflow
name: Build and Test
on: [push, pull_request]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build
        run: xcodebuild -project TinySteps.xcodeproj -scheme TinySteps build
      - name: Test
        run: xcodebuild -project TinySteps.xcodeproj -scheme TinySteps test
```

## Contributing

### Development Workflow
1. **Fork** the repository
2. **Create** a feature branch
3. **Make** your changes
4. **Write** tests for new functionality
5. **Run** the test suite
6. **Submit** a pull request

### Code Style
- Follow Swift style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent indentation
- Use SwiftLint for code quality

### Pull Request Process
1. **Describe** your changes
2. **Reference** related issues
3. **Include** screenshots for UI changes
4. **Ensure** all tests pass
5. **Request** review from maintainers

### Issue Reporting
When reporting issues, include:

- **Device** and iOS version
- **Steps** to reproduce
- **Expected** behavior
- **Actual** behavior
- **Screenshots** or videos
- **Logs** if available

## Advanced Topics

### Accessibility
The app includes comprehensive accessibility support:

- **VoiceOver**: Complete screen reader support
- **Dynamic Type**: Supports all text size preferences
- **Reduce Motion**: Respects user preferences
- **High Contrast**: Enhanced visibility options

### Internationalization
The app is prepared for multiple languages:

- **Localizable strings** in all user-facing text
- **Date and number formatting** for different locales
- **RTL support** for right-to-left languages
- **Cultural considerations** in design and content

### Security
Security considerations include:

- **Data encryption** for sensitive information
- **Secure storage** using Keychain
- **Privacy protection** with local data storage
- **Secure communication** for cloud features

## Conclusion

This developer guide provides a comprehensive overview of the TinySteps codebase. For more specific information, refer to the inline documentation and code comments.

Happy coding! 🚀
