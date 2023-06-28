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
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
    
    // Login Credentitals
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            // Content
            switch onboardingState{
            case 0:
                welcomeScreen
                    .transition(forwardTransition)
//            case 1:
//                SignInView()
//                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 1:
                locationScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 2:
                maritalStatusScreen
                    .transition(nextButtonPressed ? forwardTransition : backTransition)
            case 3:
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
    
    // Navigation Buttons
    private var forwardButton: some View {
        Text(onboardingState == 3 ? "FINISH" : "Next")
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
    
    //SCREENS
    // Welcome Screen
    private var welcomeScreen: some View {
        VStack(spacing: 20){
            Text("Welcome")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("In this App \nyou will be able to post your paycheck information and also estimate your future paychecks")
                .font(.system(size: 22))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
        }
        .modifier(CustomActionButtonDesign())
    }
    
    // Nationality and State
    private var locationScreen: some View {
        VStack{
            Text("1/3")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .padding(.bottom, 100)
                .padding(.top, 100)
            Text("Nationality and State")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
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
    }
    
    // Marital Status
    private var maritalStatusScreen: some View {
        VStack{
            Text("2/3")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .padding(.bottom, 100)
                .padding(.top, 100)
            Text("Marital Status")
                .font(.system(size: 48))
                .fontWeight(.bold)
            VStack {
                Text("Marital Status")
                Button {
                    showMaritalStatusPicker = true
                } label: {
                    Text(studentPaycheckCalVM.selectedMaritalStatus)
                        .modifier(CustomChoiceButtonDesign())
                }
            }
            .modifier(CustomBlockDesign())
            Spacer()
        }
        .sheet(isPresented: $showMaritalStatusPicker) {
            MaritalStatusSelectPicker(showMaritalStatusPicker: $showMaritalStatusPicker)
                .presentationDetents([.height(200)])
        }
    }
    
    // W4 Filled or not
    private var w4FilledScreen: some View {
        VStack{
            Text("3/3")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .padding(.bottom, 100)
                .padding(.top, 100)
            Text("W4 Filled or not")
                .font(.system(size: 48))
                .fontWeight(.bold)
            VStack {
                Text("W4?")
                Button {
                    showW4Picker = true
                } label: {
                    Text(studentPaycheckCalVM.selectedW4)
                        .modifier(CustomChoiceButtonDesign())
                }
            }
            .modifier(CustomBlockDesign())
            Spacer()
        }
        .sheet(isPresented: $showW4Picker) {
            W4SelectPicker(showW4Picker: $showW4Picker)
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
        case 1:
            guard studentPaycheckCalVM.selectedCountry != "Choose One",
                  studentPaycheckCalVM.selectedState != "Choose One"
            else {
                showAlertFunction()
                return
            }
        case 2:
            guard studentPaycheckCalVM.selectedMaritalStatus != "Choose One" else {
                showAlertFunction()
                return
            }
        case 3:
            guard studentPaycheckCalVM.selectedW4 != "Choose One" else {
                showAlertFunction()
                return
            }
        default:
            break
        }
        
        // Go To Next Section
        if onboardingState == 3 {
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
        alertMessage = "You have not made a choice \nplease make a choice from the picker view"
        showAlert.toggle()
    }
    
}
