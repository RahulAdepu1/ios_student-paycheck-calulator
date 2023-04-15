//
//  StateTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/12/23.
//

import SwiftUI

class StateTaxCalculator{
    
    //State Tax
    func calStateStandardDeduction(nationality: String, w4Filled: String) -> Double {
        var stateStandardDeduction = 0.0
        
        if nationality == "India" {
            if w4Filled == "Yes"{
                stateStandardDeduction = 2375.0
            }
        }else if nationality == "USA"{
            stateStandardDeduction = 2375.0
        }
        
        print("State Standard Deduction is =", stateStandardDeduction)
        return stateStandardDeduction
    }

    func calStateTaxableIncome(annualizedSalary: Double, stateStandardDeduction: Double) -> Double {
        var stateTaxableIncome = 0.0
        
        stateTaxableIncome = annualizedSalary - stateStandardDeduction
        if stateTaxableIncome < 0.0 {
            stateTaxableIncome = 0.0
        }
        
        print("State Taxable Income =", stateTaxableIncome)
        return stateTaxableIncome
    }

    func calAnnualizedStateTax(state: String, stateTaxableIncome: Double) -> Double {
        var stateTaxRate = 0.0
        
        if state == "Illinois" {
            stateTaxRate = 4.95
        }
        
        let annualizedStateTax = stateTaxableIncome * (stateTaxRate/100)
        print("Annualized State Tax =", annualizedStateTax)
        return annualizedStateTax
    }

    func stateTax(annualizedFederalTax: Double, salaryType: String) -> Double{
        var stateTaxAmount = 0.0
        
        if salaryType == "Weekly"{
            stateTaxAmount = annualizedFederalTax / 52
        }else if salaryType == "Bi-Weekly"{
            stateTaxAmount = annualizedFederalTax / 26
        }else if salaryType == "Bi-Monthly"{
            stateTaxAmount = annualizedFederalTax / 24
        }else if salaryType == "Monthly"{
            stateTaxAmount = annualizedFederalTax / 12
        }
        print("State Tax =", stateTaxAmount)
        return stateTaxAmount
    }
}
