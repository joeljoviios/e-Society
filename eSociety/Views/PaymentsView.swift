import SwiftUI

struct PaymentsView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var paymentsVM: PaymentsViewModel

    @State private var selectedFamily: UUID?
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var monthYear = ""
    @State private var showSuccess = false
    
    func clearFields() {
        amount = ""
        selectedFamily = nil
        monthYear = ""
        date = Date()
    }

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
                TextField("Description (e.g. Rent, Maintainance)", text: $monthYear)
            }

            Button("Record Payment") {
                guard let famId = selectedFamily, let amt = Double(amount) else { return }
                paymentsVM.recordPayment(familyId: famId, amount: amt, date: date, monthYear: monthYear)
                showSuccess = true
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Success"),
                    message: Text("Payment recorded successfully!"),
                    dismissButton: .default(Text("OK"), action: {
                        clearFields()
                    })
                )
            }
        }
        .navigationTitle("Record Payment")
    }
}
