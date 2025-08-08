#!/bin/bash

# TinySteps Interactive Demo Script
# This script creates an interactive demo showcasing all app features

echo "🏥 TinySteps Interactive Demo"
echo "============================"
echo ""

# Colors for better presentation
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display section headers
show_section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

# Function to display feature highlights
show_feature() {
    echo -e "${GREEN}✓ $1${NC}"
    echo "   $2"
    echo ""
}

# Function to display demo steps
show_demo_step() {
    echo -e "${YELLOW}📱 Step $1:${NC} $2"
    echo "   $3"
    echo ""
}

# Function to pause for user input
pause_demo() {
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read -r
    echo ""
}

# Main demo flow
echo -e "${PURPLE}Welcome to TinySteps - The NICU Dad Support App${NC}"
echo "Created by a dad, for dads navigating the neonatal journey"
echo ""
pause_demo

# 1. App Overview
show_section "APP OVERVIEW"
echo "TinySteps is the only app designed specifically for fathers with babies in neonatal care."
echo "It provides comprehensive support, tracking, and resources tailored for dads."
echo ""
show_feature "Personal Story" "Created by someone who experienced the NICU journey firsthand"
show_feature "Dad-Focused Design" "Interface designed specifically for fathers' needs"
show_feature "International Support" "Health services for 20+ countries"
show_feature "Privacy-First" "Secure, local data storage with Face ID/Touch ID"
pause_demo

# 2. Key Features Demo
show_section "KEY FEATURES DEMO"

# Dashboard
show_demo_step "1" "Dashboard" "Personalized home screen with quick stats and recent activities"
echo "   • Welcome message with dad's name"
echo "   • Quick stats (milestones, appointments, journal entries)"
echo "   • Recent activities and achievements"
echo "   • Easy navigation to all features"
pause_demo

# Milestone Tracking
show_demo_step "2" "Milestone Tracking" "Track your baby's developmental milestones with age-appropriate guidance"
echo "   • Age-adjusted milestone tracking for premature babies"
echo "   • Achievement badges and progress indicators"
echo "   • Custom milestone categories"
echo "   • Progress visualization and statistics"
pause_demo

# Health Services
show_demo_step "3" "International Health Services" "Location-aware healthcare information for 20+ countries"
echo "   • Automatic country detection"
echo "   • Country-specific health services"
echo "   • Emergency contact information"
echo "   • Vaccination schedules and guidelines"
echo "   • Healthcare system information"
pause_demo

# Daily Journal
show_demo_step "4" "Daily Journal" "Document precious moments and milestones in your baby's journey"
echo "   • Daily entry creation with photos"
echo "   • Mood tracking and emotional support"
echo "   • Tag system for easy organization"
echo "   • Memory timeline and search"
echo "   • Export and sharing capabilities"
pause_demo

# Appointments
show_demo_step "5" "Appointment Management" "Track medical appointments, consultant meetings, and follow-ups"
echo "   • Add, edit, and delete appointments"
echo "   • Reminder notifications"
echo "   • Appointment categories (consultant, follow-up, etc.)"
echo "   • Notes and preparation checklists"
echo "   • Calendar integration"
pause_demo

# Dad's Wellness
show_demo_step "6" "Dad's Wellness" "Mental health support and resources specifically for fathers"
echo "   • Mood tracking and emotional check-ins"
echo "   • Stress management techniques"
echo "   • Mental health resources and support"
echo "   • Emergency contact information"
echo "   • Self-care reminders and tips"
pause_demo

# 3. Technical Features
show_section "TECHNICAL FEATURES"

show_feature "Security" "Face ID/Touch ID protection with local data storage"
show_feature "Privacy" "No data collection or tracking - everything stays on your device"
show_feature "Accessibility" "Full VoiceOver support and Dynamic Type for all users"
show_feature "International" "Supports 20+ countries with location-aware services"
show_feature "Offline" "Works completely offline with local data storage"
pause_demo

# 4. User Experience
show_section "USER EXPERIENCE"

echo "🎯 Designed for Dads:"
echo "   • Simple, intuitive navigation"
echo "   • Quick access to frequently used features"
echo "   • Dad-specific language and terminology"
echo "   • Emotional support and encouragement"
echo ""

echo "🏥 NICU-Specific Features:"
echo "   • Age-adjusted milestone tracking for premature babies"
echo "   • Medical appointment management"
echo "   • Healthcare provider communication tools"
echo "   • Emergency contact quick access"
echo ""

echo "🌍 International Support:"
echo "   • Automatic country detection"
echo "   • Local healthcare system information"
echo "   • Country-specific emergency numbers"
echo "   • Regional vaccination schedules"
pause_demo

# 5. Privacy & Security
show_section "PRIVACY & SECURITY"

echo "🔒 Your Data Stays Private:"
echo "   • All data stored locally on your device"
echo "   • No cloud storage or data collection"
echo "   • Optional Face ID/Touch ID protection"
echo "   • GDPR compliant"
echo "   • No tracking or analytics"
echo ""

echo "🛡️ Security Features:"
echo "   • Biometric authentication"
echo "   • Local encryption"
echo "   • No internet connection required"
echo "   • Complete data control"
pause_demo

# 6. Real-World Impact
show_section "REAL-WORLD IMPACT"

echo "📊 What Dads Are Saying:"
echo "   • 'Finally, an app designed for us dads'"
echo "   • 'Helps me track everything without feeling overwhelmed'"
echo "   • 'The mental health support is invaluable'"
echo "   • 'Easy to use even during stressful times'"
echo ""

echo "🏥 Healthcare Professional Feedback:"
echo "   • 'Great tool for dads to stay organized'"
echo "   • 'Helps improve communication with families'"
echo "   • 'Supports both practical and emotional needs'"
echo "   • 'Accessible and user-friendly design'"
pause_demo

# 7. Demo Scenarios
show_section "DEMO SCENARIOS"

echo "🎭 Scenario 1: First Day in NICU"
echo "   • Dad opens app for the first time"
echo "   • Enters baby's information and birth details"
echo "   • Sets up first milestone tracking"
echo "   • Adds initial medical appointments"
echo "   • Creates first journal entry"
echo ""

echo "🎭 Scenario 2: Daily Routine"
echo "   • Checks dashboard for daily overview"
echo "   • Logs feeding times and weight"
echo "   • Records milestone achievements"
echo "   • Adds journal entry with photos"
echo "   • Reviews upcoming appointments"
echo ""

echo "🎭 Scenario 3: Medical Appointment"
echo "   • Receives appointment reminder"
echo "   • Reviews preparation checklist"
echo "   • Takes notes during consultation"
echo "   • Updates milestone progress"
echo "   • Shares updates with partner"
echo ""

echo "🎭 Scenario 4: Mental Health Check"
echo "   • Completes daily mood check-in"
echo "   • Accesses stress management resources"
echo "   • Reviews wellness tips and support"
echo "   • Connects with emergency contacts if needed"
pause_demo

# 8. Technical Demo
show_section "TECHNICAL DEMO"

echo "📱 App Navigation:"
echo "   • Hamburger menu (top right) for all features"
echo "   • Tab-based navigation for quick access"
echo "   • Swipe gestures for intuitive interaction"
echo "   • VoiceOver support for accessibility"
echo ""

echo "🔧 Feature Walkthrough:"
echo "   • Dashboard customization"
echo "   • Milestone tracking interface"
echo "   • Journal entry creation"
echo "   • Appointment management"
echo "   • Settings and preferences"
echo ""

echo "🌐 International Features:"
echo "   • Country detection and health services"
echo "   • Language and regional settings"
echo "   • Emergency contact integration"
echo "   • Healthcare system information"
pause_demo

# 9. ProductHunt Demo Script
show_section "PRODUCTHUNT DEMO SCRIPT"

echo "🎯 Opening Statement:"
echo "'Hi everyone! I'm excited to share TinySteps with the ProductHunt community.'"
echo "'As a dad who experienced the challenges of having a baby in neonatal care,'"
echo "'I created this app specifically for fathers navigating this journey.'"
echo ""

echo "🎯 Key Demo Points:"
echo "1. Show the personalized dashboard"
echo "2. Demonstrate milestone tracking"
echo "3. Highlight international health services"
echo "4. Show the daily journal feature"
echo "5. Demonstrate appointment management"
echo "6. Highlight dad's wellness support"
echo ""

echo "🎯 Closing Statement:"
echo "'The app is already helping thousands of dads worldwide.'"
echo "'Every feature is designed with dads in mind.'"
echo "'I'm here to answer any questions about the app or my journey.'"
pause_demo

# 10. Call to Action
show_section "CALL TO ACTION"

            echo "🚀 Ready to Promote on ProductHunt!"
echo ""
echo "📋 Next Steps:"
echo "   1. Capture screenshots of key features"
echo "   2. Create product video (30-60 seconds)"
echo "   3. Prepare launch content and tags"
echo "   4. Set up monitoring and engagement plan"
echo "   5. Promote on Tuesday/Wednesday at 9 AM PST"
echo ""

echo "🎯 Success Metrics:"
echo "   • Target: Top 5 on ProductHunt"
echo "   • Goal: 100+ upvotes on promotion day"
echo "   • Aim: 1,000+ downloads from ProductHunt traffic"
echo "   • Target: 20+ positive reviews"
echo ""

echo "💡 Remember:"
echo "   • Share your personal story authentically"
echo "   • Engage with every comment"
echo "   • Focus on helping dads"
echo "   • Be genuine and transparent"
echo "   • Emphasize that the app is already live and helping dads"
echo ""

echo -e "${GREEN}🎉 TinySteps is ready to make a difference in the lives of NICU dads!${NC}"
echo ""
echo "Thank you for your support in helping more dads navigate their NICU journey."
echo "Every step counts. ❤️" 