//
//  StringExtension.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 5/1/23.
//

import SwiftUI

extension String {
    var stringToDouble: Double {
        let cleanString = self.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        return (Double(cleanString) ?? 0.0)/100
    }
}

