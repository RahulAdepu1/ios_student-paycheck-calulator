//
//  SelfCheckViewResult.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import SwiftUI

struct SelfCheckViewResult: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showYearPicker:Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Compare your salary in previous years")
            Menu {
                Picker(selection: $studentPaycheckCalVM.selectedYear) {
                    ForEach(Year.yearList) { year in
                        Text(year.year).tag(year.year)
                    }
                } label: {
                }
            } label: {
                Text(studentPaycheckCalVM.selectedYear)
                    .foregroundColor(.black)
                    .frame(width: 100)
                    .modifier(CustomBlockDesign())
            }
            .padding(.bottom, 75)
            
            VStack {
                HStack{
                    Text("Salary Before Tax")
                    Spacer()
                    Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryBeforeTax()))
                }
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("Federal Tax")
                    Spacer()
                    Text(String(format: "$%.2f", studentPaycheckCalVM.FederalTax()))
                }
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("State Tax")
                    Spacer()
                    Text(String(format: "$%.2f", studentPaycheckCalVM.StateTax()))
                }
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 30)
                HStack{
                    Text("Salary After Tax")
                    Spacer()
                    Text(String(format: "$%.2f", studentPaycheckCalVM.SalaryAfterTax()))
                }
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 50)
            
            Button {
                showAlert = true
            } label: {
                Text("Save")
                    .modifier(CustomActionButtonDesign())
            }
        }
        .sheet(isPresented: $showAlert, onDismiss: {
            studentPaycheckCalVM.selectedPayPeriod = "Choose One"
            studentPaycheckCalVM.selectedPayRateAmount = ""
            studentPaycheckCalVM.selectedHours = "0"
            studentPaycheckCalVM.selectedMinutes = "0"
            studentPaycheckCalVM.selectedSalaryType = "Choose One"
            dismiss()
        }) {
            ChooseDateView(showAlert: $showAlert)
                .presentationDetents([.height(350)])
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

struct ChooseDateView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    @Binding var showAlert: Bool
    var body: some View{
        VStack{
            Text("When did you receive this paycheck")
                .font(.headline)
            HStack{
                Spacer()
                DatePicker("", selection: $studentPaycheckCalVM.selectedPaymentDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                Spacer()
            }
            Button("Done") {
                /*
                 Check if the year entered by the user is a New Year Value which was not in the list or is it the same year which is already present in the Core Data
                 */
                print("Done button pressed")
                let year = Calendar.current.component(.year, from: studentPaycheckCalVM.selectedPaymentDate)
                let isYearPresentPaycheck = studentPaycheckCoreDataVM.studentPayCheckCoreData.contains(where: {
                    Calendar.current.component(.year, from: $0.unwrappedDate) ==  year})
                
                print("Year = \(year)")
                print("is Year Present Paycheck \(isYearPresentPaycheck.description)")
                // Save Data to Paycheck Core Data
//                studentPaycheckCalVM.SaveToCoreData()
                
                if !isYearPresentPaycheck {
                    for month in 1...12 {
                        let dateComponents = DateComponents(year: year, month: month, day: 1)
                        if let date = Calendar.current.date(from: dateComponents) {
                            studentPaycheckCalVM.SaveToCoreData(date: date)
                        }
                    }
                    print("Self Check View Result -> Created dummy Data")
                }
                
                // Save data to Paycheck Core Data
                studentPaycheckCalVM.SaveToCoreData(date: studentPaycheckCalVM.selectedPaymentDate,
                                                    federalTax: studentPaycheckCalVM.FederalTax(),
                                                    stateTax: studentPaycheckCalVM.StateTax(),
                                                    salaryAfterTax: studentPaycheckCalVM.SalaryBeforeTax())
                
                print("Data Saved")
                showAlert = false
            }
            .modifier(CustomActionButtonDesign())
        }
    }
}
