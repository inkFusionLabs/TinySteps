import SwiftUI
import Foundation

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
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("New Appointment")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            
                            Text("Schedule a healthcare appointment")
                                .font(.subheadline)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(red: 0.18, green: 0.21, blue: 0.28).opacity(0.95))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 15) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        TextField("e.g., Check-up", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        Menu {
                            ForEach(Appointment.AppointmentType.allCases, id: \.self) { appointmentType in
                                Button(appointmentType.rawValue) {
                                    type = appointmentType
                                }
                            }
                        } label: {
                            HStack {
                                Text(type.rawValue)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                            .padding()
                            .background(Color(red: 0.18, green: 0.21, blue: 0.28).opacity(0.95))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(TinyStepsDesign.Colors.cardBackground.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    // Time
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        TextField("e.g., Neonatal Unit", text: $location)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding()
                .background(Color(red: 0.18, green: 0.21, blue: 0.28).opacity(0.95))
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
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
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
                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
            }
        }
    }
    
    private func saveAppointment() {
        var appointment = Appointment(
            title: title,
            location: location,
            isAllDay: false,
            startDate: date,
            endDate: Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date,
            notes: notes.isEmpty ? nil : notes,
            reminderMinutes: 15
        )
        
        appointment.type = type
        appointment.time = timeFormatter.string(from: date)
        
        dataManager.addAppointment(appointment)
        dismiss()
    }
    
    // Using global timeFormatter from BabyData.swift
}

#Preview {
    NavigationView {
        NewAppointmentView()
            .environmentObject(BabyDataManager())
    }
} 