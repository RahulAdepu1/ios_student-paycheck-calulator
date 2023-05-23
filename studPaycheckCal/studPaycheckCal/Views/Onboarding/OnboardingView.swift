//
//  OnboardingView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct OnboardingView: View {
    
    //Onboarding States:
    /*
     0 - Welcome Screen
     1 - Sign In
     2 - Nationality and State
     3 - Marital Status
     4 - W4 Filled or not
     */
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @State var onboardingState: Int = 0
    
    let forwardTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    let backTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing))
    
    @State var nextButtonPressed: Bool = false
    
    // Alert
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    // Bools for PickerViews
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
    
    var body: some View {
        ZStack {
            // Content
            switch onboardingState{
            case 0:
                welcomeScreen
                    .transition(forwardTransition)
            case 1:
                signInScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 2:
                locationScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 3:
                maritalStatusScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 4:
                w4FilledScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            default:
                defaultScreen
            }
            
            // Button
            VStack{
                Spacer()
                HStack(spacing:0) {
                    switch onboardingState {
                    case 0: forwardButton
                    default:
                        backButton
                        forwardButton
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
        } message: {
            Text(alertMessage)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            OnboardingView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
    }
}


// MARK: - Content
extension OnboardingView {
    
    private var forwardButton: some View {
        Text(onboardingState == 1 ? "SIGN UP" :
                onboardingState == 4 ? "FINISH" :
                "Next"
        )
            .modifier(CustomActionButtonDesign())
            .onTapGesture {
                nextButtonPressed = true
                handleNextButtonPressed()
            }
    }
    
    private var backButton: some View {
        Text("Back")
            .modifier(CustomActionButtonDesign())
            .onTapGesture {
                nextButtonPressed = false
                handleBackButtonPressed()
            }
    }
    
    // Welcome Screen
    private var welcomeScreen: some View {
        VStack{
            Text("Welcome Screen")
                .modifier(CustomActionButtonDesign())
            
        }
    }
    
    // Sign In
    private var signInScreen: some View {
        VStack{
            Text("Sign In")
                .modifier(CustomActionButtonDesign())
        }
        
    }
    
    // Nationality and State
    private var locationScreen: some View {
        VStack{
            Text("Nationality and State")
                .modifier(CustomActionButtonDesign())
            HStack{
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
            .padding(.horizontal, 50)
        }
        .sheet(isPresented: $showContryPicker) {
            NationalitySelectPicker()
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showStatePicker) {
            StateSelectPicker()
                .presentationDetents([.height(200)])
        }
        
    }
    
    // Marital Status
    private var maritalStatusScreen: some View {
        VStack{
            Text("Marital Status")
                .modifier(CustomActionButtonDesign())
            VStack {
                Text("Marital Status")
                    .modifier(CustomTextDesign1())
                Button {
                    showMaritalStatusPicker = true
                } label: {
                    Text(studentPaycheckCalVM.selectedMaritalStatus)
                        .modifier(CustomChoiceButtonDesign())
                }
            }
            .modifier(CustomBlockDesign())
        }
        .sheet(isPresented: $showMaritalStatusPicker) {
            MaritalStatusSelectPicker()
                .presentationDetents([.height(200)])
        }
    }
    
    // W4 Filled or not
    private var w4FilledScreen: some View {
        VStack{
            Text("W4 Filled or not")
                .modifier(CustomActionButtonDesign())
            VStack {
                Text("W4?")
                    .modifier(CustomTextDesign1())
                Button {
                    showW4Picker = true
                } label: {
                    Text(studentPaycheckCalVM.selectedW4)
                        .modifier(CustomChoiceButtonDesign())
                }
            }
            .modifier(CustomBlockDesign())
        }
        .sheet(isPresented: $showW4Picker) {
            W4SelectPicker()
                .presentationDetents([.height(200)])
        }
    }
    
    // Default
    private var defaultScreen: some View {
        VStack{
            Text("Default")
                .modifier(CustomActionButtonDesign())
        }
        
    }
}


// MARK: - Function

extension OnboardingView {
    func handleNextButtonPressed() {
        
        // Check Inputs
        switch onboardingState {
        case 2:
            guard studentPaycheckCalVM.selectedCountry != "Choose One",
                  studentPaycheckCalVM.selectedState != "Choose One"
            else {
                showAlertFunction()
                return
            }
        case 3:
            guard studentPaycheckCalVM.selectedMaritalStatus != "Choose One" else {
                showAlertFunction()
                return
            }
        case 4:
            guard studentPaycheckCalVM.selectedW4 != "Choose One" else {
                showAlertFunction()
                return
            }
        default:
            break
        }
        
        // Go To Next Section
        if onboardingState == 4 {
            signedIn()
        } else {
            withAnimation(.easeInOut) {
                onboardingState += 1
            }
        }
    }
    
    func handleBackButtonPressed() {
        withAnimation(.easeInOut) {
            onboardingState -= 1
        }
    }
    
    func signedIn() {
        selectedCountry = studentPaycheckCalVM.selectedCountry
        selectedState = studentPaycheckCalVM.selectedState
        selectedMaritalStatus = studentPaycheckCalVM.selectedMaritalStatus
        selectedW4Filled = studentPaycheckCalVM.selectedW4
        withAnimation {
            userSignedIn = true 
        }
    }
    
    func showAlertFunction() {
        alertTitle = "DID NOT CHOOSE"
        alertMessage = "You have not make a choice \nplease make a choice"
        showAlert.toggle()
    }
    
}
