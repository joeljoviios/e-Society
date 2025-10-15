/* import SwiftUI

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
            .navigationTitle("My Home Society")
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

*/

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var paymentsVM: PaymentsViewModel
    @State private var showEmailSent = false

    let monthlyRent: Double = 10000
    let monthlyMaintenance: Double = 3000

    var today: Date { Date() }
    var calendar: Calendar { Calendar.current }

    var isCurrentDateWithinReminderPeriod: Bool {
        let day = calendar.component(.day, from: today)
        return (5...10).contains(day)
    }
    func currentMonthString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        return fmt.string(from: today)
    }
    var defaultersThisMonth: [Family] {
        let month = currentMonthString()
        return familiesVM.families.filter { family in
            !family.payments.contains(where: { $0.monthYear == month && $0.amount > 0 })
        }
    }
    func sendPaymentReminders() {
        showEmailSent = true
        // Integrate email logic here
    }
    var totalExpected: Double {
        let count = familiesVM.families.count
        return Double(count) * (monthlyRent + monthlyMaintenance)
    }
    var totalCollected: Double { paymentsVM.payments.reduce(0) { $0 + $1.amount } }
    var paidFamiliesCount: Int { familiesVM.families.filter { family in family.payments.contains(where: { $0.amount > 0 }) }.count }
    var delayedPaymentsCount: Int { paymentsVM.payments.filter { $0.lateFee > 0 }.count }
    var totalLateFees: Double { Double(delayedPaymentsCount) * 100 }
    var summaryCards: [SummaryCardModel] {
        [
            SummaryCardModel(title: "Expected", value: "₹\(Int(totalExpected))"),
            SummaryCardModel(title: "Collected", value: "₹\(Int(totalCollected))"),
            SummaryCardModel(title: "Paid Families", value: "\(paidFamiliesCount)"),
            SummaryCardModel(title: "Defaulters", value: "\(familiesVM.families.count - paidFamiliesCount)"),
            SummaryCardModel(title: "Late Fees", value: "₹\(Int(totalLateFees))")
        ]
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 6) {
                            Text("Welcome")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(auth.currentUserEmail ?? "User")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)

                        if isCurrentDateWithinReminderPeriod && !defaultersThisMonth.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reminder: Some families have not paid this month's maintenance.")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                ForEach(defaultersThisMonth) { family in
                                    Text("- \(family.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                Button(action: sendPaymentReminders) {
                                    Text("Email Reminder")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .cornerRadius(10)
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(summaryCards, id: \.title) { card in
                                    SummaryCard(title: card.title, value: card.value)
                                        .frame(width: 160, height: 90)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        }

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
                    }
                }
                Button(action: { auth.logout() }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
            }
            .navigationBarTitle("My Home Society", displayMode: .inline)
            .alert(isPresented: $showEmailSent) {
                Alert(
                    title: Text("Email Reminder Sent"),
                    message: Text("Reminder email has been triggered for all defaulter families."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct SummaryCardModel {
    var title: String
    var value: String
}

struct SummaryCard: View {
    var title: String
    var value: String
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)     // Ensures larger numbers shrink to fit on one line
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(width: 160, height: 90)    // Increased card width for large values
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
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
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}
