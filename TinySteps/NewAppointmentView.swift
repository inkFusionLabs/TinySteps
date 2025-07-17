import SwiftUI

struct NewAppointmentView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var date = Date()
    @State private var time = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var type: Appointment.AppointmentType = .checkup
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("New Appointment")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Schedule a healthcare appointment")
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
                
                // Form
                VStack(spacing: 15) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., Check-up", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.headline)
                            .foregroundColor(.white)
                        Picker("Type", selection: $type) {
                            ForEach(Appointment.AppointmentType.allCases, id: \.self) { appointmentType in
                                Text(appointmentType.rawValue).tag(appointmentType)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    // Time
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., 09:00 AM", text: $time)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., Neonatal Unit", text: $location)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                Button(action: saveAppointment) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Appointment")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(12)
                }
                .disabled(title.isEmpty)
                .padding(.horizontal)
            }
        }
        .navigationTitle("New Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
    
    private func saveAppointment() {
        let appointment = Appointment(
            title: title,
            date: date,
            time: time,
            location: location,
            notes: notes.isEmpty ? nil : notes,
            type: type
        )
        
        dataManager.addAppointment(appointment)
        dismiss()
    }
}

#Preview {
    NavigationView {
        NewAppointmentView()
            .environmentObject(BabyDataManager())
    }
} 