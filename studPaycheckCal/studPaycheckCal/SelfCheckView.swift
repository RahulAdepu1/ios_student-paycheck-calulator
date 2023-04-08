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
    
    @State private var selectedCountry: String = "Choose One"
    @State private var selectedState: String = "Choose One"
    @State private var selectedW4: String = "Choose One"
    @State private var selectedMaritalStatus: String = "Choose One"
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("STEP 1/2")
                    .font(.largeTitle)
                    .padding(.bottom, 100)
                if selectedCountry == "Choose One"
                || selectedState == "Choose One"
                || selectedW4 == "Choose One"
                || selectedMaritalStatus == "Choose One"{
                    Text("Make a choice for all the options \nto move to next page")
                        .multilineTextAlignment(.center)
                        .padding(10)
                }
                
                VStack {
                    HStack {
                        VStack {
                            Text("Nationality")
                                .modifier(CustomTextDesign())
                            Button {
                                showContryPicker = true
                            } label: {
                                Text(selectedCountry)
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
                                Text(selectedState)
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
                                Text(selectedW4)
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
                                Text(selectedMaritalStatus)
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
                .disabled((selectedCountry == "Choose One" || selectedState == "Choose One"
                          || selectedW4 == "Choose One" || selectedMaritalStatus == "Choose One" ))
                
            }
            .sheet(isPresented: $showContryPicker) {
                NationalitySelectPicker(selectedCountry: $selectedCountry)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showStatePicker) {
                StateSelectPicker(selectedState: $selectedState)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showW4Picker) {
                W4SelectPicker(selectedW4: $selectedW4)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showMaritalStatusPicker) {
                MaritalStatusSelectPicker(selectedMaritalStatus: $selectedMaritalStatus)
                    .presentationDetents([.height(200)])
            }
        }
        
    }
}


//MARK: - Picker Views
struct NationalitySelectPicker: View {
    @Binding var selectedCountry: String
    
    var body: some View{
        VStack(spacing: 0){
            Text(selectedCountry)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedCountry) {
                ForEach(CountryNames.countriesList){ country in
                    Text(country.name).tag(country.name)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct StateSelectPicker: View {
    @Binding var selectedState: String
    
    var body: some View{
        VStack(spacing: 0){
            Text(selectedState)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedState) {
                ForEach(StateNames.statesList){ state in
                    Text(state.stateName).tag(state.stateName)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct W4SelectPicker: View {
    @Binding var selectedW4: String
    
    var body: some View{
        VStack(spacing: 0){
            Text(selectedW4)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedW4) {
                ForEach(W4Filled.w4FilledList){ options in
                    Text(options.option).tag(options.option)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct MaritalStatusSelectPicker: View {
    @Binding var selectedMaritalStatus: String
    
    var body: some View{
        VStack(spacing: 0){
            Text(selectedMaritalStatus)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $selectedMaritalStatus) {
                ForEach(MaritalStatus.maritalStatusList){ maritalStatus in
                    Text(maritalStatus.maritalStatus).tag(maritalStatus.maritalStatus)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

//MARK: - Custom Design
struct CustomTextDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 50)
            .background(Color.white)
    }
}

struct CustomChoiceButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .frame(width: 120, height: 50)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct CustomActionButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 30)
    }
}

struct CustomBlockDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
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
