//
//  SelfCheckView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @State private var showContryPicker: Bool = false
    @State private var showStatePicker: Bool = false
    @State private var showW4Picker: Bool = false
    @State private var showMaritalStatusPicker: Bool = false
    
    @State private var isAlert: Bool = true
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("STEP 1/2")
                    .font(.largeTitle)
                    .padding(.bottom, 100)
                Text("Make a choice for all the options \nto move to next page")
                    .multilineTextAlignment(.center)
                    .padding(10)
                
                VStack {
                    HStack {
                        VStack {
                            Text("Nationality")
                                .modifier(CustomTextDesign())
                            Button {
                                showContryPicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedCountry)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .modifier(CustomBlockDesign())
                        
                        
                        VStack {
                            Text("State")
                                .modifier(CustomTextDesign())
                            Button {
                                showStatePicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedState)
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
                            Text("W4?")
                                .modifier(CustomTextDesign())
                            Button {
                                showW4Picker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedW4)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        VStack {
                            Text("Marital Status")
                                .modifier(CustomTextDesign())
                            Button {
                                showMaritalStatusPicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedMaritalStatus)
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
                
                NavigationLink {
                    SelfCheckView2()
                } label: {
                    Text("Next")
                        .modifier(CustomActionButtonDesign())
                }
                .disabled(!studentPaycheckCalVM.canNavToSelfCheck2)
                
            }
            .sheet(isPresented: $showContryPicker) {
                NationalitySelectPicker()
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showStatePicker) {
                StateSelectPicker()
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showW4Picker) {
                W4SelectPicker()
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showMaritalStatusPicker) {
                MaritalStatusSelectPicker()
                    .presentationDetents([.height(200)])
            }
        }
    }
}


//MARK: - Picker Views
struct NationalitySelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack(spacing: 0){
            Text(studentPaycheckCalVM.selectedCountry)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedCountry) {
                ForEach(CountryNames.countriesList){ country in
                    Text(country.name).tag(country.name)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct StateSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack(spacing: 0){
            Text(studentPaycheckCalVM.selectedState)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedState) {
                ForEach(StateNames.statesList){ state in
                    Text(state.stateName).tag(state.stateName)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct W4SelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack(spacing: 0){
            Text(studentPaycheckCalVM.selectedW4)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedW4) {
                ForEach(W4Filled.w4FilledList){ options in
                    Text(options.option).tag(options.option)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct MaritalStatusSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    var body: some View{
        VStack(spacing: 0){
            Text(studentPaycheckCalVM.selectedMaritalStatus)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $studentPaycheckCalVM.selectedMaritalStatus) {
                ForEach(MaritalStatus.maritalStatusList){ maritalStatus in
                    Text(maritalStatus.maritalStatus).tag(maritalStatus.maritalStatus)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

//MARK: - Preview
struct SelfCheckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SelfCheckView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
    }
}
