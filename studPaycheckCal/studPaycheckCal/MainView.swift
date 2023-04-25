//
//  MainView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    // App Storage
    @AppStorage("signed_in") var userSignedIn: Bool = false
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("state") var selectedState: String?
    @AppStorage("maritalStatus") var selectedMaritalStatus: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    @State var selectionTab: TabBarItem = .paycheck
    var body: some View {
        CustomTabBarContainerView(selection: $selectionTab) {
            SelfCheckView2()
                .frame(maxHeight: .infinity)
                .tabBarItem(tab: .paycheck, selectoin: $selectionTab)
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
    }
}
