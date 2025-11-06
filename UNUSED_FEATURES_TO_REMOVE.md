# TinySteps App - Unused Features to Remove

## 📋 Overview
This document lists features, views, data models, and utilities that exist in the codebase but are **not being used** and can be safely removed to reduce code complexity and maintenance burden.

---

## 🔴 **Views Not Accessible (Can Be Removed)**

### **1. DadWellnessView.swift** ❌
**Status:** Completely unused - no navigation links or references
**Location:** `TinySteps/DadWellnessView.swift`
**Contains:**
- `DadWellnessView` - Main wellness view
- `MoodTrackingView` - Mood tracking interface
- `StressManagementView` - Stress management tools
- `PostnatalDepressionView` - PND support
- `SelfCareView` - Self-care resources
- `SupportNetworkView` - Support network view
- `WellnessResourcesView` - Wellness resources
- `FavoritesView` - Favorites view
- Multiple sub-components (MoodEntryView, SavedMoodEntryCard, etc.)

**Action:** ✅ **DELETE** - This entire file and all its sub-views are not accessible from the main app navigation

---

### **2. EmergencyContactsView.swift** ❌
**Status:** Not accessible - no navigation to this view found
**Location:** `TinySteps/EmergencyContactsView.swift`
**Contains:**
- `EmergencyContactsView` - Emergency contacts management
- `EmergencyContactRow` - Contact row component
- `AddEmergencyContactView` - Add contact form

**Note:** While `EmergencyContact` data model is used in `BabyDataManager`, the UI for managing them is not accessible.

**Action:** ✅ **DELETE** - If you want emergency contacts, add navigation to this view. Otherwise remove.

---

### **3. BabyFormView.swift** ❌
**Status:** Not accessible - no navigation links found
**Location:** `TinySteps/BabyFormView.swift`
**Contains:**
- `BabyFormView` - Form for adding/editing baby profile

**Action:** ✅ **DELETE** - No way to access this view from the app

---

### **4. ProfileView.swift** ❌
**Status:** Referenced but not accessible - `showProfile` is set but sheet shows "Coming Soon"
**Location:** `TinySteps/ProfileView.swift`
**Contains:**
- `ProfileView` - User profile view
- Navigation to `ThemeSelectorView` (but ThemeSelectorView is also unused)

**Note:** In `ContentView.swift` line 119, there's a sheet that shows "Profile - Coming Soon" instead of ProfileView.

**Action:** ✅ **DELETE** - Currently not functional, or implement it properly

---

### **5. DataRestoreView.swift** ❌
**Status:** Not accessible - no navigation found
**Location:** `TinySteps/DataRestoreView.swift`
**Contains:**
- `DataRestoreView` - Data backup/restore interface
- `BackupCard` - Backup card component

**Action:** ✅ **DELETE** - Feature mentioned in README but not accessible

---

### **6. SupportView.swift** ⚠️
**Status:** Only accessible via preview, not from main navigation
**Location:** `TinySteps/SupportView.swift`
**Contains:**
- `SupportView` - Main support hub
- Links to: CountryHealthInfoView, HealthVisitorView, ParentingTipsView, HealthcareMapView, SupportServicesView

**Note:** This view acts as a hub for other views, but it's not accessible from the main app tabs. The views it links to are also not directly accessible.

**Action:** ⚠️ **DECIDE** - Either:
- Add navigation to SupportView from main app, OR
- Remove SupportView and make its sub-views accessible directly

---

### **7. EmptyBabyCard.swift** ❌
**Status:** Not used anywhere
**Location:** `TinySteps/EmptyBabyCard.swift`
**Contains:**
- `EmptyBabyCard` - Empty state card for when no baby is added
- `FeatureRow` - Feature row component

**Action:** ✅ **DELETE** - Not referenced in any view

---

### **8. BabyInfoCard.swift** ❌
**Status:** Not used anywhere
**Location:** `TinySteps/BabyInfoCard.swift`
**Contains:**
- `BabyInfoCard` - Card displaying baby information

**Action:** ✅ **DELETE** - Not referenced in any view

---

### **9. ThemeSelectorView.swift** ⚠️
**Status:** Only accessible from ProfileView (which is unused)
**Location:** `TinySteps/ThemeSelectorView.swift`
**Contains:**
- `ThemeSelectorView` - Theme selection interface
- `ThemeOptionCard` - Theme option card

**Action:** ⚠️ **DECIDE** - Either:
- Add navigation to ThemeSelectorView from settings/profile, OR
- Remove if theme selection not needed

---

### **10. ProfilePictureView.swift** ❌
**Status:** Only used in preview, not in actual app
**Location:** `TinySteps/ProfilePictureView.swift`
**Contains:**
- `ProfilePictureView` - Profile picture editing interface
- `TextInputView` - Text input component

**Action:** ✅ **DELETE** - Not referenced in actual app code

---

### **11. ProfilePictureComponent.swift** ❌
**Status:** Only used in preview
**Location:** `TinySteps/ProfilePictureComponent.swift`
**Contains:**
- `ProfilePictureComponent` - Profile picture display component

**Action:** ✅ **DELETE** - Not referenced in actual app code

---

### **12. UserAvatar.swift** ⚠️
**Status:** Only used in `NameEntryView` (which is part of onboarding)
**Location:** `TinySteps/UserAvatar.swift`
**Contains:**
- `UserAvatar` struct for avatar data

**Action:** ⚠️ **KEEP** - Used in onboarding flow, but verify if avatar feature is actually needed

---

## 🔴 **Unused Tab Bar Components**

### **13. GlassTabBar** ❌
**Status:** Commented out in ContentView (line 116)
**Location:** `ContentView.swift` (lines 160-260)
**Contains:**
- `GlassTabBar` - Glass effect tab bar (replaced by bubble menu)

**Action:** ✅ **DELETE** - Replaced by bubble menu navigation, commented code should be removed

---

### **14. OptimizedTabBar** ❌
**Status:** Defined but never used
**Location:** `ContentView.swift` (lines 627-666)
**Contains:**
- `OptimizedTabBar` - Alternative tab bar implementation

**Action:** ✅ **DELETE** - Not used anywhere

---

## 🔴 **Unused Data Models & Methods**

### **15. PhotoMemory** ❌
**Status:** Data model exists but no UI implementation
**Location:** `BabyData.swift` (line 430)
**Contains:**
- `PhotoMemory` struct - Photo gallery data model

**Action:** ✅ **DELETE** - No UI to use this data model, or implement photo gallery UI

---

### **16. WellnessEntry** ⚠️
**Status:** Data model and methods exist but no UI
**Location:** `BabyData.swift` (line 461)
**Contains:**
- `WellnessEntry` struct - Dad wellness tracking
- Methods: `addWellnessEntry()`, `getTodayWellness()`, `getWeeklyWellnessTrend()`

**Note:** Used to be accessed via `DadWellnessView` (which is unused)

**Action:** ⚠️ **DECIDE** - Either:
- Remove if wellness tracking not needed, OR
- Add UI to access wellness tracking (maybe in NICUHomeView or new section)

---

### **17. PartnerSupport** ⚠️
**Status:** Data model and methods exist but no UI
**Location:** `BabyData.swift` (line 547)
**Contains:**
- `PartnerSupport` struct - Partner support tracking
- Methods: `addPartnerSupport()`, `getTodaySupport()`

**Action:** ⚠️ **DECIDE** - Either:
- Remove if partner support tracking not needed, OR
- Add UI to access partner support features

---

### **18. SolidFoodRecord** ⚠️
**Status:** Data model exists but no UI (premature babies don't need this yet)
**Location:** `BabyData.swift` (line 131)
**Contains:**
- `SolidFoodRecord` struct - Solid food tracking
- Data persistence methods exist

**Note:** This is for older babies, not NICU babies. May be needed later.

**Action:** ⚠️ **KEEP FOR NOW** - May be needed post-NICU, but consider moving to separate file

---

### **19. GrowthPrediction** ⚠️
**Status:** Data model and methods exist but no UI
**Location:** `BabyData.swift` (line 678)
**Contains:**
- `GrowthPrediction` struct - Growth prediction model
- Methods: `addGrowthPrediction()`, `getLatestPrediction()`

**Action:** ⚠️ **DECIDE** - Either:
- Remove if predictions not needed, OR
- Add UI in NICUProgressView to show predictions

---

### **20. DevelopmentChecklist** ⚠️
**Status:** Data model and methods exist but no UI
**Location:** `BabyData.swift` (line 688)
**Contains:**
- `DevelopmentChecklist` struct - Development checklist
- Methods: `addDevelopmentChecklist()`, `completeChecklist()`, `getUpcomingChecklists()`

**Action:** ⚠️ **DECIDE** - Either:
- Remove if checklists not needed, OR
- Add UI in NICUProgressView or NICUInfoView

---

### **21. QuickAction** ⚠️
**Status:** Data model exists, methods exist, but no UI
**Location:** `BabyData.swift` (line 637)
**Contains:**
- `QuickAction` struct - Quick action buttons
- Methods: `addQuickAction()`, `updateQuickActionUsage()`

**Note:** Referenced in tests but not in UI

**Action:** ⚠️ **DECIDE** - Either:
- Remove if quick actions not needed, OR
- Add quick actions to NICUHomeView

---

### **22. VaccinationRecord** ⚠️
**Status:** Data model exists, methods exist, but limited UI
**Location:** `BabyData.swift` (line 122)
**Contains:**
- `VaccinationRecord` struct - Vaccination tracking
- Methods exist, used in `CountryHealthInfoView` (which is only accessible via SupportView)

**Action:** ⚠️ **KEEP** - Used in CountryHealthInfoView, but verify accessibility

---

### **23. Reminder** ⚠️
**Status:** Data model exists, methods exist, but no UI
**Location:** `BabyData.swift` (line 399)
**Contains:**
- `Reminder` struct - Reminder system
- Methods: `addReminder()`, `completeReminder()`, `getUpcomingReminders()`

**Note:** Mentioned in README but not implemented in UI

**Action:** ⚠️ **DECIDE** - Either:
- Remove if reminders not needed, OR
- Add reminder UI and notification scheduling

---

## 🔴 **Unused Utilities & Managers**

### **24. LocationManager.swift** ⚠️
**Status:** Used by HealthcareMapView and CountryContext, but HealthcareMapView only accessible via unused SupportView
**Location:** `TinySteps/LocationManager.swift`
**Contains:**
- Location tracking functionality

**Action:** ⚠️ **REVIEW** - Used by HealthcareMapView (which is only accessible via unused SupportView). If SupportView removed, this can be removed too.

---

### **25. DataPersistenceManager.swift** ✅ **KEEP**
**Status:** Actually used in NICUJournalView for journal entries
**Location:** `TinySteps/DataPersistenceManager.swift`
**Contains:**
- Data persistence utilities for journal entries

**Action:** ✅ **KEEP** - Used in NICUJournalView (which is actively used)

---

### **26. OfflineDataManager.swift** ⚠️
**Status:** Has some usage but may not be fully implemented
**Location:** `TinySteps/Utilities/OfflineDataManager.swift`
**Contains:**
- Offline data sync functionality
- `OfflineStatusView`, `SyncStatusView`

**Action:** ⚠️ **REVIEW** - Check if offline sync features are actually being used or needed

---

### **27. HomeButton.swift** ❌
**Status:** Not used anywhere
**Location:** `TinySteps/HomeButton.swift`
**Contains:**
- `HomeButton` component

**Action:** ✅ **DELETE** - Not referenced

---

## 🔴 **Empty Directories**

### **28. Services/** ❌
**Status:** Empty directory
**Location:** `TinySteps/Services/`

**Action:** ✅ **DELETE** - Remove empty directory

---

### **29. Testing/** ❌
**Status:** Empty directory
**Location:** `TinySteps/Testing/`

**Action:** ✅ **DELETE** - Remove empty directory (tests are in TinyStepsTests/)

---

## 🔴 **Unused Navigation Components**

### **30. OptimizedNavigation Components** ⚠️
**Status:** Some components may not be used
**Location:** `TinySteps/Navigation/OptimizedNavigation.swift`
**Contains:**
- `OptimizedNavigationView`
- `OptimizedSheet`
- `OptimizedTabView`
- `OptimizedNavigationLink`
- `NavigationPerformanceMonitor`

**Action:** ⚠️ **REVIEW** - Check which of these are actually used in the app

---

## 📊 **Summary Statistics**

### **Views to Delete:** 13
1. DadWellnessView.swift
2. EmergencyContactsView.swift
3. BabyFormView.swift
4. ProfileView.swift (or implement)
5. DataRestoreView.swift
6. EmptyBabyCard.swift
7. BabyInfoCard.swift
8. ProfilePictureView.swift
9. ProfilePictureComponent.swift
10. GlassTabBar (in ContentView)
11. OptimizedTabBar (in ContentView)
12. HomeButton.swift
13. LocationManager.swift

### **Views to Review/Decide:** 6
1. SupportView.swift (make accessible or remove)
2. ThemeSelectorView.swift (make accessible or remove)
3. CountryHealthInfoView (make accessible or remove)
4. HealthcareMapView (make accessible or remove)
5. HealthVisitorView (make accessible or remove)
6. ParentingTipsView (make accessible or remove)

### **Data Models to Review:** 8
1. PhotoMemory (delete or implement UI)
2. WellnessEntry (delete or add UI)
3. PartnerSupport (delete or add UI)
4. SolidFoodRecord (keep for future or remove)
5. GrowthPrediction (delete or add UI)
6. DevelopmentChecklist (delete or add UI)
7. QuickAction (delete or add UI)
8. Reminder (delete or implement fully)

### **Utilities to Review:** 2
1. OfflineDataManager (check if needed)
2. OptimizedNavigation components (check usage)

---

## 🎯 **Recommended Action Plan**

### **Phase 1: Safe Deletions (No Impact)**
Delete these immediately - they're completely unused:
1. ✅ DadWellnessView.swift
2. ✅ EmergencyContactsView.swift
3. ✅ BabyFormView.swift
4. ✅ EmptyBabyCard.swift
5. ✅ BabyInfoCard.swift
6. ✅ ProfilePictureView.swift
7. ✅ ProfilePictureComponent.swift
8. ✅ HomeButton.swift
9. ✅ LocationManager.swift (if HealthcareMapView removed)
10. ✅ GlassTabBar (commented code)
11. ✅ OptimizedTabBar
12. ✅ Empty directories (Services/, Testing/)

### **Phase 2: Decisions Needed**
Make decisions on these before removing:
1. ⚠️ SupportView and related views - Make accessible or remove
2. ⚠️ ProfileView - Implement or remove
3. ⚠️ ThemeSelectorView - Make accessible or remove
4. ⚠️ Data models (WellnessEntry, PartnerSupport, etc.) - Remove or add UI
5. ⚠️ Reminder system - Implement or remove
6. ⚠️ PhotoMemory - Implement gallery or remove

### **Phase 3: Clean Up Data Models**
After deciding on Phase 2, remove unused data models from BabyData.swift:
- Remove struct definitions
- Remove @Published properties
- Remove save/load code
- Remove methods

---

## ⚠️ **Important Notes**

1. **Before Deleting:** 
   - Search for any imports or references to these files
   - Check if they're used in tests
   - Verify they're not referenced via string-based navigation

2. **Data Models:**
   - Removing data models will require updating `BabyDataManager`:
     - Remove @Published properties
     - Remove from save/load methods
     - Remove from clearAllData()
     - Remove methods

3. **Dependencies:**
   - Some views depend on others (e.g., SupportView links to other views)
   - Remove in the correct order to avoid compilation errors

4. **Testing:**
   - Some unused code may be referenced in tests
   - Update or remove tests when removing code

---

**Last Updated:** January 2025  
**Next Steps:** Review and decide on Phase 2 items, then proceed with deletions

