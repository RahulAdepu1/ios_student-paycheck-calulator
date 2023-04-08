//
//  studPaycheckCalApp.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

@main
struct studPaycheckCalApp: App {
    
    @StateObject var studentPaycheckCalculatorVM: StudentPaycheckCalculatorVM = StudentPaycheckCalculatorVM()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                SelfCheckView()
            }
            .environmentObject(studentPaycheckCalculatorVM)
        }
    }
}
