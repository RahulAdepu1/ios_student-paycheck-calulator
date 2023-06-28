//
//  DoubleExtension.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 5/1/23.
//

import Foundation

extension Double {
    var doubleToString1: String {
        if self >= 1000 && self < 999999 {
            return String(format: "%.1fK", self/1000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", self)
    }
}

extension Double {
    var doubleToString2: String {
        return String(format: "%.2f", self)
    }
}

extension Double {
    var doubleToCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
