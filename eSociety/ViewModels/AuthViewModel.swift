import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUserEmail: String? = nil
    @Published var role: String = "maker" // "maker" or "checker"

    func login(email: String, password: String) -> Bool {
        // mock auth
        if (email == "admin@esociety" || email == "checker@esociety") && password == "password" {
            isLoggedIn = true
            currentUserEmail = email
            role = email == "checker@esociety" ? "checker" : "maker"
            return true
        }
        return false
    }

    func logout() {
        isLoggedIn = false
        currentUserEmail = nil
    }
}
