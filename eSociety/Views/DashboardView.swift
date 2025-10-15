import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var paymentsVM: PaymentsViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome").font(.subheadline).foregroundColor(.secondary)
                            Text(auth.currentUserEmail ?? "User").font(.headline)
                        }
                        Spacer()
                        Button(action: {
                            auth.logout()
                        }) {
                            Text("Logout").foregroundColor(.primary)
                                .padding(8).background(Color.white).cornerRadius(8)
                        }
                    }
                    .padding()

                    // Summary cards
                    HStack(spacing: 12) {
                        SummaryCard(title: "Expected", value: "₹10,000")
                        SummaryCard(title: "Collected", value: "₹7,400")
                    }
                    .padding(.horizontal)

                    // Quick links
                    VStack(spacing: 12) {
                        NavigationLink(destination: FamiliesListView()) {
                            QuickRow(title: "Families", subtitle: "Manage residents & payments")
                        }
                        NavigationLink(destination: PaymentsView()) {
                            QuickRow(title: "Record Payment", subtitle: "Quickly add maintenance payment")
                        }
                        NavigationLink(destination: ExpenseRequestView()) {
                            QuickRow(title: "Expense Requests", subtitle: "Maker-Checker flow")
                        }
                        NavigationLink(destination: ReportsView()) {
                            QuickRow(title: "Reports", subtitle: "Inward & Defaulters reports")
                        }
                    }
                    .padding()

                    Spacer()
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct SummaryCard: View {
    var title: String
    var value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.white.opacity(0.9))
            Text(value).font(.title2).bold().foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(LinearGradient.primary)
        .cornerRadius(12)
    }
}

struct QuickRow: View {
    var title: String
    var subtitle: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
