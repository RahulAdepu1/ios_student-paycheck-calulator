//
//  SelfCheckView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView: View {
    
    @State private var showContryPicker:Bool = false
    @State private var showStatePicker:Bool = false
    @State private var showW4Picker:Bool = false
    @State private var showMaritalStatusPicker:Bool = false
    
    @State private var selectedCountry: String = "Choose One"
    @State private var selectedState: String = "Choose One"
    @State private var selectedW4: String = "Choose One"
    @State private var selectedMaritalStatus: String = "Choose One"
    
    var body: some View {
        VStack {
            Text("STEP 1/2")
                .font(.largeTitle)
                .padding(.bottom, 100)
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
            Button {
                print("")
            } label: {
                Text("Next")
                    .modifier(CustomActionButtonDesign())
            }
            
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


//MARK: - Picker Views
struct NationalitySelectPicker: View {
    @Binding var selectedCountry: String
    
    var body: some View{
        VStack{
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
        VStack{
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
        VStack{
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
        VStack{
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

//MARK: - Data Model
struct W4Filled: Identifiable {
    let id = UUID().uuidString
    let option: String
    
    static let w4FilledList = [
        W4Filled(option: "Choose One"),
        W4Filled(option: "No"),
        W4Filled(option: "Yes")
    ]
    
}

struct CountryNames: Identifiable {
    let id = UUID().uuidString
    let name: String
    
    static let countriesList = [
        CountryNames(name: "Choose One"),
        CountryNames(name: "India"),
        CountryNames(name: "Usa")
    ]
}

struct StateNames: Identifiable {
    let id = UUID().uuidString
    let stateName: String
    
    static let statesList = [
        StateNames(stateName: "Choose One"),
        //        State(stateName: "Alabama"),
        //        State(stateName: "Alaska"),
        //        State(stateName: "Arizona"),
        //        State(stateName: "Arkansas"),
        //        State(stateName: "California"),
        //        State(stateName: "Colorado"),
        //        State(stateName: "Connecticut"),
        //        State(stateName: "Delaware"),
        //        State(stateName: "Florida"),
        //        State(stateName: "Georgia"),
        //        State(stateName: "Hawaii"),
        //        State(stateName: "Idaho"),
        StateNames(stateName: "Illinois")
        //        State(stateName: "Indiana"),
        //        State(stateName: "Iowa"),
        //        State(stateName: "Kansas"),
        //        State(stateName: "Kentucky"),
        //        State(stateName: "Louisiana"),
        //        State(stateName: "Maine"),
        //        State(stateName: "Maryland"),
        //        State(stateName: "Massachusetts"),
        //        State(stateName: "Michigan"),
        //        State(stateName: "Minnesota"),
        //        State(stateName: "Mississippi"),
        //        State(stateName: "Missouri"),
        //        State(stateName: "Montana"),
        //        State(stateName: "Nebraska"),
        //        State(stateName: "Nevada"),
        //        State(stateName: "New Hampshire"),
        //        State(stateName: "New Jersey"),
        //        State(stateName: "New Mexico"),
        //        State(stateName: "New York"),
        //        State(stateName: "North Carolina"),
        //        State(stateName: "North Dakota"),
        //        State(stateName: "Ohio"),
        //        State(stateName: "Oklahoma"),
        //        State(stateName: "Oregon"),
        //        State(stateName: "Pennsylvania"),
        //        State(stateName: "Rhode Island"),
        //        State(stateName: "South Carolina"),
        //        State(stateName: "South Dakota"),
        //        State(stateName: "Tennessee"),
        //        State(stateName: "Texas"),
        //        State(stateName: "Utah"),
        //        State(stateName: "Vermont"),
        //        State(stateName: "Virginia"),
        //        State(stateName: "Washington"),
        //        State(stateName: "West Virginia"),
        //        State(stateName: "Wisconsin"),
        //        State(stateName: "Wyoming")
    ]
}

struct MaritalStatus: Identifiable {
    let id = UUID().uuidString
    let maritalStatus: String
    
    static let maritalStatusList = [
        MaritalStatus(maritalStatus: "Choose One"),
        MaritalStatus(maritalStatus: "Single"),
        MaritalStatus(maritalStatus: "Married filling separate"),
        MaritalStatus(maritalStatus: "Married filling together"),
        MaritalStatus(maritalStatus: "Head of Household")
    ]
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


//MARK: - Preview
struct SelfCheckView_Previews: PreviewProvider {
    static var previews: some View {
        SelfCheckView()
    }
}
