//
//  SelfCheckView2.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView2: View {
    
    @State private var showPayPeriodPicker:Bool = false
    @State private var showPayRateAmountPicker:Bool = false
    @State private var showHoursPicker:Bool = false
    @State private var showSalaryTypePicker:Bool = false
    
    @State private var selectedPayPeriod: String = "Choose One"
    @State private var selectedPayRateAmount: String = "Choose One"
    @State private var selectedHours: String = "Choose One"
    @State private var selectedSalaryType: String = "Choose One"
    
    var body: some View {
        VStack {
            Text("STEP 2/2")
                .font(.largeTitle)
                .padding(.bottom, 100)
            if selectedPayPeriod == "Choose One"
            || selectedPayRateAmount == "Choose One"
            || selectedHours == "Choose One"
            || selectedSalaryType == "Choose One"{
                Text("Make a choice for all the options \nto move to next page")
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            VStack {
                HStack {
                    VStack {
                        Text("Pay Period")
                            .modifier(CustomTextDesign())
                        Button {
                            showPayPeriodPicker = true
                        } label: {
                            Text(selectedPayPeriod)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .modifier(CustomBlockDesign())
                    
                    
                    VStack {
                        Text("Pay Rate Amount")
                            .modifier(CustomTextDesign())
                        Button {
                            showPayRateAmountPicker = true
                        } label: {
                            Text(selectedPayRateAmount)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                HStack{
                    VStack {
                        Text("Hours")
                            .modifier(CustomTextDesign())
                        Button {
                            showHoursPicker = true
                        } label: {
                            Text(selectedHours)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    VStack {
                        Text("Salary Type")
                            .modifier(CustomTextDesign())
                        Button {
                            showSalaryTypePicker = true
                        } label: {
                            Text(selectedSalaryType)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
            }
            .modifier(CustomBlockDesign())
            
            .padding(.bottom, 50)
            Button {
                print("")
            } label: {
                Text("Next")
                    .modifier(CustomActionButtonDesign())
            }
            .disabled((selectedPayPeriod == "Choose One" || selectedPayRateAmount == "Choose One"
                        || selectedHours == "Choose One" || selectedSalaryType == "Choose One" ))
            
        }
        .sheet(isPresented: $showPayPeriodPicker) {
            PayPeriodSelectPicker(selectedPayPeriod: $selectedPayPeriod)
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showPayRateAmountPicker) {
            PayRateAmountSelectPicker(selectedPayRateAmount: $selectedPayRateAmount)
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showHoursPicker) {
            HoursSelectPicker(selectedHours: $selectedHours)
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showSalaryTypePicker) {
            SalarySelectPicker(selectedSalaryType: $selectedSalaryType)
                .presentationDetents([.height(200)])
        }
        
    }
}


//MARK: - Picker Views
struct PayPeriodSelectPicker: View {
    @Binding var selectedPayPeriod: String
    
    var body: some View{
        VStack{
            Text(selectedPayPeriod)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedPayPeriod) {
                ForEach(PayPeriod.payPeriodList){ payPeriod in
                    Text(payPeriod.payPeriod).tag(payPeriod.payPeriod)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct PayRateAmountSelectPicker: View {
    @Binding var selectedPayRateAmount: String
    
    var body: some View{
        VStack{
            Text(selectedPayRateAmount)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedPayRateAmount) {
                ForEach(PayRateAmount.payPeriodAmountList){ payRateAmount in
                    Text("\(payRateAmount.payRateAmount)").tag("\(payRateAmount.payRateAmount)")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct HoursSelectPicker: View {
    @Binding var selectedHours: String
    let hoursList = Array(stride(from: 0, through: 60, by: 1))
    let minutesList = Array(0 ..< 60)
    
    var body: some View{
        VStack{
            Text(selectedHours)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedHours) {
                ForEach(hoursList, id:\.self){ hour in
                    Text("\(hour)").tag("\(hour)")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct SalarySelectPicker: View {
    @Binding var selectedSalaryType: String
    
    var body: some View{
        VStack{
            Text(selectedSalaryType)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedSalaryType) {
                ForEach(SalaryType.salaryTypeList){ salaryType in
                    Text(salaryType.salaryType).tag(salaryType.salaryType)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

// MARK: - SecondView Data Source
struct PayPeriod: Identifiable {
    let id = UUID().uuidString
    let payPeriod: String
    
    static let payPeriodList = [
        PayPeriod(payPeriod: "Choose One"),
        PayPeriod(payPeriod: "Weekly"),
        PayPeriod(payPeriod: "Bi-Weekly"),
        PayPeriod(payPeriod: "Bi-Monthly"),
        PayPeriod(payPeriod: "Monthly")
    ]
}

struct PayRateAmount: Identifiable {
    let id = UUID().uuidString
    let payRateAmount: Int
    
    static let payPeriodAmountList = [
        PayRateAmount(payRateAmount: 1),
        PayRateAmount(payRateAmount: 1),
        PayRateAmount(payRateAmount: 2)
    ]
}

struct SalaryType: Identifiable  {
    let id = UUID().uuidString
    let salaryType: String
    
    static let salaryTypeList = [
        SalaryType(salaryType: "Choose One"),
        SalaryType(salaryType: "Hourly"),
        SalaryType(salaryType: "Monthly")
    ]
}

struct AnnualizedRate: Identifiable  {
    let id = UUID().uuidString
    let payRate: String
    let payRateMulti: Int
    
    static let annualizedRateList = [
        AnnualizedRate(payRate: "Choose One", payRateMulti: 0),
        AnnualizedRate(payRate: "Weekly", payRateMulti: 52),
        AnnualizedRate(payRate: "Bi-Weekly", payRateMulti: 26),
        AnnualizedRate(payRate: "Bi-Monthly", payRateMulti: 24),
        AnnualizedRate(payRate: "Monthly", payRateMulti: 12)
    ]
}

//MARK: - Preview
struct SelfCheckView2_Previews: PreviewProvider {
    static var previews: some View {
        SelfCheckView2()
    }
}
