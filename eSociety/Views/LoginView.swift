import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = "admin@esociety"
    @State private var password = "password"
    @State private var showError = false

    var body: some View {
        ZStack {
            LinearGradient.primary.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Text("eSociety").font(.largeTitle).bold().foregroundColor(.white)
                Text("Sign in").foregroundColor(.white.opacity(0.9))
                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding()
                Button(action: {
                    let ok = auth.login(email: email, password: password)
                    showError = !ok
                }) {
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                if showError {
                    Text("Invalid credentials").foregroundColor(.white)
                }
                Spacer()
                Text("Demo accounts: admin@esociety / password, checker@esociety / password")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}
