import Foundation

struct Payment: Identifiable, Codable {
    var id: UUID = UUID()
    var amount: Double
    var date: Date
    var monthYear: String // e.g. "2025-10"
    var lateFee: Double
}

struct ExpenseRequest: Identifiable, Codable {
    enum Status: String, Codable { case pending, approved, rejected }
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var details: String?
    var requestedBy: String
    var status: Status = .pending
    var date: Date = Date()
}
