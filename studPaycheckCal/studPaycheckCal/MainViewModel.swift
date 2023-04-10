//
//  MainViewModel.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import Foundation

class StudentPaycheckCalculatorVM: ObservableObject{
    @Published var selectedCountry = "Choose One"
    @Published var selectedState = "Choose One"
    @Published var selectedW4 = "Choose One"
    @Published var selectedMaritalStatus = "Choose One"
    @Published var selectedPayPeriod = "Choose One"
    @Published var selectedPayRateAmount = "Choose One"
    @Published var selectedHours = "Choose One"
    @Published var selectedSalaryType = "Choose One"
    
    @Published var navToSelfCheck2 = false
    @Published var navToSelfCheckResult = false
    
    var canNavToSelfCheck2: Bool {
        return selectedCountry != "Choose One"
        && selectedState != "Choose One"
        && selectedW4 != "Choose One"
        && selectedMaritalStatus != "Choose One"
    }
    
    var canNavToSelfCheckResult: Bool {
        return selectedPayPeriod != "Choose One"
        && selectedPayRateAmount != "Choose One"
        && selectedHours != "Choose One"
        && selectedSalaryType != "Choose One"
    }
    
    
}
