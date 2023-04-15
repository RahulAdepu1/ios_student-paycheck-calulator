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
            Text(studentPaycheckCalVM.selectedCountry)
            Text(studentPaycheckCalVM.selectedState)
            Text(studentPaycheckCalVM.selectedW4)
            Text(studentPaycheckCalVM.selectedMaritalStatus)
            Text(studentPaycheckCalVM.selectedPayPeriod)
            Text(studentPaycheckCalVM.selectedPayRateAmount)
            Text(studentPaycheckCalVM.selectedHours)
            Text(studentPaycheckCalVM.selectedSalaryType)
            HStack{
                Text("Salary Before Tax")
                Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryBeforeTax()))
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
