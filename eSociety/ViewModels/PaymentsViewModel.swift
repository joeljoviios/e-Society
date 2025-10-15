import Foundation
import Combine

class PaymentsViewModel: ObservableObject {
    @Published var payments: [Payment] = []
    weak var familiesVM: FamiliesViewModel?

    init(familiesVM: FamiliesViewModel?) {
        self.familiesVM = familiesVM
    }

    func load() {
        // payments are embedded inside families; this keeps a flat list optionally
        payments = familiesVM?.families.flatMap({ $0.payments }) ?? []
    }

    func recordPayment(familyId: UUID, amount: Double, date: Date, monthYear: String) {
        let lateFee = calculateLateFee(for: date)
        let p = Payment(amount: amount, date: date, monthYear: monthYear, lateFee: lateFee)
        if let idx = familiesVM?.families.firstIndex(where: { $0.id == familyId }) {
            familiesVM?.families[idx].payments.append(p)
            familiesVM?.save()
            load()
        }
    }

    func calculateLateFee(for date: Date) -> Double {
        // maintenance due on 10th; if after 10th, fine INR 100
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        return day > 10 ? 100.0 : 0.0
    }
}
