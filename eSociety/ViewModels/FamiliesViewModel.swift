import Foundation
import Combine

class FamiliesViewModel: ObservableObject {
    @Published var families: [Family] = []

    func load() {
        if let s = PersistenceService.shared.load() {
            self.families = s.families
        } else {
            self.families = []
        }
    }

    func add(_ family: Family) {
        families.append(family)
        save()
    }

    func update(_ family: Family) {
        if let idx = families.firstIndex(where: { $0.id == family.id }) {
            families[idx] = family
            save()
        }
    }

    func save() {
        let requests = PersistenceService.shared.load()?.expenseRequests ?? []
        PersistenceService.shared.save(families: families, requests: requests)
    }

    func defaulters(for monthYear: String) -> [Family] {
        families.filter { f in
            !f.payments.contains(where: { $0.monthYear == monthYear })
        }
    }
}
