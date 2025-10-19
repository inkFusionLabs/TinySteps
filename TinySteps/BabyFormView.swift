import SwiftUI
#if canImport(PhotosUI)
import PhotosUI
#endif
#if canImport(UIKit)
import UIKit
#endif

struct BabyFormView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) private var dismiss
    
    var babyToEdit: Baby? = nil
    
    @State private var name = ""
    @State private var birthDate = Date()
    @State private var weight = ""
    @State private var weightUnit: String = "kg"
    @State private var height = ""
    @State private var isPremature = false
    @State private var dueDate = Date()
    @State private var gender: Baby.Gender = .unknown
    @State private var feedingMethod: String = "Breastfed"
    @State private var animateContent = false
#if os(iOS)
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var babyImage: Image? = nil
    @State private var babyImageData: Data? = nil
#endif
    @State private var showMilkEstimate: Bool = false
    @StateObject private var formValidator = FormValidator()
    
    // Validation states
    private var nameValidation: ValidationResult {
        InputValidator.validateName(name)
    }
    
    private var weightValidation: ValidationResult {
        InputValidator.validateWeight(weight, unit: weightUnit)
    }
    
    private var heightValidation: ValidationResult {
        InputValidator.validateHeight(height)
    }
    
    private var birthDateValidation: ValidationResult {
        InputValidator.validateBirthDate(birthDate)
    }
    
    private var dueDateValidation: ValidationResult {
        InputValidator.validateDueDate(dueDate, birthDate: birthDate)
    }
    
    private var isFormValid: Bool {
        nameValidation.isValid && 
        weightValidation.isValid && 
        heightValidation.isValid && 
        birthDateValidation.isValid && 
        (!isPremature || dueDateValidation.isValid)
    }
    @State private var milkEstimate: Double? = nil
    
    init(babyToEdit: Baby? = nil) {
        self.babyToEdit = babyToEdit
        if let baby = babyToEdit {
            _name = State(initialValue: baby.name)
            _birthDate = State(initialValue: baby.birthDate)
            _weight = State(initialValue: baby.weight.map { String(format: "%.2f", $0) } ?? "")
            _weightUnit = State(initialValue: "kg")
            _height = State(initialValue: baby.height.map { String(format: "%.2f", $0) } ?? "")
            _isPremature = State(initialValue: baby.dueDate != nil)
            _dueDate = State(initialValue: baby.dueDate ?? Date())
            _gender = State(initialValue: baby.gender)
            _feedingMethod = State(initialValue: baby.feedingMethod ?? "Breastfed")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 8) {
#if os(iOS)
                            if let babyImage = babyImage {
                                babyImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                    .shadow(radius: 8)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(DesignSystem.Colors.textTertiary)
                            }
                            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                                Text(babyImage == nil ? "Add Photo" : "Change Photo")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
#else
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.white.opacity(0.5))
#endif
                        }
                        .padding(.top, 10)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Baby's Name")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("Enter baby's name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .validation(nameValidation)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Birth Date")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            DatePicker("", selection: $birthDate, displayedComponents: [.date])
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .colorScheme(.dark)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.2), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Gender")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            Picker("Gender", selection: $gender) {
                                ForEach(Baby.Gender.allCases, id: \.self) { gender in
                                    Text(gender.rawValue).tag(gender)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.4), value: animateContent)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                #if os(iOS)
                                TextField("Weight", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .frame(width: 100)
                                    .validation(weightValidation)
                                #else
                                TextField("Weight", text: $weight)
                                    .frame(width: 100)
                                    .validation(weightValidation)
                                #endif
                                Picker("Unit", selection: $weightUnit) {
                                    Text("kg").tag("kg")
                                    Text("lbs").tag("lbs")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 100)
                            }
                            .padding(.vertical, 4)
                            Text("Enter your baby's weight in kilograms or pounds.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.6), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Height (cm)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            TextField("0", text: $height)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .validation(heightValidation)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.8), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Toggle("Premature Baby", isOn: $isPremature)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .toggleStyle(SwitchToggleStyle(tint: .orange))
                            if isPremature {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Due Date")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                    DatePicker("", selection: $dueDate, displayedComponents: [.date])
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                }
                            }
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.0), value: animateContent)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feeding Method")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            Picker("Feeding Method", selection: $feedingMethod) {
                                Text("Breastfed").tag("Breastfed")
                                Text("Bottle-fed").tag("Bottle-fed")
                                Text("Both").tag("Both")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.2), value: animateContent)
                        Button(action: saveBaby) {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.headline)
                                Text("Save Baby")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.clear)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.0), value: animateContent)
                        if showMilkEstimate, let milkEstimate = milkEstimate {
                            VStack(spacing: 10) {
                                Text("Estimated Daily Milk Requirement")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                Text("~ \(Int(milkEstimate)) ml per day")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("This is an estimate based on 150ml per kg of body weight per day. Always consult your healthcare provider for feeding advice.")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                            }
                            .padding()
                            .background(Color.clear)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Baby")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                }
            }
            .onAppear {
                withAnimation {
                    animateContent = true
                }
            }
#if os(iOS)
            .onChange(of: selectedPhoto) { _, newItem in
                if let newItem = newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            babyImage = Image(uiImage: uiImage)
                            babyImageData = data
                        }
                    }
                }
            }
#endif
        }
    }
    private func saveBaby() {
        // Validate all fields before saving
        guard isFormValid else {
            // Update form validator to show all errors
            formValidator.validateField("name", value: name, validation: nameValidation)
            formValidator.validateField("weight", value: weight, validation: weightValidation)
            formValidator.validateField("height", value: height, validation: heightValidation)
            formValidator.validateField("birthDate", value: "", validation: birthDateValidation)
            if isPremature {
                formValidator.validateField("dueDate", value: "", validation: dueDateValidation)
            }
            return
        }
        
        var weightValue: Double? = Double(weight)
        if weightUnit == "lbs", let lbs = weightValue {
            weightValue = lbs * 0.453592 // convert pounds to kg
        }
        let photoURL: String? = nil
        // Optionally, save the image to disk and store the URL
        // For now, just keep nil or you can implement saving if needed
        let baby = Baby(
            name: name,
            birthDate: birthDate,
            weight: weightValue,
            height: Double(height),
            dueDate: isPremature ? dueDate : nil,
            gender: gender,
            photoURL: photoURL,
            feedingMethod: feedingMethod // Pass feeding method
        )
        // Update or add baby
        dataManager.baby = baby
        dataManager.saveData()
        if (feedingMethod == "Bottle-fed" || feedingMethod == "Both"), let weightValue = weightValue {
            milkEstimate = weightValue * 150 // 150ml per kg per day
            showMilkEstimate = true
        }
        dismiss()
    }
} 
