//
//  ScanData.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import Foundation

struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
