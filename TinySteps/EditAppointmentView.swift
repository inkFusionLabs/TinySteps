import SwiftUI

struct EditAppointmentView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var date: Date
    @State private var time: String
    @State private var location: String
    @State private var notes: String
    @State private var type: Appointment.AppointmentType
    
    let appointment: Appointment
    
    init(appointment: Appointment) {
        self.appointment = appointment
        self._title = State(initialValue: appointment.title)
        self._date = State(initialValue: appointment.startDate)
        self._time = State(initialValue: appointment.time)
        self._location = State(initialValue: appointment.location)
        self._notes = State(initialValue: appointment.notes ?? "")
        self._type = State(initialValue: appointment.type)
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Edit Appointment")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Update appointment details")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 12) {
                    // Title
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., Check-up", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Type
                    VStack(alignment: .leading, spacing: 6) {
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    // Time
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., 09:00 AM", text: $time)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Location")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., Neonatal Unit", text: $location)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(2...4)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 8) {
                    // Update Button
                    Button(action: updateAppointment) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Update Appointment")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(title.isEmpty ? Color.gray : Color.green)
                        .cornerRadius(12)
                    }
                    .disabled(title.isEmpty)
                    
                    // Delete Button
                    Button(action: deleteAppointment) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                            Text("Delete Appointment")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Edit Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
    
    private func updateAppointment() {
        let updatedAppointment = Appointment(
            title: title,
            date: date,
            time: time,
            location: location,
            notes: notes.isEmpty ? nil : notes,
            type: type
        )
        
        dataManager.updateAppointment(updatedAppointment)
        dismiss()
    }
    
    private func deleteAppointment() {
        dataManager.deleteAppointment(appointment)
        dismiss()
    }
}

#Preview {
    NavigationView {
        EditAppointmentView(appointment: Appointment(
            title: "Check-up",
            date: Date(),
            time: "10:00 AM",
            location: "Hospital",
            notes: "Regular check-up",
            type: .checkup
        ))
        .environmentObject(BabyDataManager())
    }
} 