//
//  FederalTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/12/23.
//

import SwiftUI

class FederalTaxCalculator{

    //Constant
    var taxBracket = [10.0, 12.0, 22.0, 24.0, 32.0, 35.0, 37.0]

    //Calculate Federal Standard Deduction
    func calFedStandardDeduction(nationality: String, w4Filled: String) -> Double {
        var fedStandardDeduction = 0.0
        
        if nationality == "India" {
            if w4Filled == "Yes"{
                fedStandardDeduction = 12950.0
            }
        }else if nationality == "USA"{
            fedStandardDeduction = 12950.0
        }
        
        print("Federal Standard Deduction is =", fedStandardDeduction)
        return fedStandardDeduction
    }

    //Calculate Federal Taxable Income
    func calFederalTaxableIncome(annualizedSalary: Double, fedStandardDeduction: Double) -> Double {
        var federalTaxableIncome = 0.0
        
        federalTaxableIncome = annualizedSalary - fedStandardDeduction
        if federalTaxableIncome < 0.0 {
            federalTaxableIncome = 0.0
        }
        
        print("Federal Taxable Income =", federalTaxableIncome)
        return federalTaxableIncome
    }

    //Calculate Annualized Federal Tax
    func calAnnualizedFederalTax(federalTaxableIncome: Double, taxBracketAmountList: [Double]) -> Double {
        var annualizedFederalTax = 0.0
        var fedTaxableIncome = federalTaxableIncome
        print("Tax Bracket size =", taxBracket.count-1)
        for count in 0...(taxBracket.count-1){
            print("************")
            print(count)
            if fedTaxableIncome >= 0 {
                
                print("Federal Taxable Income =", fedTaxableIncome)
                print("Tax Bracket Amount =", taxBracketAmountList[count])
                
                if fedTaxableIncome < taxBracketAmountList[count] {
                    annualizedFederalTax += fedTaxableIncome * (taxBracket[count]/100)
                    print("Annualized Federal Tax", annualizedFederalTax)

                    print("\(fedTaxableIncome) - \(taxBracketAmountList[count]) =", (fedTaxableIncome - taxBracketAmountList[count]))
                    fedTaxableIncome = fedTaxableIncome - taxBracketAmountList[count]
                    print("Federal Taxable Income", fedTaxableIncome)
                }
            }
        }
        
        print("Annualized Federal Tax =", annualizedFederalTax)
        return annualizedFederalTax
    }

    //Calculate Federal Tax
    func federalTax(annualizedFederalTax: Double, salaryType: String) -> Double{
        var federalTaxAmount = 0.0
        
        if salaryType == "Weekly"{
            federalTaxAmount = annualizedFederalTax / 52
        }else if salaryType == "Bi-Weekly"{
            federalTaxAmount = annualizedFederalTax / 26
        }else if salaryType == "Bi-Monthly"{
            federalTaxAmount = annualizedFederalTax / 24
        }else if salaryType == "Monthly"{
            federalTaxAmount = annualizedFederalTax / 12
        }
        print("Federal Tax =", federalTaxAmount)
        return federalTaxAmount
    }
        
}
