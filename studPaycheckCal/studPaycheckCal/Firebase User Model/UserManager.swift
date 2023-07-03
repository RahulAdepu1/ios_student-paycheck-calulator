//
//  UserManager.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/30/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager: ObservableObject {
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    private func userPaycheckDataCollection(userID: String) -> CollectionReference {
        userDocument(userID: userID).collection("paycheckHistory")
    }
    
    private func userPaycheckDataDocument(userID: String, paycheckID: String) -> DocumentReference {
        userPaycheckDataCollection(userID: userID).document(paycheckID)
    }
    
    func addUserPaycheckData(userId: String) async throws -> Bool {
        
        var dataSaved = false
        let studentPaycheckCoreDataVM = StudentPaycheckCoreDataVM().studentPayCheckCoreData
        
        print("Paycheck Core Data Count - \(studentPaycheckCoreDataVM.count)")
        
        if studentPaycheckCoreDataVM.count > 0 {
            for num in 0..<studentPaycheckCoreDataVM.count {
                let paycheckDocument = userCollection.document(userId).collection("paycheckHistory").document(studentPaycheckCoreDataVM[num].id!)
                let paycheckData = UserPaycheckData(id: studentPaycheckCoreDataVM[num].id!,
                                                    date: studentPaycheckCoreDataVM[num].date!,
                                                    maritalStatus: studentPaycheckCoreDataVM[num].maritalStatus!,
                                                    country: studentPaycheckCoreDataVM[num].country!,
                                                    state: studentPaycheckCoreDataVM[num].state!,
                                                    w4: studentPaycheckCoreDataVM[num].w4!,
                                                    payPeriod: studentPaycheckCoreDataVM[num].payPeriod!,
                                                    payRateAmount: studentPaycheckCoreDataVM[num].payRateAmount,
                                                    hours: studentPaycheckCoreDataVM[num].hours,
                                                    minutes: studentPaycheckCoreDataVM[num].minutes,
                                                    salaryType: studentPaycheckCoreDataVM[num].salaryType!,
                                                    federalTax: studentPaycheckCoreDataVM[num].federalTax,
                                                    salaryAfterTax: studentPaycheckCoreDataVM[num].salaryAfterTax,
                                                    stateTax: studentPaycheckCoreDataVM[num].stateTax)
                let encoderUserPaycheckData = try Firestore.Encoder().encode(paycheckData)
                
                try await paycheckDocument.setData(encoderUserPaycheckData, merge: true)
            }
            print("Data saved to Cloud")
            dataSaved = true
        } else {
            print("Data not saved to Cloud")
        }
        
        return dataSaved
    }
    
    func loadPaycheckData (userID: String) async throws -> [UserPaycheckData] {
        let userPaycheckSnapshot = try await userPaycheckDataCollection(userID: userID).getDocuments()
        
        var userPaycheckDatas:[UserPaycheckData] = []
        
        for doc in userPaycheckSnapshot.documents {
            let userPaycheckData = try doc.data(as: UserPaycheckData.self)
//            print("Cloud Data-> \(userPaycheckData)")
            userPaycheckDatas.append(userPaycheckData)
        }
        
        return userPaycheckDatas
    }
    
    func loadPaycheckCoreData(userId: String) async throws {
        let studentPaycheckCoreDataVM = StudentPaycheckCoreDataVM()
        let paycheckCloudData = try await loadPaycheckData(userID: userId)
        
        var paycheckCloudDataArray:[String] = []
        
        for data in paycheckCloudData {
            paycheckCloudDataArray.append(data.id)
        }
        
        for data in 0 ..< paycheckCloudData.count {
            if !paycheckCloudDataArray.contains(studentPaycheckCoreDataVM.studentPayCheckCoreData[data].id ?? ""){
                studentPaycheckCoreDataVM.addPaycheck(id: paycheckCloudData[data].id,
                                                      date: paycheckCloudData[data].date,
                                                      country: paycheckCloudData[data].country,
                                                      state: paycheckCloudData[data].state,
                                                      maritalStatus: paycheckCloudData[data].maritalStatus,
                                                      payPeriod: paycheckCloudData[data].payPeriod,
                                                      payRateAmount: paycheckCloudData[data].payRateAmount,
                                                      salaryType: paycheckCloudData[data].salaryType,
                                                      w4: paycheckCloudData[data].w4,
                                                      hours: paycheckCloudData[data].hours, minutes: paycheckCloudData[data].minutes,
                                                      federalTax: paycheckCloudData[data].federalTax,
                                                      stateTax: paycheckCloudData[data].stateTax,
                                                      salaryAfterTax: paycheckCloudData[data].salaryAfterTax)
            } else {
                print("Data already exist -\(data)")
            }
        }
//        print("Cloud Data count ->\(paycheckCloudData.count)")
//        print("Core Data count ->\(studentPaycheckCoreDataVM.studentPayCheckCoreData.count)")
//        for i in 0..<studentPaycheckCoreDataVM.studentPayCheckCoreData.count {
//            print("\(studentPaycheckCoreDataVM.studentPayCheckCoreData[i])")
//        }
//
        print("Cloud Data count ->\(paycheckCloudData.count)")
        print("Core Data count ->\(studentPaycheckCoreDataVM.studentPayCheckCoreData.count)")
        print("Done loading all data from cloud to Paycheck Core Data")
    }
}
