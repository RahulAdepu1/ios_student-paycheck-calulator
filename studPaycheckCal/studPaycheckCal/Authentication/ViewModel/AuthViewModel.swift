//
//  AuthViewModel.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/24/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email:String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
        } catch {
            print(" DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encoderUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encoderUser)
            await fetchUser()
        } catch {
            print(" DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
//    func resetPassword(email: String) async throws {
//        try await Auth.auth().sendPasswordReset(withEmail: email)
//    }
    
    func deleteAccount() async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await user.delete()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to Delete Account with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(String(describing: self.currentUser))")
    }
}
