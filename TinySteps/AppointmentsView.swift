import SwiftUI

struct AppointmentsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddAppointment = false
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Appointments")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Manage your baby's healthcare appointments")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddAppointment = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Appointments List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Upcoming Appointments")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(dataManager.appointments.count) appointments")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if dataManager.appointments.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("No appointments scheduled")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("Tap the + button to add your first appointment")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(dataManager.appointments.sorted { $0.startDate < $1.startDate }) { appointment in
                                    AppointmentCard(appointment: appointment)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Appointments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingAddAppointment) {
            NavigationView {
                NewAppointmentView()
            }
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(appointment.startDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    if !appointment.time.isEmpty {
                        Text(appointment.time)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                // Appointment type indicator
                Text(appointment.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(appointment.type.color.opacity(0.3))
                    .foregroundColor(appointment.type.color)
                    .cornerRadius(4)
            }
            
            if !appointment.location.isEmpty {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(appointment.location)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            if let notes = appointment.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationView {
        AppointmentsView()
            .environmentObject(BabyDataManager())
    }
} 