//
//  TabBarItem.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import Foundation
import SwiftUI 

enum TabBarItem: Hashable {
    case paycheck, favorites, profile
    
    var iconImageName: String {
        switch self {
        case .paycheck: return "house"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
    
    var iconTitle: String {
        switch self {
        case .paycheck: return "Paycheck Cal"
        case .favorites: return "History"
        case .profile: return "Profile"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .paycheck: return .red
        case .favorites: return .blue
        case .profile: return .green
        }
    }
}
 
