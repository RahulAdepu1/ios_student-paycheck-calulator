//
//  SignInView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/24/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View{
        VStack{
            Text("Welcome, \nSign In to your account")
                .font(.system(size: 36))
                .padding(.top, 150)
                .padding(.bottom, 50)

            // Form Fields
            VStack(spacing: 24){
                CustomTextField(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .textInputAutocapitalization(.none)
                
                CustomTextField(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
            }
            .padding(.horizontal, 30)
            
            //Reset Button
//            HStack {
//                Spacer()
//                Button {
//
//
//                    Task {
//                        try await authViewModel.resetPassword(email: email)
//                    }
//                } label: {
//                    Text("Forgot Password")
//                }
//            }.padding(.horizontal, 30)
            
            //Sign in Button
            Button {
                Task {
                    try await authViewModel.signIn(withEmail: email, password: password)
                }
            } label: {
                HStack {
                    Text("SIGN IN")
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
            
            NavigationLink {
                RegistrationView()
            } label: {
                HStack {
                    Text("Don't have an account?")
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom, 100)
            
        }
        .onChange(of: authViewModel.userSession) { newValue in
            dismiss()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
        .environmentObject(AuthViewModel())
    }
}

extension SignInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
    }
}
