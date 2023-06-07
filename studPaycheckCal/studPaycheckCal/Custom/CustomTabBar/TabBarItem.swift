//
//  TabBarItem.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import Foundation
import SwiftUI 

enum TabBarItem: Hashable {
    case income, paycheck, favorites, taxCal, profile
    
    var iconImageName: String {
        switch self {
        case .income: return "house"
        case .paycheck: return "house"
        case .favorites: return "clock.arrow.circlepath"
        case .taxCal: return "clock.arrow.circlepath"
        case .profile: return "person"
        }
    }
    
    var iconTitle: String {
        switch self {
        case .income: return "Income Cal"
        case .paycheck: return "Paycheck Cal"
        case .favorites: return "History"
        case .taxCal: return "Tax Cal"
        case .profile: return "Profile"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .income: return .yellow
        case .paycheck: return .red
        case .favorites: return .blue
        case .taxCal: return .green
        case .profile: return .gray
        }
    }
}
 
