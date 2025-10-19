import SwiftUI

struct SkinToSkinSession: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var duration: TimeInterval
    var notes: String?
}

struct SkinToSkinHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("skinToSkinSessions") private var sessionsData: Data = Data()
    @State private var sessions: [SkinToSkinSession] = []
    
    private var sortedSessions: [SkinToSkinSession] {
        sessions.sorted { $0.date > $1.date }
    }
    
    private var totalDuration: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Skin-to-Skin History")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Track bonding time with your baby")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Stats Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Sessions")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(sessions.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Total Time")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                Text(formatDuration(totalDuration))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if sessions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("No Skin-to-Skin Sessions")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Start a skin-to-skin session to begin tracking")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(sortedSessions) { session in
                                SkinToSkinSessionRow(session: session)
                            }
                            .onDelete(perform: deleteSessions)
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            loadSessions()
        }
    }
    
    private func loadSessions() {
        if let decoded = try? JSONDecoder().decode([SkinToSkinSession].self, from: sessionsData) {
            sessions = decoded
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            sessionsData = encoded
        }
    }
    
    private func deleteSessions(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        saveSessions()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct SkinToSkinSessionRow: View {
    let session: SkinToSkinSession
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                
                Text(dateFormatter.string(from: session.date))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(formatDuration(session.duration))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            if let notes = session.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.white.opacity(0.1))
    }
}

