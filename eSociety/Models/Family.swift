import Foundation

struct Family: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var apartmentNo: String
    var headName: String
    var phone: String?
    var payments: [Payment] = []
}
