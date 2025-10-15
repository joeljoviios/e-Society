import SwiftUI

struct ApproverView: View {
    @State private var requests: [ExpenseRequest] = []

    var body: some View {
        List {
            ForEach(requests) { r in
                VStack(alignment: .leading) {
                    Text(r.title).bold()
                    Text("₹\(Int(r.amount)) • \(r.requestedBy)").font(.caption).foregroundColor(.secondary)
                    HStack {
                        Button("Approve") { action(r, true) }
                        Button("Reject") { action(r, false) }
                    }
                }
            }
        }
        .navigationTitle("Pending Approvals")
        .onAppear(perform: load)
    }

    func load() {
        if let s = PersistenceService.shared.load() {
            self.requests = s.expenseRequests.filter { $0.status == .pending }
        }
    }

    func action(_ r: ExpenseRequest, _ approve: Bool) {
        if var s = PersistenceService.shared.load() {
            if let idx = s.expenseRequests.firstIndex(where: { $0.id == r.id }) {
                s.expenseRequests[idx].status = approve ? .approved : .rejected
                PersistenceService.shared.save(families: s.families, requests: s.expenseRequests)
                load()
            }
        }
    }
}
