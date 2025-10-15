//
//  eSocietyApp.swift
//  eSociety
//
//  Created by Joel on 13/10/25.
//

import SwiftUI

@main
struct eSocietyApp: App {
    @StateObject var auth = AuthViewModel()
    @StateObject var familiesVM = FamiliesViewModel()
    @StateObject var paymentsVM = PaymentsViewModel(familiesVM: nil) // will set after init

    init() {
        // After initialization, set cross references
        // Note: simple hack because SwiftUI requires @StateObject init here
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
                .environmentObject(familiesVM)
                .environmentObject(paymentsVM)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @EnvironmentObject var paymentsVM: PaymentsViewModel

    var body: some View {
        Group {
            if auth.isLoggedIn {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            PersistenceService.shared.seedIfNeeded()
            familiesVM.load()
            paymentsVM.familiesVM = familiesVM
            paymentsVM.load()
        }
    }
}
