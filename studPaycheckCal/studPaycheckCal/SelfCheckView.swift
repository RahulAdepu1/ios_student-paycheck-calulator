//
//  SelfCheckView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @Environment(\.dismiss) var dismiss
    
    @State private var showContryPicker: Bool = false
    @State private var showStatePicker: Bool = false
    @State private var showW4Picker: Bool = false
    @State private var showMaritalStatusPicker: Bool = false
    
    // App Storage
    @AppStorage("signed_in") var userSignedIn: Bool = false
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("state") var selectedState: String?
    @AppStorage("maritalStatus") var selectedMaritalStatus: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    // Alert
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                Text("Make a choice for all the options \nto move to next page")
                    .multilineTextAlignment(.center)
                    .padding(10)
                
                VStack {
                    HStack {
                        // Nationality Block
                        VStack {
                            Text("Nationality")
                                .modifier(CustomTextDesign4())
                            Button {
                                showContryPicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedCountry)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .modifier(CustomBlockDesign())
                        
                        // State Block
                        VStack {
                            Text("State")
                                .modifier(CustomTextDesign4())
                            Button {
                                showStatePicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedState)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .modifier(CustomBlockDesign())
                    }
                    
                    HStack{
                        // W4 Block
                        VStack {
                            Text("W4?")
                                .modifier(CustomTextDesign4())
                            Button {
                                showW4Picker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedW4)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .modifier(CustomBlockDesign())
                        
                        // Marital Status Block
                        VStack {
                            Text("Marital Status")
                                .modifier(CustomTextDesign4())
                            Button {
                                showMaritalStatusPicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedMaritalStatus)
                                    .modifier(CustomChoiceButtonDesign())
                            }
                        }
                        .modifier(CustomBlockDesign())
                    }
                }
                .modifier(CustomBlockDesign())
                .padding(.horizontal)
                
                Spacer()
                Button {
                    updateAppStorageValues()
                    dismiss()
                } label: {
                    Text("Done")
                        .modifier(CustomActionButtonDesign())
                }
                Spacer()
                
            }
            .sheet(isPresented: $showContryPicker) {
                NationalitySelectPicker(showContryPicker: $showContryPicker)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showStatePicker) {
                StateSelectPicker(showStatePicker: $showStatePicker)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showW4Picker) {
                W4SelectPicker(showW4Picker: $showW4Picker)
                    .presentationDetents([.height(200)])
            }
            
            .sheet(isPresented: $showMaritalStatusPicker) {
                MaritalStatusSelectPicker(showMaritalStatusPicker: $showMaritalStatusPicker)
                    .presentationDetents([.height(200)])
            }
            
            .alert(alertTitle, isPresented: $showAlert) {
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func updateAppStorageValues() {
        guard studentPaycheckCalVM.selectedCountry != "Choose One",
        studentPaycheckCalVM.selectedState != "Choose One",
        studentPaycheckCalVM.selectedMaritalStatus != "Choose One",
        studentPaycheckCalVM.selectedW4 != "Choose One"
        else {
            showAlertFunction()
            return
        }
        
        selectedCountry = studentPaycheckCalVM.selectedCountry
        selectedState = studentPaycheckCalVM.selectedState
        selectedMaritalStatus = studentPaycheckCalVM.selectedMaritalStatus
        selectedW4Filled = studentPaycheckCalVM.selectedW4
    }
    
    func showAlertFunction() {
        alertTitle = "DID NOT CHOOSE"
        alertMessage = "You have not made a choice \nplease make a choice"
        self.showAlert.toggle()
    }
}


//MARK: - Picker Views
struct NationalitySelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @Binding var showContryPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showContryPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
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
    @Binding var showStatePicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showStatePicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
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
    @Binding var showW4Picker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showW4Picker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
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
    @Binding var showMaritalStatusPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showMaritalStatusPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
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
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
    }
}
