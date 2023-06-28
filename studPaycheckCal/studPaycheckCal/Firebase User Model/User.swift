//
//  User.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/24/23.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    var userPaycheckData: [UserPaycheckData] = []
    
    var initials: String {
        let nameFormatter = PersonNameComponentsFormatter()
        if let components = nameFormatter.personNameComponents(from: fullname) {
            nameFormatter.style = .abbreviated
            return nameFormatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var testingUser = User(id: UUID().uuidString, fullname: "Firstname Lastname", email: "name@gmail.com")
}

struct UserPaycheckData: Identifiable, Codable {
    var id: String
    var federalTax: Double = 0.0
    var salaryAfterTax: Double = 0.0
    var stateTax: Double = 0.0
    var date: Date = Date()
    
}
