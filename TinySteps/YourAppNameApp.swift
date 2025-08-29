import SwiftUI

@main
struct TinyStepsApp: App {
    @StateObject private var dataManager = BabyDataManager()
    @State private var showSidebar = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(showSidebar: $showSidebar)
                    .environmentObject(dataManager)
            }
        }
    }
}
