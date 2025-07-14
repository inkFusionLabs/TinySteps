import SwiftUI

#if canImport(AppKit)
import AppKit
#endif

struct SupportView: View {
    let mentalHealthTips = [
        "It's normal to feel overwhelmed. Your feelings are valid.",
        "Talk to other NICU dads - you're not alone.",
        "Take breaks when you need to - you can't support your baby if you're exhausted.",
        "Ask for help from friends, family or professionals.",
        "Celebrate small wins - every gram gained, every tube removed is progress."
    ]
    
    let supportContacts = [
        SupportContact(name: "NHS Mental Health", number: "111", description: "NHS non-emergency number"),
        SupportContact(name: "Mind Infoline", number: "0300 123 3393", description: "Mental health charity"),
        SupportContact(name: "CALM", number: "0800 58 58 58", description: "Campaign Against Living Miserably (5pm-midnight)"),
        SupportContact(name: "Bliss Helpline", number: "0808 801 0322", description: "For parents of premature babies"),
        SupportContact(name: "Samaritans", number: "116 123", description: "24/7 emotional support")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Support Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.support, color: TinyStepsDesign.Colors.success)
                Text("Dad's Support")
                    .font(TinyStepsDesign.Typography.header)
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                Spacer()
            }
            .padding()
            .background(TinyStepsDesign.Colors.primary)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top, 12)
            // Main Content
            ScrollView {
                VStack(spacing: 20) {
                    // Dad-Focused Support Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dad Resources")
                            .font(TinyStepsDesign.Typography.subheader)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        // Example dad-focused links/resources
                        Link(destination: URL(string: "https://dadsupport.org")!) {
                            HStack {
                                Image(systemName: "person.2.wave.2")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                Text("Dad Support Community")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        // ... add more dad-specific resources ...
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    // Mental health section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mental Health Support")
                            .font(.title2)
                            .bold()
                        
                        Text("Having a baby in neonatal care can be emotionally challenging. Here are some tips:")
                            .font(.subheadline)
                        
                        ForEach(mentalHealthTips, id: \.self) { tip in
                            HStack(alignment: .top) {
                                Image(systemName: "heart")
                                    .foregroundColor(TinyStepsDesign.Colors.error)
                                Text(tip)
                            }
                            .padding(.bottom, 5)
                        }
                    }
                    .padding()
                    .background(TinyStepsDesign.Colors.cardBackground)
                    .cornerRadius(10)
                    
                    // Emergency contacts
                    VStack(alignment: .leading, spacing: 10) {
                        Text("UK Support Contacts")
                            .font(.title2)
                            .bold()
                        
                        ForEach(supportContacts) { contact in
                            SupportContactView(contact: contact)
                        }
                    }
                    .padding()
                    .background(TinyStepsDesign.Colors.cardBackground)
                    .cornerRadius(10)
                    
                    // Stories from other dads
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Stories from Other NICU Dads")
                            .font(.title2)
                            .bold()
                        
                        Text("Hearing from others who've been through similar experiences can help. Visit:")
                            .font(.subheadline)
                        
                        Link("Dads in NICU - Bliss Forum", destination: URL(string: "https://www.bliss.org.uk/get-support/online-forum")!)
                        
                        Link("Father's Stories - Tommy's", destination: URL(string: "https://www.tommys.org/our-organisation/charity-news/real-stories")!)
                    }
                    .padding()
                    .background(TinyStepsDesign.Colors.cardBackground)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .navigationTitle("Support")
    }
}

struct SupportContact: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let description: String
}

struct SupportContactView: View {
    let contact: SupportContact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(contact.name)
                    .font(.headline)
                Spacer()
                #if os(iOS)
                Button(action: {
                    let tel = "tel://"
                    let formattedNumber = tel + contact.number
                    guard let url = URL(string: formattedNumber) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Image(systemName: "phone")
                }
                #elseif canImport(AppKit)
                Button(action: {
                    let tel = "tel://"
                    let formattedNumber = tel + contact.number
                    guard let url = URL(string: formattedNumber) else { return }
                    NSWorkspace.shared.open(url)
                }) {
                    Image(systemName: "phone")
                }
                #endif
            }
            
            Text(contact.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(contact.number)
                .font(.callout)
        }
        .padding(.vertical, 8)
    }
}
