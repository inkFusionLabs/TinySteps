#!/bin/bash

# ProductHunt Assets Generator for TinySteps (Already Launched App)
# This script helps generate screenshots and prepare promotion assets

echo "🎯 ProductHunt Promotion Assets Generator for TinySteps"
echo "======================================================"

# Create assets directory
mkdir -p producthunt-assets
cd producthunt-assets

echo ""
echo "📱 Generating ProductHunt Promotion Assets..."
echo ""

# Function to capture screenshot
capture_screenshot() {
    local screen_name=$1
    local description=$2
    
    echo "📸 Capturing screenshot: $screen_name"
    echo "   Description: $description"
    
    # Simulate screenshot capture (you'll need to manually capture these)
    echo "   ⚠️  Please manually capture screenshot for: $screen_name"
    echo "   📍 Navigate to the appropriate screen in the simulator"
    echo "   📷 Use Cmd+Shift+4 to capture the screen"
    echo "   💾 Save as: $screen_name.png"
    echo ""
}

# Function to create asset checklist
create_checklist() {
    echo "📋 ProductHunt Asset Checklist for Already Launched App"
    echo "=============================================="
    echo ""
    echo "✅ Required Assets:"
    echo "   📱 Screenshots (4-6 images):"
    capture_screenshot "tinysteps-dashboard" "Dad's Dashboard - Personalized dashboard with quick stats"
    capture_screenshot "tinysteps-milestones" "Milestone Tracking - Track developmental milestones"
    capture_screenshot "tinysteps-health-services" "Health Services - Location-aware health services"
    capture_screenshot "tinysteps-journal" "Daily Journal - Document precious moments"
    capture_screenshot "tinysteps-appointments" "Appointments - Track medical appointments"
    capture_screenshot "tinysteps-wellness" "Dad's Wellness - Mental health support for fathers"
    
    echo "   🎨 Logo:"
    echo "   📍 Size: 800x800px PNG"
    echo "   📍 Background: Transparent or solid color"
    echo "   📍 File: tinysteps-logo.png"
    echo ""
    
    echo "   🎥 Product Video:"
    echo "   📍 Duration: 30-60 seconds"
    echo "   📍 Content: App walkthrough showing key features"
    echo "   📍 Style: Clean, professional, emotional"
    echo "   📍 File: tinysteps-product-video.mp4"
    echo ""
}

# Function to create promotion content
create_promotion_content() {
    echo "📄 Creating Promotion Content Files..."
    echo ""
    
    # ProductHunt submission content for already launched app
    cat > producthunt-submission.txt << 'EOF'
🎯 ProductHunt Submission Content for Already Launched App
=================================================

📱 Product Title:
TinySteps - NICU Dad Support App

📝 Tagline (60 characters max):
The only app designed by a NICU dad, for NICU dads

🏷️ Categories:
- Primary: Health & Fitness
- Secondary: iOS Apps
- Tags: parenting, neonatal, dad, healthcare, tracking

📄 Product Description (Updated for Already Launched App):
🏥 CREATED BY A DAD, FOR DADS - NOW LIVE ON APP STORE

TinySteps is the only app designed specifically for fathers navigating the challenging journey of having a baby in neonatal intensive care. Already helping dads worldwide!

🎯 WHY TINYSTEPS?

• MILESTONE TRACKING
Track your baby's developmental milestones with age-appropriate guidance and achievement badges

• INTERNATIONAL HEALTH SERVICES
Location-aware health service detection for 20+ countries including UK, US, Canada, Australia, and more

• SECURE & PRIVATE
Password protection with Face ID/Touch ID support - your data stays on your device

• DAD-FOCUSED DESIGN
Interface designed specifically for fathers' needs with easy navigation

• DAILY JOURNAL
Document precious moments and milestones in your baby's journey

• APPOINTMENT MANAGEMENT
Track medical appointments, consultant meetings, and follow-ups

• REMINDERS & ALERTS
Set up important notifications for feeding times, medication, and appointments

• ACCESSIBILITY
Full VoiceOver support and Dynamic Type for all users

🔒 PRIVACY & SECURITY
• Your data stays on your device
• Optional Face ID/Touch ID protection
• No data collection or tracking
• GDPR compliant

📱 AVAILABLE NOW ON APP STORE
Download TinySteps today and join thousands of dads already using the app to support their NICU journey.

📞 SUPPORT
Need help? Contact us at inkfusionlabs@gmail.com

Created by a dad, for dads. Because every step counts. ❤️

🔗 Product Links:
- Website: [Your website URL]
- App Store: [App Store link]
- Twitter: [Your Twitter handle]
- Email: inkfusionlabs@gmail.com
EOF

    # Social media posts for existing app
    cat > social-media-posts.txt << 'EOF'
🌐 Social Media Posts for Promotion Day
=======================================

🐦 Twitter/X:
🚀 TinySteps is now featured on @ProductHunt!

The only app designed by a NICU dad, for NICU dads - already helping thousands of fathers worldwide.

Track milestones, manage appointments, and get support - all designed specifically for fathers navigating neonatal care.

#ProductHunt #NICU #DadLife #Parenting

[ProductHunt link]

💼 LinkedIn:
🎉 Excited to share that TinySteps is now featured on ProductHunt!

As a dad who experienced the challenges of having a baby in neonatal care, I created TinySteps to support other fathers on this journey. The app is now live and helping dads worldwide.

Key features:
• Milestone tracking for premature babies
• International health services (20+ countries)
• Secure, private data storage
• Dad-focused design and support

Would love your support and feedback! 

[ProductHunt link]

📱 Reddit Posts:
Subreddits: r/ProductHunt, r/NICUParents, r/daddit, r/iosapps

Title: "TinySteps - NICU Dad Support App now featured on ProductHunt"

Content:
Hey everyone! I'm excited to share that TinySteps is now featured on ProductHunt!

As a dad who experienced the challenges of having a baby in neonatal care, I created this app specifically for fathers navigating this journey. It's now live on the App Store and helping dads worldwide.

Key features:
• Milestone tracking for premature babies
• International health services (20+ countries)
• Secure, private data storage
• Dad-focused design and support
• Daily journal and appointment management

Would love your support and feedback! Every upvote helps get this in front of more dads who need it.

[ProductHunt link]
EOF

    # Email templates for existing app
    cat > email-templates.txt << 'EOF'
📧 Email Templates for Promotion Day
====================================

👥 Personal Network Email:
Subject: "TinySteps is now featured on ProductHunt!"

Hi [Name],

I'm excited to share that TinySteps is now featured on ProductHunt!

As you know, I experienced the challenges of having a baby in neonatal care, and I created this app specifically for fathers navigating this journey. The app is now live on the App Store and helping dads worldwide.

The app includes:
• Milestone tracking for premature babies
• International health services (20+ countries)
• Secure, private data storage
• Dad-focused design and support

Would you mind taking a look and giving it an upvote if you think it's valuable? Every vote helps get this in front of more dads who need it.

[ProductHunt link]

Thanks so much!
[Your name]

🏥 Healthcare Organizations Email:
Subject: "TinySteps - NICU Dad Support App now featured on ProductHunt"

Hi [Organization Name],

I'm reaching out to let you know that TinySteps is now featured on ProductHunt! This app I created specifically for fathers navigating the challenges of having a baby in neonatal care is now live and helping dads worldwide.

As a dad who experienced this journey firsthand, I created TinySteps to provide the support and resources I wish I had access to.

The app includes:
• Milestone tracking for premature babies
• International health services (20+ countries)
• Mental health support for fathers
• Secure, private data storage

I'm promoting on ProductHunt today and would love your support in getting this resource to more dads who need it.

[ProductHunt link]

Would you consider sharing this with your community? It could be a valuable resource for the families you support.

Thanks for your time!
[Your name]
EOF

    # Promotion day script for existing app
    cat > promotion-day-script.txt << 'EOF'
🚀 Promotion Day Script for Existing App
========================================

📱 Morning (6 AM PST):
Good morning! Today is the big day - TinySteps is featured on ProductHunt!

I'm excited to share this app I created for NICU dads with the ProductHunt community. As someone who experienced the challenges of having a baby in neonatal care, I built TinySteps to support other fathers on this journey.

The app is now live on the App Store and already helping thousands of dads worldwide. It includes milestone tracking, international health services, secure data storage, and dad-focused design - everything I wish I had access to.

Please take a look and give it an upvote if you think it's valuable. Every vote helps get this in front of more dads who need it.

[ProductHunt link]

Thank you for your support! ❤️

📱 Afternoon (2 PM PST):
Update: TinySteps is currently #3 on ProductHunt! 

Thank you to everyone who has supported this promotion. The response has been incredible, and I'm so grateful for all the positive feedback from the community.

The app is live on the App Store and ready to help dads who need support during their NICU journey. Keep the upvotes coming - every one helps more dads discover this resource!

[ProductHunt link]

📱 Evening (6 PM PST):
Final update: TinySteps finished #2 on ProductHunt today!

This is beyond what I could have hoped for. Thank you to everyone who supported this promotion - your upvotes, comments, and shares made this possible.

The app is live and ready to help dads navigating the challenges of neonatal care. If you know any dads who could benefit from this resource, please share it with them.

This is just the beginning - I'm excited to continue building and improving TinySteps based on your feedback.

Thank you from the bottom of my heart! ❤️
EOF

    echo "✅ Promotion content files created:"
    echo "   📄 producthunt-submission.txt"
    echo "   📄 social-media-posts.txt"
    echo "   📄 email-templates.txt"
    echo "   📄 promotion-day-script.txt"
    echo ""
}

# Function to create monitoring checklist for existing app
create_monitoring_checklist() {
    echo "📊 Promotion Day Monitoring Checklist for Existing App"
    echo "===================================================="
    echo ""
    echo "🎯 Key Metrics to Track:"
    echo ""
    echo "📈 ProductHunt Metrics:"
    echo "   ☐ Ranking position (aim for top 3)"
    echo "   ☐ Upvotes (target: 100+ day 1)"
    echo "   ☐ Comments (target: 20+ day 1)"
    echo "   ☐ Traffic from ProductHunt"
    echo ""
    echo "📱 App Store Metrics:"
    echo "   ☐ Downloads (target: 1,000+ day 1)"
    echo "   ☐ App Store ranking (target: top 50 in Health)"
    echo "   ☐ Reviews (target: 20+ day 1)"
    echo ""
    echo "🌐 Social Media Metrics:"
    echo "   ☐ Mentions (target: 50+ day 1)"
    echo "   ☐ Shares (target: 100+ day 1)"
    echo "   ☐ Engagement rate (target: 5%+)"
    echo ""
    echo "📅 Promotion Day Timeline:"
    echo "   6 AM PST: Submit to ProductHunt"
    echo "   9 AM PST: Share with communities"
    echo "   2 PM PST: Share progress updates"
    echo "   6 PM PST: Evening engagement push"
    echo ""
}

# Main execution
echo "🎯 Starting ProductHunt Promotion Asset Generation..."
echo ""

# Create checklist
create_checklist

# Create promotion content
create_promotion_content

# Create monitoring checklist
create_monitoring_checklist

echo ""
echo "🎉 ProductHunt Promotion Assets Generated!"
echo ""
echo "📁 Files created in: producthunt-assets/"
echo ""
echo "📋 Next Steps:"
echo "   1. 📸 Capture screenshots using the checklist above"
echo "   2. 🎨 Create/update logo (800x800px PNG)"
echo "   3. 🎥 Create product video (30-60 seconds)"
echo "   4. 📝 Review and customize promotion content"
echo "   5. 📅 Choose promotion date (Tuesday/Wednesday recommended)"
echo "   6. 🚀 Submit to ProductHunt!"
echo ""
echo "💡 Tips for Existing App Promotion:"
echo "   • Emphasize that the app is already live and helping dads"
echo "   • Share user testimonials and success stories"
echo "   • Highlight the app's proven track record"
echo "   • Focus on community building and increasing visibility"
echo "   • Launch on Tuesday or Wednesday for best engagement"
echo "   • Submit at 9 AM PST for peak traffic"
echo "   • Engage actively with all comments"
echo "   • Share your personal story - people connect with authenticity"
echo ""
echo "🎯 Good luck with your ProductHunt promotion!" 