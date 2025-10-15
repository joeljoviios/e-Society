import SwiftUI

struct PaymentsView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var paymentsVM: PaymentsViewModel

    @State private var selectedFamily: UUID?
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var monthYear = ""

    var body: some View {
        Form {
            Section(header: Text("Select Family")) {
                Picker("Family", selection: $selectedFamily) {
                    ForEach(familiesVM.families) { f in
                        Text("\(f.name) - \(f.apartmentNo)").tag(f.id as UUID?)
                    }
                }
            }

            Section(header: Text("Payment")) {
                TextField("Amount", text: $amount).keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("MonthYear (e.g. 2025-10)", text: $monthYear)
            }

            Button("Record Payment") {
                guard let famId = selectedFamily, let amt = Double(amount) else { return }
                paymentsVM.recordPayment(familyId: famId, amount: amt, date: date, monthYear: monthYear)
            }
        }
        .navigationTitle("Record Payment")
    }
}
