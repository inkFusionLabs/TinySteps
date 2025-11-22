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
			List {
				Section(header: Text("Appearance")) {
					Picker(selection: $selectedTheme) {
						ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
							Text(theme.rawValue).tag(theme)
						}
					} label: {
						Label("App Theme", systemImage: "paintpalette")
					}
					.onChange(of: selectedTheme) { _, newValue in
						themeManager.setTheme(newValue)
					}
				}
				
				Section(header: Text("Preferences")) {
					Toggle(isOn: $enableHaptics) {
						Label("Enable Haptics", systemImage: "waveform")
					}
					
					Toggle(isOn: $overrideReduceMotion) {
						Label("Reduce Motion (App)", systemImage: "slowmo")
					}
					.toggleStyle(SwitchToggleStyle(tint: themeManager.currentTheme.colors.accent))
					
					if accessibilityManager.isReduceMotionEnabled {
						Text("System Reduce Motion is enabled")
							.font(.footnote)
							.foregroundColor(.secondary)
					}
				}
				
				Section(header: Text("About")) {
					HStack {
						Label("Version", systemImage: "number")
						Spacer()
						Text(appVersion).foregroundColor(.secondary)
					}
					
					HStack {
						Label("Theme", systemImage: "paintpalette")
						Spacer()
						Text(themeManager.currentTheme.rawValue).foregroundColor(.secondary)
					}
				}
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") { dismiss() }
				}
			}
		}
		.onAppear {
			selectedTheme = themeManager.currentTheme
		}
	}
}

#Preview {
	SettingsView()
		.environmentObject(ThemeManager.shared)
}


