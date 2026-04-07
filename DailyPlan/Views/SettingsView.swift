import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.tint)
                        VStack(alignment: .leading) {
                            Text(auth.currentEmail())
                                .font(.headline)
                            Text("Free Plan")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section {
                    Button(role: .destructive) {
                        auth.logout()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }

                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("Delete Account", systemImage: "trash")
                    }
                    .confirmationDialog(
                        "Hapus Akun?",
                        isPresented: $showDeleteConfirm,
                        titleVisibility: .visible
                    ) {
                        Button("Hapus Akun", role: .destructive) {
                            auth.deleteAccount()
                        }
                        Button("Batal", role: .cancel) {}
                    } message: {
                        Text("Akun dan semua data kamu akan dihapus permanen.")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
}
