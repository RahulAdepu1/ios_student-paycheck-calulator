//
//  SelfCheckView2.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView2: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @State private var showPayPeriodPicker:Bool = false
    @State private var showPayRateAmountPicker:Bool = false
    @State private var showHoursPicker:Bool = false
    @State private var showSalaryTypePicker:Bool = false
    
    var body: some View {
        VStack {
            Text("STEP 2/2")
                .font(.largeTitle)
                .padding(.bottom, 100)
            Text("Make a choice for all the options \nto move to next page")
                .multilineTextAlignment(.center)
                .padding(10)
            VStack {
                HStack {
                    VStack {
                        Text("Pay Period")
                            .modifier(CustomTextDesign())
                        Button {
                            showPayPeriodPicker = true
                        } label: {
                            Text(studentPaycheckCalVM.selectedPayPeriod)
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
                            Text(studentPaycheckCalVM.selectedPayRateAmount)
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
                            Text(studentPaycheckCalVM.selectedHours == "Choose One" ? studentPaycheckCalVM.selectedHours : "\(studentPaycheckCalVM.selectedHours)h")
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
                            Text(studentPaycheckCalVM.selectedSalaryType)
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
            .disabled(!studentPaycheckCalVM.canNavToSelfCheckResult)
            
        }
        .sheet(isPresented: $showPayPeriodPicker) {
            PayPeriodSelectPicker()
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showPayRateAmountPicker) {
            PayRateAmountSelectPicker()
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showHoursPicker) {
            HoursSelectPicker()
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showSalaryTypePicker) {
            SalarySelectPicker()
                .presentationDetents([.height(200)])
        }
        
    }
}


//MARK: - Picker Views
struct PayPeriodSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack{
            Text(studentPaycheckCalVM.selectedPayPeriod)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedPayPeriod) {
                ForEach(PayPeriod.payPeriodList){ payPeriod in
                    Text(payPeriod.payPeriod).tag(payPeriod.payPeriod)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct PayRateAmountSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @State var selectedDollars = 0
    @State var selectedCents = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text("$\(selectedDollars).\(selectedCents)")
                .font(.title)
                .padding(.top, 20)
            HStack {
                Picker("", selection: $selectedDollars) {
                    ForEach(6..<61) { number in
                        Text(String(format: "%02d", number))
                            .tag(number)
                    }
                }
                .frame(width: 100, height: 150)
                .pickerStyle(WheelPickerStyle())
                
                Picker("", selection: $selectedCents) {
                    ForEach(0..<100) {number in
                        Text(String(format: "%02d", number))
                            .tag(number)
                    }
                }
                .frame(width: 100, height: 150)
                .pickerStyle(WheelPickerStyle())
            }
        }
        .onChange(of: selectedDollars) { _ in
            studentPaycheckCalVM.selectedPayRateAmount = "$\(selectedDollars).\(selectedCents)"
        }
        .onChange(of: selectedCents) { _ in
            studentPaycheckCalVM.selectedPayRateAmount = "$\(selectedDollars).\(selectedCents)"
        }
    }
}


struct HoursSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    let hoursList = Array(stride(from: 1, through: 60, by: 1))
    let minutesList = Array(0 ..< 60)
    
    var body: some View{
        VStack{
            Text(studentPaycheckCalVM.selectedHours == "Choose One" ? studentPaycheckCalVM.selectedHours : "\(studentPaycheckCalVM.selectedHours)h")
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedHours) {
                ForEach(hoursList, id:\.self){ hour in
                    Text("\(hour)").tag("\(hour)")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct SalarySelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack{
            Text(studentPaycheckCalVM.selectedSalaryType)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedSalaryType) {
                ForEach(SalaryType.salaryTypeList){ salaryType in
                    Text(salaryType.salaryType).tag(salaryType.salaryType)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

//MARK: - Preview
struct SelfCheckView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SelfCheckView2()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
    }
}
