//
//  MainModel.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import Foundation

//MARK: - Data Model
struct W4Filled: Identifiable {
    let id = UUID().uuidString
    let option: String
    
    static let w4FilledList = [
        W4Filled(option: "Choose One"),
        W4Filled(option: "Yes"),
        W4Filled(option: "No")
    ]
    
}

struct CountryNames: Identifiable {
    let id = UUID().uuidString
    let name: String
    
    static let countriesList = [
        CountryNames(name: "Choose One"),
        CountryNames(name: "India"),
        CountryNames(name: "USA")
    ]
}

struct StateNames: Identifiable {
    let id = UUID().uuidString
    let stateName: String
    
    static let statesList = [
        StateNames(stateName: "Choose One"),
        //        State(stateName: "Alabama"),
        //        State(stateName: "Alaska"),
        //        State(stateName: "Arizona"),
        //        State(stateName: "Arkansas"),
        //        State(stateName: "California"),
        //        State(stateName: "Colorado"),
        //        State(stateName: "Connecticut"),
        //        State(stateName: "Delaware"),
        //        State(stateName: "Florida"),
        //        State(stateName: "Georgia"),
        //        State(stateName: "Hawaii"),
        //        State(stateName: "Idaho"),
        StateNames(stateName: "Illinois")
        //        State(stateName: "Indiana"),
        //        State(stateName: "Iowa"),
        //        State(stateName: "Kansas"),
        //        State(stateName: "Kentucky"),
        //        State(stateName: "Louisiana"),
        //        State(stateName: "Maine"),
        //        State(stateName: "Maryland"),
        //        State(stateName: "Massachusetts"),
        //        State(stateName: "Michigan"),
        //        State(stateName: "Minnesota"),
        //        State(stateName: "Mississippi"),
        //        State(stateName: "Missouri"),
        //        State(stateName: "Montana"),
        //        State(stateName: "Nebraska"),
        //        State(stateName: "Nevada"),
        //        State(stateName: "New Hampshire"),
        //        State(stateName: "New Jersey"),
        //        State(stateName: "New Mexico"),
        //        State(stateName: "New York"),
        //        State(stateName: "North Carolina"),
        //        State(stateName: "North Dakota"),
        //        State(stateName: "Ohio"),
        //        State(stateName: "Oklahoma"),
        //        State(stateName: "Oregon"),
        //        State(stateName: "Pennsylvania"),
        //        State(stateName: "Rhode Island"),
        //        State(stateName: "South Carolina"),
        //        State(stateName: "South Dakota"),
        //        State(stateName: "Tennessee"),
        //        State(stateName: "Texas"),
        //        State(stateName: "Utah"),
        //        State(stateName: "Vermont"),
        //        State(stateName: "Virginia"),
        //        State(stateName: "Washington"),
        //        State(stateName: "West Virginia"),
        //        State(stateName: "Wisconsin"),
        //        State(stateName: "Wyoming")
    ]
}

struct MaritalStatus: Identifiable {
    let id = UUID().uuidString
    let maritalStatus: String
    
    static let maritalStatusList = [
        MaritalStatus(maritalStatus: "Choose One"),
        MaritalStatus(maritalStatus: "Single"),
        MaritalStatus(maritalStatus: "Married filling separate"),
        MaritalStatus(maritalStatus: "Married filling together"),
        MaritalStatus(maritalStatus: "Head of Household")
    ]
}


// MARK: - SecondView Data Source
struct PayPeriod: Identifiable {
    let id = UUID().uuidString
    let payPeriod: String
    
    // User has to choose how often they get paid
    static let payPeriodList = [
        PayPeriod(payPeriod: "Choose One"),
        PayPeriod(payPeriod: "Weekly"),
        PayPeriod(payPeriod: "Bi-Weekly"),
        PayPeriod(payPeriod: "Bi-Monthly"),
        PayPeriod(payPeriod: "Monthly")
    ]
}

struct SalaryType: Identifiable  {
    let id = UUID().uuidString
    let salaryType: String
    
    // User has to choose the type of salary mentioned for the job
    static let salaryTypeList = [
        SalaryType(salaryType: "Choose One"),
        SalaryType(salaryType: "Hourly"),
        SalaryType(salaryType: "Monthly")
    ]
}

struct AnnualizedRate: Identifiable  {
    let id = UUID().uuidString
    let payRate: String
    
    static let annualizedRateList = [
        AnnualizedRate(payRate: "Choose One"),
        AnnualizedRate(payRate: "Weekly"),
        AnnualizedRate(payRate: "Bi-Weekly"),
        AnnualizedRate(payRate: "Bi-Monthly"),
        AnnualizedRate(payRate: "Monthly")
    ]
}

struct Year: Identifiable  {
    let id = UUID().uuidString
    let year: String
    
    static let yearList = [
        Year(year: "2023"),
        Year(year: "2022"),
        Year(year: "2021")
    ]
}

struct payPeriodAmount {
    let payPeriod: String
    let factor: Int
    
    static let factorValue = [
        payPeriodAmount(payPeriod: "Weekly", factor: 52),
        payPeriodAmount(payPeriod: "Bi-Weekly", factor: 26),
        payPeriodAmount(payPeriod: "Bi-Monthly", factor: 24),
        payPeriodAmount(payPeriod: "Monthly", factor: 12),
        payPeriodAmount(payPeriod: "Annually", factor: 1)
    ]
}
