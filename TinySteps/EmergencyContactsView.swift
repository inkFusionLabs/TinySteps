import SwiftUI

struct EmergencyContactsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingAddContact = false
    @State private var editingContact: EmergencyContact?
    @State private var showingDeleteAlert = false
    @State private var contactToDelete: EmergencyContact?
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                if dataManager.emergencyContacts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        Text("No Emergency Contacts")
                            .font(.title2)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Text("Add important contacts for quick access")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingAddContact = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Contact")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(dataManager.emergencyContacts) { contact in
                            EmergencyContactRow(contact: contact)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        contactToDelete = contact
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        editingContact = contact
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Emergency Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddContact = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddContact) {
            AddEmergencyContactView { contact in
                dataManager.addEmergencyContact(contact)
            }
        }
        .sheet(item: $editingContact) { contact in
            AddEmergencyContactView(editingContact: contact) { updatedContact in
                if let index = dataManager.emergencyContacts.firstIndex(where: { $0.id == contact.id }) {
                    dataManager.emergencyContacts[index] = updatedContact
                    dataManager.saveData()
                }
            }
        }
        .alert("Delete Contact", isPresented: $showingDeleteAlert, presenting: contactToDelete) { contact in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                withAnimation {
                    dataManager.emergencyContacts.removeAll { $0.id == contact.id }
                    dataManager.saveData()
                }
            }
        } message: { contact in
            Text("Are you sure you want to delete \(contact.name)?")
        }
    }
}

struct EmergencyContactRow: View {
    let contact: EmergencyContact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text(contact.relationship)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button {
                    guard let url = URL(string: "tel://\(contact.phoneNumber)") else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Text(contact.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                if contact.isEmergency {
                    Spacer()
                    Text("Emergency")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(4)
                }
            }
            
            if let notes = contact.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(DesignSystem.Colors.backgroundSecondary)
    }
}

struct AddEmergencyContactView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (EmergencyContact) -> Void
    
    var editingContact: EmergencyContact?
    
    @State private var name: String = ""
    @State private var relationship: String = ""
    @State private var phoneNumber: String = ""
    @State private var isEmergency: Bool = false
    @State private var canPickup: Bool = false
    @State private var notes: String = ""
    
    init(editingContact: EmergencyContact? = nil, onSave: @escaping (EmergencyContact) -> Void) {
        self.onSave = onSave
        self.editingContact = editingContact
        
        if let contact = editingContact {
            _name = State(initialValue: contact.name)
            _relationship = State(initialValue: contact.relationship)
            _phoneNumber = State(initialValue: contact.phoneNumber)
            _isEmergency = State(initialValue: contact.isEmergency)
            _canPickup = State(initialValue: contact.canPickup)
            _notes = State(initialValue: contact.notes ?? "")
        }
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
                                Text(editingContact == nil ? "Add Contact" : "Edit Contact")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Text("Add important contact details")
                                    .font(.subheadline)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(DesignSystem.Colors.backgroundSecondary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Form Content
                    VStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("Enter name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Relationship")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("Enter relationship", text: $relationship)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone Number")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("Enter phone number", text: $phoneNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        .padding(.horizontal)
                        
                        Toggle("Emergency Contact", isOn: $isEmergency)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.horizontal)
                        
                        Toggle("Can Pick Up Baby", isOn: $canPickup)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("Add any additional notes", text: $notes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 100)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let contact = EmergencyContact(
                            id: editingContact?.id ?? UUID(),
                            name: name,
                            relationship: relationship,
                            phoneNumber: phoneNumber,
                            isEmergency: isEmergency,
                            canPickup: canPickup,
                            notes: notes.isEmpty ? nil : notes
                        )
                        onSave(contact)
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .disabled(name.isEmpty || relationship.isEmpty || phoneNumber.isEmpty)
                }
            }
        }
    }
}