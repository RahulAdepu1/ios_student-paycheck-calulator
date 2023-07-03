//
//  MainView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //User Manager
    @StateObject private var userManager = UserManager()
    
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
            if let user = authViewModel.currentUser {
                Task{
                    let paycheckCloudData = try await userManager.loadPaycheckData(userID: user.id)
                    
                    //
                    if !paycheckCloudData.isEmpty && !studentPaycheckCoreDataVM.studentPayCheckCoreData.isEmpty {
                        print("Paycheck Cloud is NOT EMPTY and Paycheck Core Data is NOT EMPTY")
                        if paycheckCloudData.count > studentPaycheckCoreDataVM.studentPayCheckCoreData.count {
                            print("Payheck Cloud data is not than Payheck Core Data")
                            print("Cloud Data count ->\(paycheckCloudData.count)")
                            print("Core Data count ->\(studentPaycheckCoreDataVM.studentPayCheckCoreData.count)")
                            loadPaycheckCoreData(paycheckCloudData: paycheckCloudData,
                                                 paycheck: studentPaycheckCoreDataVM.studentPayCheckCoreData)
                        }
                        //
                    } else if !paycheckCloudData.isEmpty && studentPaycheckCoreDataVM.studentPayCheckCoreData.isEmpty {
                        print("Paycheck Cloud is NOT EMPTY and Paycheck Core Data is EMPTY")
                        loadPaycheckCoreData(paycheckCloudData: paycheckCloudData,
                                             paycheck: studentPaycheckCoreDataVM.studentPayCheckCoreData)
                    }else if paycheckCloudData.isEmpty && studentPaycheckCoreDataVM.studentPayCheckCoreData.isEmpty {
                        print("Paycheck Cloud is EMPTY and Paycheck Core Data is EMPTY")
                        createAnEmptyData()
                    }
                }
            }
        }
    }
    
    func createAnEmptyData() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        print("Year is \(year)")
        if studentPaycheckCoreDataVM.studentPayCheckCoreData.isEmpty {
            for month in 1...12 {
                let dateComponents = DateComponents(year: year, month: month, day: 1)
                if let date = Calendar.current.date(from: dateComponents) {
                    studentPaycheckCalVM.SaveToCoreData(date: date)
                }
            }
            print("Main View -> Created dummy Data")
        }
    }
    
    func loadPaycheckCoreData(paycheckCloudData: [UserPaycheckData], paycheck: [Paycheck]) {
        
        print("Cloud Data count ->\(paycheckCloudData.count)")
        print("Core Data count ->\(paycheck.count)")
        for data in paycheckCloudData {
            studentPaycheckCoreDataVM.addPaycheck(id: data.id,
                                                  date: data.date,
                                                  country: data.country,
                                                  state: data.state,
                                                  maritalStatus: data.maritalStatus,
                                                  payPeriod: data.payPeriod,
                                                  payRateAmount: data.payRateAmount,
                                                  salaryType: data.salaryType,
                                                  w4: data.w4,
                                                  hours: data.hours, minutes: data.minutes,
                                                  federalTax: data.federalTax,
                                                  stateTax: data.stateTax,
                                                  salaryAfterTax: data.salaryAfterTax)
        }
        print("Cloud Data count ->\(paycheckCloudData.count)")
        print("Core Data count ->\(paycheck.count)")
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
