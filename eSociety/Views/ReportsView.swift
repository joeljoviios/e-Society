import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel

    var body: some View {
        List {
            Section(header: Text("Defaulters (current month)")) {
                let month = currentMonthYear()
                ForEach(familiesVM.defaulters(for: month)) { f in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(f.name)
                            Text(f.apartmentNo).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("Defaulter").foregroundColor(.red).font(.caption)
                    }
                }
            }

            Section(header: Text("Quick Stats")) {
                Text("Total Families: \(familiesVM.families.count)")
            }
        }
        .navigationTitle("Reports")
    }

    func currentMonthYear() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        return fmt.string(from: Date())
    }
}
