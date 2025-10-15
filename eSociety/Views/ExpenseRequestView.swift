import SwiftUI

struct ExpenseRequestView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var title = ""
    @State private var amount = ""
    @State private var details = ""
    @State private var message = ""

    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount).keyboardType(.decimalPad)
                TextField("Details", text: $details)
                Button("Submit Request") {
                    submit()
                }
            }
            Spacer()
            NavigationLink(destination: ApproverView()) {
                Text("Approvals (Checker)")
            }
            .padding()
        }
        .navigationTitle("Expense Request")
    }

    func submit() {
        guard let amt = Double(amount), !title.isEmpty else { return }
        var req = ExpenseRequest(title: title, amount: amt, details: details, requestedBy: auth.currentUserEmail ?? "unknown")
        // save to persistence
        var storage = PersistenceService.shared.load()
        var requests = storage?.expenseRequests ?? []
        requests.append(req)
        let families = storage?.families ?? []
        PersistenceService.shared.save(families: families, requests: requests)
        message = "Request submitted"
        title = ""; amount = ""; details = ""
    }
}
