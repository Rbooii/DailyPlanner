import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var email: String = ""
    @State private var pw: String = ""
    @State private var errorMessage: String = ""
    @State private var isRegistering: Bool = false
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // MARK: - Header
            VStack(alignment: .leading, spacing: 6) {
                Text(isRegistering ? "Create" : "Welcome")
                    .font(.system(size: 48, weight: .bold))
                    .contentTransition(.numericText())

                Text(isRegistering ? "Account." : "Back.")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.tint)
                    .contentTransition(.numericText())

                Text(isRegistering ? "Start planning your days." : "Sign in to continue your streak.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                    .contentTransition(.opacity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
            .offset(y: appeared ? 0 : 30)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1), value: appeared)

            // MARK: - Form
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

                // Error
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Button(action: handleAction) {
                    Text(isRegistering ? "Register" : "Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 28)
            .offset(y: appeared ? 0 : 30)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.25), value: appeared)

            Spacer()

            // MARK: - Footer
            HStack(spacing: 4) {
                Text(isRegistering ? "Already have an account?" : "Don't have an account?")
                    .foregroundStyle(.secondary)
                    .contentTransition(.opacity)
                Button(isRegistering ? "Sign In" : "Sign Up") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isRegistering.toggle()
                        errorMessage = ""
                    }
                }
                .fontWeight(.semibold)
                .contentTransition(.opacity)
            }
            .font(.subheadline)
            .padding(.bottom, 32)
            .offset(y: appeared ? 0 : 20)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.4), value: appeared)
        }
        .onAppear {
            appeared = true
        }
    }

    private func handleAction() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
