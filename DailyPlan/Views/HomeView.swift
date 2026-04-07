import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        TabView {
            GoalsView(email: auth.currentEmail())
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview{
    HomeView()
        .environmentObject(AuthManager())
}
