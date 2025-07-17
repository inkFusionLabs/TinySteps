# Location-Aware Health Information Feature

## Overview

TinySteps now includes comprehensive location-aware health information that automatically detects the user's country and provides relevant health services, vaccination schedules, growth standards, and emergency information.

## Features

### 🌍 Automatic Country Detection
- Uses device location services to detect user's country
- Falls back to manual country selection if location is unavailable
- Supports 20+ countries with more being added

### 🏥 Country-Specific Health Services
Each country includes:
- **Support Organizations**: Local charities and support groups
- **Medical Services**: Healthcare providers and specialists
- **Contact Information**: Phone numbers and websites
- **Service Types**: Support, Medical, Mental Health, Research

### 💉 Vaccination Schedules
Country-specific vaccination schedules including:
- **UK**: NHS vaccination schedule
- **US**: CDC vaccination schedule
- **Canada**: Provincial vaccination schedules
- **Australia**: National vaccination program
- **Germany**: German vaccination recommendations
- And more...

### 📊 Growth Standards
Country-specific growth standards with:
- **Measurement Units**: kg/lbs, cm/inches based on country
- **Growth Charts**: WHO, CDC, or country-specific standards
- **Reference Data**: Local population growth data

### 📋 Health Guidelines
Country-specific health guidelines including:
- **Well-Child Visits**: Local pediatric check-up schedules
- **Breastfeeding Support**: Country-specific programs
- **Mental Health Services**: Local perinatal mental health support
- **Emergency Services**: Country-specific emergency numbers

### 🚨 Emergency Information
Country-specific emergency information:
- **Emergency Numbers**: 999 (UK), 911 (US), 000 (Australia), etc.
- **Non-Emergency Numbers**: Local health advice lines
- **Ambulance Services**: Local emergency medical services
- **Hospital Finders**: Local healthcare directories

## Supported Countries

### Currently Supported (20+ countries):
- **United Kingdom** (GB) - NHS services
- **United States** (US) - CDC guidelines
- **Canada** (CA) - Provincial health services
- **Australia** (AU) - National health system
- **Germany** (DE) - German healthcare system
- **France** (FR) - French healthcare system
- **Spain** (ES) - Spanish healthcare system
- **Italy** (IT) - Italian healthcare system
- **Netherlands** (NL) - Dutch healthcare system
- **Sweden** (SE) - Swedish healthcare system
- **Norway** (NO) - Norwegian healthcare system
- **Denmark** (DK) - Danish healthcare system
- **Finland** (FI) - Finnish healthcare system
- **Japan** (JP) - Japanese healthcare system
- **South Korea** (KR) - Korean healthcare system
- **China** (CN) - Chinese healthcare system
- **India** (IN) - Indian healthcare system
- **Brazil** (BR) - Brazilian healthcare system
- **Mexico** (MX) - Mexican healthcare system
- **Argentina** (AR) - Argentine healthcare system
- **South Africa** (ZA) - South African healthcare system

## Technical Implementation

### Core Components

#### 1. CountryHealthServicesManager
- Manages country detection and health services
- Handles location-based country identification
- Provides country-specific service lists
- Manages emergency numbers by country

#### 2. CountryHealthInfoManager
- Manages country-specific health information
- Provides vaccination schedules
- Handles growth standards
- Manages health guidelines
- Provides emergency information

#### 3. LocationManager
- Handles device location permissions
- Provides current location coordinates
- Manages location authorization status

### Data Structure

#### NeonatalService
```swift
struct NeonatalService: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let contact: String
    let website: String
    let country: String
}
```

#### VaccinationSchedule
```swift
struct VaccinationSchedule: Identifiable, Codable {
    let id = UUID()
    let age: String
    let vaccines: [String]
    let notes: String
}
```

#### GrowthStandards
```swift
struct GrowthStandards: Codable {
    let country: String
    let organization: String
    let weightUnit: String
    let heightUnit: String
    let notes: String
}
```

## User Interface

### Health Services View
- **Location Status**: Shows if location access is active
- **Country Display**: Shows detected country
- **Emergency Number**: Prominently displays local emergency number
- **Service List**: Shows available health services for the country
- **Contact Actions**: Direct phone and website links

### Health Information View
- **Tabbed Interface**: Vaccinations, Growth, Guidelines, Emergency
- **Country Selector**: Manual country selection option
- **Location Integration**: Automatic country detection
- **Comprehensive Data**: All country-specific health information

### Country Selector
- **Grid Layout**: Easy country selection
- **Visual Indicators**: Selected country highlighting
- **Country Codes**: Clear country identification
- **Instant Updates**: Immediate service updates

## Privacy & Permissions

### Location Permissions
- **When In Use**: Only requests location when app is active
- **Optional**: Users can manually select country without location
- **Transparent**: Clear explanation of location usage
- **Secure**: Location data not stored or transmitted

### Data Privacy
- **Local Storage**: All health data stored locally on device
- **No Tracking**: No user location tracking or analytics
- **Offline Capable**: Works without internet connection
- **User Control**: Users can disable location services

## Future Enhancements

### Planned Features
- **More Countries**: Additional country support
- **Localized Content**: Country-specific language support
- **Cultural Adaptations**: Local parenting practices
- **Regional Guidelines**: State/province specific information
- **Healthcare Integration**: Direct integration with local health systems

### Data Expansion
- **More Services**: Additional health organizations
- **Detailed Schedules**: More comprehensive vaccination schedules
- **Growth Charts**: Interactive growth tracking
- **Health Tips**: Country-specific parenting advice
- **Emergency Procedures**: Local emergency protocols

## Benefits for Users

### For Parents
- **Relevant Information**: Health services specific to their location
- **Emergency Access**: Quick access to local emergency numbers
- **Vaccination Tracking**: Country-specific vaccination schedules
- **Growth Monitoring**: Local growth standards and charts
- **Support Networks**: Access to local support organizations

### For Healthcare Providers
- **Local Resources**: Information about local healthcare services
- **Standard Compliance**: Country-specific medical standards
- **Emergency Protocols**: Local emergency procedures
- **Referral Networks**: Local healthcare provider networks

## Implementation Notes

### Location Detection
- Uses Core Location framework for GPS coordinates
- Reverse geocoding to determine country from coordinates
- Graceful fallback to manual selection if location unavailable
- Respects user privacy settings

### Data Management
- Static data stored in app bundle for offline access
- No external API calls required for basic functionality
- Efficient memory usage with lazy loading
- Easy to update with new country data

### User Experience
- Seamless integration with existing app design
- Consistent with TinySteps design system
- Accessible design with proper contrast and sizing
- Intuitive navigation and interaction patterns

---

*This feature enhances TinySteps' mission to provide comprehensive, location-relevant support for fathers with babies in neonatal care, making the app truly global while maintaining its dad-focused approach.* 