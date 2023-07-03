//
//  ProfileView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    @EnvironmentObject var authViewModel: AuthViewModel
    // Profile Image
    @State private var selectedImage: UIImage?
    
    //User Manager
    @StateObject private var userManager = UserManager()
    
    // App Storage
    @AppStorage("signed_in") var userSignedIn: Bool = false
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("state") var selectedState: String?
    @AppStorage("maritalStatus") var selectedMaritalStatus: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    var dataTitle: String = ""
    
    var body: some View {
        VStack{
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
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
            }else {
                Text((authViewModel.currentUser == nil) ? User.testingUser.initials : authViewModel.currentUser!.initials)
                    .font(.system(size: 56))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .padding(35)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(Circle())
                    .overlay(alignment: .bottom) {
                        Button {
                            
                        } label: {
                            Text("Change me")
                                .offset(CGSize(width: 0, height: -15))
                        }
                    }
                Text((authViewModel.currentUser == nil) ? User.testingUser.fullname : authViewModel.currentUser!.fullname)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 4)
                Text((authViewModel.currentUser == nil) ? User.testingUser.email : authViewModel.currentUser!.email)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            VStack{
                DataView(dataTitle: "Country: ", selectedValue: studentPaycheckCalVM.selectedCountry)
                DataView(dataTitle: "State: ", selectedValue: studentPaycheckCalVM.selectedState)
                DataView(dataTitle: "W4: ", selectedValue: studentPaycheckCalVM.selectedW4)
                DataView(dataTitle: "Marital Status: ", selectedValue: studentPaycheckCalVM.selectedMaritalStatus)
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            .padding(.bottom, 25)
            
            NavigationLink {
                SelfCheckView()
            } label: {
                Text("Edit")
                    .modifier(CustomActionButtonDesign())
            }
            
            if authViewModel.userSession == nil {
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Sign In")
                        .modifier(CustomActionButtonDesign())
                }
            } else {
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .modifier(CustomActionButtonDesign())
                }
                HStack{
                    Button {
                        if let user = authViewModel.currentUser {
                            Task {
                                try await userManager.addUserPaycheckData(userId: user.id)
                            }
                        }
                    } label: {
                        Text("Save to Cloud")
                            .modifier(CustomActionButtonDesign())
                    }
                    
                    Button {
                        if let user = authViewModel.currentUser {
                            Task {
                                try await userManager.loadPaycheckCoreData(userId: user.id)
                            }
                        }
                    } label: {
                        Text("Download from Cloud")
                            .modifier(CustomActionButtonDesign())
                    }
                }
            }
            
            Button {
                studentPaycheckCoreDataVM.deletePaycheck()
                Task {
                    try await authViewModel.deleteAccount()
                }
                wipeEverything()
            } label: {
                Text("Delete Account")
                    .modifier(CustomActionButtonDesign())
            }
        }
    }
    
    func wipeEverything() {
        selectedCountry = nil
        selectedState = nil
        selectedMaritalStatus = nil
        selectedW4Filled = nil
        
        studentPaycheckCalVM.selectedCountry = "Choose One"
        studentPaycheckCalVM.selectedState = "Choose One"
        studentPaycheckCalVM.selectedW4 = "Choose One"
        studentPaycheckCalVM.selectedMaritalStatus = "Choose One"
        
        print("Account Deleted")
        withAnimation {
            userSignedIn = false
        }
        
        for i in 0..<studentPaycheckCoreDataVM.studentPayCheckCoreData.count {
            print("Data\(studentPaycheckCoreDataVM.studentPayCheckCoreData[i])")
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
        .environmentObject(EffectiveTaxCalculator())
        .environmentObject(AuthViewModel())
    }
}

struct DataView: View {
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
