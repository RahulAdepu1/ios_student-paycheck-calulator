//
//  SelfCheckViewResult.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import SwiftUI

struct SelfCheckViewResult: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View {
        VStack {
            HStack{
                Text("Salary Before Tax")
                Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryBeforeTax()))
            }
            HStack{
                Text("Fedeeral Tax")
                Text(String(format: "$%.2f", studentPaycheckCalVM.FederalTax()))
            }
            HStack{
                Text("State Tax")
                Text(String(format: "$%.2f", studentPaycheckCalVM.StateTax()))
            }
            HStack{
                Text("Salary After Tax")
                Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryAfterTax()))
            }
        }
    }
}

struct SelfCheckViewResult_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SelfCheckViewResult()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
    }
}
