//
//  ProfileView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    // App Storage
    @AppStorage("signed_in") var userSignedIn: Bool = false
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("state") var selectedState: String?
    @AppStorage("maritalStatus") var selectedMaritalStatus: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    var dataTitle: String = ""
    
    var body: some View {
        VStack{
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(50)
                .background(Color.gray.opacity(0.4))
                .clipShape(Circle())
                .overlay(alignment: .bottom) {
                    Button {
                        
                    } label: {
                        Text("Change me")
                            .offset(CGSize(width: 0, height: -15))
                    }

                }
            VStack{
//                dataView(dataTitle: "username: ", selectedValue: T##String?)
                dataView(dataTitle: "Country: ", selectedValue: studentPaycheckCalVM.selectedCountry)
                dataView(dataTitle: "State: ", selectedValue: studentPaycheckCalVM.selectedState)
                dataView(dataTitle: "W4: ", selectedValue: studentPaycheckCalVM.selectedW4)
                dataView(dataTitle: "Marital Status: ", selectedValue: studentPaycheckCalVM.selectedMaritalStatus)
            }
            .padding(.bottom, 50)
            
            
            NavigationLink {
                SelfCheckView()
            } label: {
                Text("Edit")
                    .modifier(CustomActionButtonDesign())
            }
            
            Button {
                signOut()
            } label: {
                Text("Sign Out")
                    .modifier(CustomActionButtonDesign())
            }
        }
    }
    
    func signOut() {
        selectedCountry = nil
        selectedState = nil
        selectedMaritalStatus = nil
        selectedW4Filled = nil
        
        studentPaycheckCalVM.selectedCountry = "Choose One"
        studentPaycheckCalVM.selectedState = "Choose One"
        studentPaycheckCalVM.selectedW4 = "Choose One"
        studentPaycheckCalVM.selectedMaritalStatus = "Choose One"
        
        withAnimation {
            userSignedIn = false
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
    }
}

struct dataView: View {
    var dataTitle: String
    var selectedValue: String?
    var body: some View{
        HStack {
            Text(dataTitle)
            Spacer()
            if let data = selectedValue {
                Text(data)
            }
        }
        .padding(.horizontal, 45)
        .padding(.vertical, 5)
    }
}
