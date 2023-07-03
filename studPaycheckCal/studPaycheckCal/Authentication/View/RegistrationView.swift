//
//  RegistrationView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/24/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Create an account")
                .font(.system(size: 36))
                .padding(.top, 150)
                .padding(.bottom, 50)

            // Form Fields
            VStack(spacing: 24){
                CustomTextField(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .textInputAutocapitalization(.none)
                
                CustomTextField(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                CustomTextField(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                ZStack(alignment: .trailing) {
                    CustomTextField(text: $confirmPassword,
                              title: "Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            
            //Sign in Button
            Button {
                //Create a new User
                Task {
                    try await authViewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullname: fullname)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            .padding(.bottom, 150)
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, 100)
        }
        .onChange(of: authViewModel.userSession) { newValue in
            dismiss()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegistrationView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
        .environmentObject(AuthViewModel())
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && confirmPassword == password
        && !fullname.isEmpty
    }
}
