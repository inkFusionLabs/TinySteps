//
//  SettingsView.swift
//  TinySteps
//
//  Created to provide quick app preferences
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var themeManager: ThemeManager
	@StateObject private var accessibilityManager = AccessibilityManager.shared
	@State private var selectedTheme: ThemeManager.AppTheme = .organic
	
	@AppStorage("enable_haptics") private var enableHaptics: Bool = true
	@AppStorage("override_reduce_motion") private var overrideReduceMotion: Bool = false
	
	private var appVersion: String {
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
		let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
		return "v\(version) (\(build))"
	}
	
	var body: some View {
		NavigationView {
			ZStack {
				themeManager.currentTheme.colors.background
					.ignoresSafeArea()

			List {
					Section(header: Text("Appearance").foregroundColor(themeManager.currentTheme.colors.textSecondary)) {
					Picker(selection: $selectedTheme) {
						ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
								Text(theme.rawValue)
									.foregroundColor(themeManager.currentTheme.colors.textPrimary)
									.tag(theme)
						}
					} label: {
						Label("App Theme", systemImage: "paintpalette")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
					}
					.onChange(of: selectedTheme) { _, newValue in
						themeManager.setTheme(newValue)
					}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
				}
				
					Section(header: Text("Preferences").foregroundColor(themeManager.currentTheme.colors.textSecondary)) {
					Toggle(isOn: $enableHaptics) {
						Label("Enable Haptics", systemImage: "waveform")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
					}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
						.toggleStyle(SwitchToggleStyle(tint: themeManager.currentTheme.colors.accent))
					
					Toggle(isOn: $overrideReduceMotion) {
						Label("Reduce Motion (App)", systemImage: "slowmo")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
					}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
					.toggleStyle(SwitchToggleStyle(tint: themeManager.currentTheme.colors.accent))
					
					if accessibilityManager.isReduceMotionEnabled {
						Text("System Reduce Motion is enabled")
							.font(.footnote)
								.foregroundColor(themeManager.currentTheme.colors.textTertiary)
								.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
					}
					}

					Section(header: Text("Home Screen").foregroundColor(themeManager.currentTheme.colors.textSecondary)) {
						NavigationLink {
							HomeScreenCustomizationView()
								.environmentObject(themeManager)
								.environmentObject(DataPersistenceManager.shared)
						} label: {
							Label("Customize Home Screen", systemImage: "rectangle.grid.2x2.fill")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
						}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
				}
				
					Section(header: Text("About").foregroundColor(themeManager.currentTheme.colors.textSecondary)) {
					HStack {
						Label("Version", systemImage: "number")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
						Spacer()
							Text(appVersion)
								.foregroundColor(themeManager.currentTheme.colors.textSecondary)
					}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
					
					HStack {
						Label("Theme", systemImage: "paintpalette")
								.foregroundColor(themeManager.currentTheme.colors.textPrimary)
						Spacer()
							Text(themeManager.currentTheme.rawValue)
								.foregroundColor(themeManager.currentTheme.colors.textSecondary)
						}
						.listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
					}
				}
				.scrollContentBackground(.hidden)
				.background(themeManager.currentTheme.colors.background)
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						dismiss()
					}
					.foregroundColor(themeManager.currentTheme.colors.accent)
				}
			}
		}
		.errorHandling()
		.onAppear {
			selectedTheme = themeManager.currentTheme
		}
	}
}

#Preview {
	SettingsView()
		.environmentObject(ThemeManager.shared)
}


