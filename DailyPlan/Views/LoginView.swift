import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var email: String = ""
    @State private var pw: String = ""
    @State private var errorMessage: String = ""
    @State private var isRegistering: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            Spacer()
            // MARK: - Header
            VStack(spacing: 8) {
                
                Text(isRegistering ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .animation(.default, value: isRegistering)

                Text(isRegistering ? "Start planning your days" : "Sign in to continue your streak")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 48)

            // MARK: - Form
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        SecureField("Password", text: $pw)
                            .textContentType(isRegistering ? .newPassword : .password)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Error
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }

                Button(action: handleAction) {
                    Text(isRegistering ? "Register" : "Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)

            Spacer()

            // MARK: - Footer
            HStack(spacing: 4) {
                Text(isRegistering ? "Already have an account?" : "Don't have an account?")
                    .foregroundStyle(.secondary)
                Button(isRegistering ? "Sign In" : "Sign Up") {
                    withAnimation { isRegistering.toggle() }
                    errorMessage = ""
                }
                .fontWeight(.semibold)
            }
            .font(.subheadline)
            .padding(.bottom, 32)
        }
    }

    private func handleAction() {
        if isRegistering {
            if let error = auth.register(email: email, password: pw) {
                errorMessage = error
            } else {
                _ = auth.login(email: email, password: pw)
            }
        } else {
            if let error = auth.login(email: email, password: pw) {
                errorMessage = error
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
