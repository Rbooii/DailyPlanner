import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthManager
    @State var loginPressed = false
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily")
                        .font(.system(size: 52, weight: .bold))
                        .offset(y: appeared ? 0 : 30)
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1), value: appeared)

                    Text("Plan.")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(.tint)
                        .offset(y: appeared ? 0 : 30)
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.25), value: appeared)

                    Text("Set a goal. Win the day.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.4), value: appeared)
                }
                .padding(.horizontal, 28)

                Spacer()

                Button(action: { loginPressed = true }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.55), value: appeared)
            }
            .navigationDestination(isPresented: $loginPressed) {
                LoginView()
            }
        }
        .onAppear {
            appeared = true
            if auth.isLoggedIn {
                loginPressed = true
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
