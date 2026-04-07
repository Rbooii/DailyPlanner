import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        if auth.isLoggedIn {
            HomeView()
        } else {
            ContentView()
        }
    }
}

#Preview{
    RootView()
        .environmentObject(AuthManager())
}
