import SwiftUI

struct AppColors {
    static let start = Color(hex: "00B4D8")
    static let mid = Color(hex: "0077B6")
    static let end = Color(hex: "023E8A")
    static let bg = Color(hex: "F7FAFC")
    static let card = Color.white
    static let primaryText = Color(hex: "0F172A")
    static let secondaryText = Color(hex: "475569")
}

extension LinearGradient {
    static var primary: LinearGradient {
        LinearGradient(colors: [AppColors.start, AppColors.mid, AppColors.end],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension View {
    func gradientBackground() -> some View {
        self.background(LinearGradient.primary.ignoresSafeArea())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0,0,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: 1)
    }
}
