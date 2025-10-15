import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    private let key = "eSocietyDemo_v1"

    struct Storage: Codable {
        var families: [Family]
        var expenseRequests: [ExpenseRequest]
    }

    func save(families: [Family], requests: [ExpenseRequest]) {
        let s = Storage(families: families, expenseRequests: requests)
        if let data = try? JSONEncoder().encode(s) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> Storage? {
        if let data = UserDefaults.standard.data(forKey: key),
           let s = try? JSONDecoder().decode(Storage.self, from: data) {
            return s
        }
        return nil
    }
    
    func seedIfNeeded() {
        if load() != nil { return }
        // seed basic data
        let f1 = Family(name: "Rao Family", apartmentNo: "A-101", headName: "Rao", phone: "9492280940", payments: [])
        let f2 = Family(name: "Singh Family", apartmentNo: "A-102", headName: "Singh", phone: "9430375737", payments: [])
        let f3 = Family(name: "Patel Family", apartmentNo: "A-103", headName: "Patel", phone: "9613869881", payments: [])
        let f4 = Family(name: "Sharma Family", apartmentNo: "A-104", headName: "Sharma", phone: "9448464611", payments: [])
        let f5 = Family(name: "Nair Family", apartmentNo: "A-105", headName: "Nair", phone: "9276963089", payments: [])
        let f6 = Family(name: "Das Family", apartmentNo: "B-106", headName: "Das", phone: "9904645181", payments: [])
        let f7 = Family(name: "Iyer Family", apartmentNo: "B-107", headName: "Iyer", phone: "9412440949", payments: [])
        let f8 = Family(name: "Reddy Family", apartmentNo: "B-108", headName: "Reddy", phone: "9232262411", payments: [])
        let f9 = Family(name: "Chopra Family", apartmentNo: "B-109", headName: "Chopra", phone: "9976414695", payments: [])
        let f10 = Family(name: "Mehta Family", apartmentNo: "B-110", headName: "Mehta", phone: "9771584349", payments: [])
        save(families: [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10], requests: [])
    }

}
