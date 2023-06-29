//
//  StateTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/12/23.
//

import SwiftUI

class StateTaxCalculator{
    
    // Calculate Tax Amount for Annual Salary
    func annualStateTaxAmount(annualSalary:Double, year: Int, state: String) -> Double{
        var stateTaxAmount = 0.0
        
        // Filter out and get only particular state's data
        let filteredData = StateTaxByYear.stateData.filter { $0.year == year }
            .flatMap { $0.stateTaxByState }
            .filter { $0.state == state }
        
        // Get the Double factor value of the the corresponding salaryType
        let stateTaxRate = (filteredData[0].stateTaxRate)/100
        let standardDeduction = filteredData[0].standardDeduction
        
        // Calculate State Tax Amount
        stateTaxAmount = (annualSalary - standardDeduction) * stateTaxRate
        return stateTaxAmount
    }
    
    // Calculating state tax rate
    func stateTaxCal(taxableIncome: Double, year: Int, state: String, payPeriod: String,
                      nationality: String, w4Filled: String) -> Double {
        var stateTaxAmount = 0.0
        var standardDeduction = 0.0
        
        // Filter out and get only particular state's data
        let filteredData = StateTaxByYear.stateData.filter { $0.year == year }
            .flatMap { $0.stateTaxByState }
            .filter { $0.state == state }
        
        // Get the Double factor value of the the corresponding salaryType
        let salaryTypefactor = Double(PayPeriodAmount.payPeriodAmountList.filter { $0.payPeriod == payPeriod }[0].factor)
        let stateTaxRate = (filteredData[0].stateTaxRate)/100
        
        // Verify if standard deduction applied or not
        if nationality == "India" {
            if w4Filled == "Yes"{
                standardDeduction = filteredData[0].standardDeduction
            }
        }
        
        // Calculate State Tax Amount
//        print("taxableIncome -", taxableIncome)
//        print("standardDeduction -", standardDeduction)
//        print("salaryTypefactor -", salaryTypefactor)
//        print("stateTaxRate -", stateTaxRate)
//        print("(\(taxableIncome) - (\(standardDeduction)/\(salaryTypefactor))) * (\(stateTaxRate))")
        if (taxableIncome > (standardDeduction/salaryTypefactor)){
            stateTaxAmount = (taxableIncome - (standardDeduction/salaryTypefactor)) * (stateTaxRate)
        }
        
        
        return stateTaxAmount
    }
    
    func calculateStateTax(totalSalary: Double, year: Int, state: String) -> [Double] {
        // Filter out and get only particular state's data
        let filteredData = StateTaxByYear.stateData.filter { $0.year == year }
            .flatMap { $0.stateTaxByState }
            .filter { $0.state == state }
        
        let annualizedStateTax = (totalSalary - filteredData[0].standardDeduction) * (filteredData[0].stateTaxRate/100)
        let effectiveStateTaxRate = (annualizedStateTax/totalSalary) * 100
        let marginalStateTaxRate = filteredData[0].stateTaxRate
        
        //[annualizedFederalTax, marginalTaxRate, effectiveTaxRate]
        return [annualizedStateTax, marginalStateTaxRate, effectiveStateTaxRate]
    }
}

struct StateTaxByYear {
    let year: Int
    let stateTaxByState: [StateTaxByState]
    
    static let stateData = [
        StateTaxByYear(year: 2023, stateTaxByState: [StateTaxByState(state: "Choose One", standardDeduction: 0, stateTaxRate: 0.0),
                                                     StateTaxByState(state: "Illinois", standardDeduction: 2625, stateTaxRate: 4.95),
                                                     StateTaxByState(state: "Texas", standardDeduction: 0, stateTaxRate: 0.0)
                                                    ]),
        StateTaxByYear(year: 2022, stateTaxByState: [StateTaxByState(state: "Choose One", standardDeduction: 0, stateTaxRate: 0.0),
                                                     StateTaxByState(state: "Illinois", standardDeduction: 2425, stateTaxRate: 4.95),
                                                     StateTaxByState(state: "Texas", standardDeduction: 0, stateTaxRate: 0.0)
                                                    ]),
        StateTaxByYear(year: 2021, stateTaxByState: [StateTaxByState(state: "Choose One", standardDeduction: 0, stateTaxRate: 0.0),
                                                     StateTaxByState(state: "Illinois", standardDeduction: 2375, stateTaxRate: 4.95),
                                                     StateTaxByState(state: "Texas", standardDeduction: 0, stateTaxRate: 0.0)
                                                    ])
    ]
}

struct StateTaxByState {
    let state: String
    let standardDeduction: Double
    let stateTaxRate: Double
}
