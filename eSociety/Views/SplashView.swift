import SwiftUI

struct SplashView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient.primary
            VStack {
                Spacer()
                Text("eSociety")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1 : 0.6)
                Text("Community Maintenance Manager")
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 8)
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                animate = true
            }
        }
    }
}
