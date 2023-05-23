//
//  IntExtension.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 5/1/23.
//

import Foundation

extension Int {
    var stringIntFormat: String {
        return String(format: "%.0d", self)
    }
}

extension Int {
    var intToDouble: Double {
        return Double(self)
    }
}
