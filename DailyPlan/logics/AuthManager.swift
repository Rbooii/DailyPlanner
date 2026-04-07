import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    private let sessionKey = "loggedInEmail"
    private let usersKey = "registeredUsers"
    
    init() {
        isLoggedIn = UserDefaults.standard.string(forKey: sessionKey) != nil
    }
    
    // MARK: - Register
    func register(email: String, password: String) -> String? {
        guard !email.isEmpty, !password.isEmpty else { return "Email dan password tidak boleh kosong." }
        var users = getUsers()
        guard users[email] == nil else { return "Email sudah terdaftar." }
        users[email] = password
        saveUsers(users)
        return nil
    }
    
    // MARK: - Login
    func login(email: String, password: String) -> String? {
        let users = getUsers()
        guard let stored = users[email] else { return "Email tidak ditemukan." }
        guard stored == password else { return "Password salah." }
        UserDefaults.standard.set(email, forKey: sessionKey)
        isLoggedIn = true
        print("logged in successfully")
        return nil
    }
    
    // MARK: - Logout
    func logout() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        isLoggedIn = false
    }
    
    func currentEmail() -> String {
        UserDefaults.standard.string(forKey: sessionKey) ?? ""
    }
    
    func deleteAccount() {
        var users = getUsers()
        let email = currentEmail()
        users.removeValue(forKey: email)
        saveUsers(users)
        logout()
    }
    
    // MARK: - Helpers
    private func getUsers() -> [String: String] {
        UserDefaults.standard.dictionary(forKey: usersKey) as? [String: String] ?? [:]
    }
    
    private func saveUsers(_ users: [String: String]) {
        UserDefaults.standard.set(users, forKey: usersKey)
    }
}
