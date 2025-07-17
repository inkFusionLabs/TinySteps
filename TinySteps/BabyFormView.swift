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
    @State private var milkEstimate: Double? = nil
    
    init(babyToEdit: Baby? = nil) {
        self.babyToEdit = babyToEdit
        if let baby = babyToEdit {
            _name = State(initialValue: baby.name)
            _birthDate = State(initialValue: baby.birthDate)
            _weight = State(initialValue: baby.weight != nil ? String(format: "%.2f", baby.weight!) : "")
            _weightUnit = State(initialValue: "kg")
            _height = State(initialValue: baby.height != nil ? String(format: "%.2f", baby.height!) : "")
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
                TinyStepsDesign.Colors.background
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
                                    .foregroundColor(.white.opacity(0.5))
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
                                .foregroundColor(.white)
                            TextField("Enter baby's name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Birth Date")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
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
                                .foregroundColor(.white)
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
                                #else
                                TextField("Weight", text: $weight)
                                    .frame(width: 100)
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
                                .foregroundColor(.white)
                            TextField("0", text: $height)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.8), value: animateContent)
                        VStack(alignment: .leading, spacing: 12) {
                            Toggle("Premature Baby", isOn: $isPremature)
                                .foregroundColor(.white)
                                .toggleStyle(SwitchToggleStyle(tint: .orange))
                            if isPremature {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Due Date")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.8))
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
                                .foregroundColor(.white)
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
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.6 : 1.0)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.0), value: animateContent)
                        if showMilkEstimate, let milkEstimate = milkEstimate {
                            VStack(spacing: 10) {
                                Text("Estimated Daily Milk Requirement")
                                    .font(.headline)
                                    .foregroundColor(.white)
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
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
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
                    .foregroundColor(.white)
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
