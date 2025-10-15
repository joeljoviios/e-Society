import SwiftUI

struct FamilyDetailView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    var family: Family

    var body: some View {
        VStack(spacing: 12) {
            Text(family.name).font(.title2).bold()
            Text("Apt: \(family.apartmentNo)").foregroundColor(.secondary)
            List {
                Section(header: Text("Payments")) {
                    ForEach(family.payments) { p in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("₹\(Int(p.amount))")
                                Text(p.monthYear).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            if p.lateFee > 0 {
                                Text("Late ₹\(Int(p.lateFee))").foregroundColor(.red).font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Family")
    }
}
