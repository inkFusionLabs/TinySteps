import SwiftUI
import UserNotifications

enum CalendarViewType: String, CaseIterable, Identifiable {
    case month = "Month"
    case day = "Day"
    case year = "Year"
    var id: String { rawValue }
}

struct AppointmentsCalendarView: View {
    @State private var selectedView: CalendarViewType = .month
    @State private var selectedDate: Date = Date()
    @State private var showingAddSheet = false
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack {
                Picker("View Type", selection: $selectedView) {
                    ForEach(CalendarViewType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ZStack(alignment: .bottomTrailing) {
                    switch selectedView {
                    case .month:
                        MonthCalendarView(selectedDate: $selectedDate)
                    case .day:
                        DayCalendarView(selectedDate: $selectedDate)
                    case .year:
                        YearCalendarView(selectedDate: $selectedDate)
                    }
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .shadow(radius: 4)
                    }
                    .padding()
                    .accessibilityLabel("Add Appointment")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddAppointmentSheet(date: selectedDate)
        }
        .navigationTitle("Appointments")
    }
}

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var dataManager: BabyDataManager
    let calendar = Calendar.current
    @State private var editingAppointment: Appointment? = nil
    @State private var showingEditSheet = false
    
    var body: some View {
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        let daysInMonthRange = calendar.range(of: .day, in: .month, for: selectedDate) ?? 1..<31
        let days = Array(daysInMonthRange)
        let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
        let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
        let gridItems = Array(repeating: GridItem(.flexible()), count: 7)
        
        VStack {
            HStack {
                Button(action: {
                    if let prevMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
                        selectedDate = prevMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(calendar.monthSymbols[month-1]) \(year)")
                    .font(.headline)
                Spacer()
                Button(action: {
                    if let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
                        selectedDate = nextMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: gridItems, spacing: 8) {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { day in
                    Text(day).font(.caption).foregroundColor(.secondary)
                }
                ForEach(0..<(weekdayOffset < 0 ? 7 + weekdayOffset : weekdayOffset), id: \.self) { _ in
                    Text("").frame(height: 32)
                }
                ForEach(days, id: \.self) { day in
                    let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
                    let hasAppointments = dataManager.appointments.contains { calendar.isDate($0.startDate, inSameDayAs: date) }
                    Button(action: { selectedDate = date }) {
                        VStack(spacing: 2) {
                            Text("\(day)")
                                .frame(width: 32, height: 32)
                                .background(calendar.isDate(selectedDate, inSameDayAs: date) ? Color.blue : Color.clear)
                                .foregroundColor(calendar.isDate(selectedDate, inSameDayAs: date) ? .white : .primary)
                                .clipShape(Circle())
                            if hasAppointments {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Appointments for selected day
            let todaysAppointments = dataManager.appointments.filter { calendar.isDate($0.startDate, inSameDayAs: selectedDate) }
            if !todaysAppointments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Appointments for \(dateFormatter.string(from: selectedDate))")
                        .font(.headline)
                        .padding(.top, 8)
                    ForEach(todaysAppointments) { appt in
                        Button(action: {
                            editingAppointment = appt
                            showingEditSheet = true
                        }) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appt.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                if !appt.location.isEmpty {
                                    Text(appt.location)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text("\(timeFormatter.string(from: appt.startDate)) - \(timeFormatter.string(from: appt.endDate))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                if let notes = appt.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No appointments for this day.")
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
            Spacer()
        }
        .sheet(item: $editingAppointment) { appt in
            EditAppointmentSheet(appointment: appt)
                .environmentObject(dataManager)
        }
    }
}

struct AddAppointmentSheet: View {
    let date: Date
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var isAllDay: Bool = false
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var notes: String = ""
    @State private var reminderMinutes: Int = 30
    
    let reminderOptions: [Int] = [0, 5, 10, 15, 30, 60, 120, 1440] // in minutes
    
    init(date: Date) {
        _startDate = State(initialValue: date)
        _endDate = State(initialValue: Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date)
        self.date = date
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                Form {
                Section(header: Text("Title")) {
                    TextField("Appointment Title", text: $title)
                }
                Section(header: Text("Location")) {
                    TextField("Location", text: $location)
                }
                Section {
                    Toggle("All-day", isOn: $isAllDay)
                    DatePicker("Start", selection: $startDate, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
                    DatePicker("End", selection: $endDate, displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute])
                }
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }
                Section(header: Text("Reminder")) {
                    Picker("Alert", selection: $reminderMinutes) {
                        Text("None").tag(0)
                        Text("At time of event").tag(0)
                        Text("5 minutes before").tag(5)
                        Text("10 minutes before").tag(10)
                        Text("15 minutes before").tag(15)
                        Text("30 minutes before").tag(30)
                        Text("1 hour before").tag(60)
                        Text("2 hours before").tag(120)
                        Text("1 day before").tag(1440)
                    }
                    .pickerStyle(.menu)
                }
                }
            }
            .navigationTitle("New Appointment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let appointment = Appointment(
                            title: title,
                            location: location,
                            isAllDay: isAllDay,
                            startDate: startDate,
                            endDate: endDate,
                            notes: notes.isEmpty ? nil : notes,
                            reminderMinutes: reminderMinutes
                        )
                        dataManager.addAppointment(appointment)
                        scheduleNotification(for: appointment)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func scheduleNotification(for appointment: Appointment) {
        guard appointment.reminderMinutes > 0 else { return }
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = appointment.title
            content.body = "Appointment at \(dateFormatter.string(from: appointment.startDate))"
            content.sound = .default
            let triggerDate = Calendar.current.date(byAdding: .minute, value: -appointment.reminderMinutes, to: appointment.startDate) ?? appointment.startDate
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
            let request = UNNotificationRequest(identifier: appointment.id.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
}

struct EditAppointmentSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    @State var appointment: Appointment
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                Form {
                Section(header: Text("Title")) {
                    TextField("Appointment Title", text: $appointment.title)
                }
                Section(header: Text("Location")) {
                    TextField("Location", text: $appointment.location)
                }
                Section {
                    Toggle("All-day", isOn: $appointment.isAllDay)
                    DatePicker("Start", selection: $appointment.startDate, displayedComponents: appointment.isAllDay ? [.date] : [.date, .hourAndMinute])
                    DatePicker("End", selection: $appointment.endDate, displayedComponents: appointment.isAllDay ? [.date] : [.date, .hourAndMinute])
                }
                Section(header: Text("Notes")) {
                    TextEditor(text: Binding(get: { appointment.notes ?? "" }, set: { appointment.notes = $0 }))
                        .frame(minHeight: 60)
                }
                Section(header: Text("Reminder")) {
                    Picker("Alert", selection: $appointment.reminderMinutes) {
                        Text("None").tag(0)
                        Text("At time of event").tag(0)
                        Text("5 minutes before").tag(5)
                        Text("10 minutes before").tag(10)
                        Text("15 minutes before").tag(15)
                        Text("30 minutes before").tag(30)
                        Text("1 hour before").tag(60)
                        Text("2 hours before").tag(120)
                        Text("1 day before").tag(1440)
                    }
                    .pickerStyle(.menu)
                }
                Section {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete Appointment", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Edit Appointment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dataManager.updateAppointment(appointment)
                        updateNotification(for: appointment)
                        dismiss()
                    }
                    .disabled(appointment.title.isEmpty)
                }
            }
            .alert("Delete this appointment?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    dataManager.deleteAppointment(appointment)
                    removeNotification(for: appointment)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    private func updateNotification(for appointment: Appointment) {
        removeNotification(for: appointment)
        if appointment.reminderMinutes > 0 {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = appointment.title
            content.body = "Appointment at \(dateFormatter.string(from: appointment.startDate))"
            content.sound = .default
            let triggerDate = Calendar.current.date(byAdding: .minute, value: -appointment.reminderMinutes, to: appointment.startDate) ?? appointment.startDate
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
            let request = UNNotificationRequest(identifier: appointment.id.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    private func removeNotification(for appointment: Appointment) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [appointment.id.uuidString])
    }
}

// Helper for optional binding
extension Binding where Value == String? {
    init(_ source: Binding<String?>, replacingNilWith defaultValue: String) {
        self.init(get: { source.wrappedValue ?? defaultValue }, set: { source.wrappedValue = $0 })
    }
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .full
    return df
}()

private let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    return df
}()

struct DayCalendarView: View {
    @Binding var selectedDate: Date
    var body: some View {
        Text("Day View (coming soon)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
    }
}

struct YearCalendarView: View {
    @Binding var selectedDate: Date
    var body: some View {
        Text("Year View (coming soon)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
    }
} 