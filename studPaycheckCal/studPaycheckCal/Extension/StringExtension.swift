//
//  StringExtension.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 5/1/23.
//

import SwiftUI

extension String {
    var stringToDouble: Double {
        let noDotString = self.replacingOccurrences(of: ".", with: "")
        let noCommaString = noDotString.replacingOccurrences(of: ",", with: "")
        return (Double(noCommaString) ?? 0.0)/100
    }
    
    var stringToIntYear: Int {
        return (Int(self) ?? 0)
    }
    
    var currencyFormattedString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 2
        
        let cleanString = self.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        let doubleValue = (Double(cleanString) ?? 0.0)/100
        return String(numberFormatter.string(from: NSNumber(value: doubleValue)) ?? "")
    }
}

