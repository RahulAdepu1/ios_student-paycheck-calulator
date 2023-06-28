//
//  studPaycheckCalApp.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI
import Firebase

@main
struct studPaycheckCalApp: App {
    
    @StateObject var effectiveTaxCalculator:EffectiveTaxCalculator = EffectiveTaxCalculator()
    @StateObject var studentPaycheckCalculatorVM: StudentPaycheckCalculatorVM = StudentPaycheckCalculatorVM()
    @StateObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM = StudentPaycheckCoreDataVM()
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                IntroView()
            }
            .environmentObject(studentPaycheckCalculatorVM)
            .environmentObject(studentPaycheckCoreDataVM)
            .environmentObject(effectiveTaxCalculator)
            .environmentObject(authViewModel)
        }
    }
}
