//
//  studPaycheckCalApp.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

@main
struct studPaycheckCalApp: App {
    
//    @StateObject var studentPaycheckCalculatorVM: StudentPaycheckCalculatorVM = StudentPaycheckCalculatorVM()
//    @StateObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM = StudentPaycheckCoreDataVM()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                FirstView()
            }
//            .environmentObject(studentPaycheckCalculatorVM)
//            .environmentObject(studentPaycheckCoreDataVM)
        }
    }
}
