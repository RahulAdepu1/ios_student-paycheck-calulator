//
//  MainView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    // App Storage
    @AppStorage("signed_in") var userSignedIn: Bool = false
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("state") var selectedState: String?
    @AppStorage("maritalStatus") var selectedMaritalStatus: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    @State var selectionTab: TabBarItem = .income
    var body: some View {
        CustomTabBarContainerView(selection: $selectionTab) {
            TaxCalculatorView()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .taxCal, selectoin: $selectionTab)
            SelfCheckView2()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .paycheck, selectoin: $selectionTab)
            IncomeCalculatorView()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .income, selectoin: $selectionTab)
            HistoryView()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .favorites, selectoin: $selectionTab)
            ProfileView()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .profile, selectoin: $selectionTab)
        }
        .onAppear {
            studentPaycheckCalVM.selectedCountry = selectedCountry ?? ""
            studentPaycheckCalVM.selectedState = selectedState ?? ""
            studentPaycheckCalVM.selectedMaritalStatus = selectedMaritalStatus ?? ""
            studentPaycheckCalVM.selectedW4 = selectedW4Filled ?? ""
            createAnEmptyData()
        }
    }
    
    func createAnEmptyData() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        if studentPaycheckCoreDataVM.studentHistoryCoreData.isEmpty {
            for month in 1...12 {
                let dateComponents = DateComponents(year: year, month: month, day: 1)
                if let date = calendar.date(from: dateComponents) {
                    studentPaycheckCoreDataVM.addHistory(date: date,
                                                         federalTax: 0.0,
                                                         stateTax: 0.0,
                                                         salaryAfterTax: 0.0)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
        .environmentObject(AuthViewModel())
    }
}
