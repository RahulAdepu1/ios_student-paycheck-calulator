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
            VStack {
                HStack{
                    Text("Salary Before Tax")
                    Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryBeforeTax()))
                }
                .modifier(CustomActionButtonDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("Fedeeral Tax")
                    Text(String(format: "$%.2f", studentPaycheckCalVM.FederalTax()))
                }
                .modifier(CustomActionButtonDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("State Tax")
                    Text(String(format: "$%.2f", studentPaycheckCalVM.StateTax()))
                }
                .modifier(CustomActionButtonDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("Salary After Tax")
                    Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryAfterTax()))
                }
                .modifier(CustomActionButtonDesign())
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 50)
            
            Button {
//                studentPaycheckCalVM.SaveToCoreData()
                print("Data Saved")
            } label: {
                Text("Save")
                    .modifier(CustomActionButtonDesign())
            }

            Button {
                MainView()
            } label: {
                Text("Start Over")
                    .modifier(CustomActionButtonDesign())
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
        .environmentObject(StudentPaycheckCoreDataVM())
    }
}
