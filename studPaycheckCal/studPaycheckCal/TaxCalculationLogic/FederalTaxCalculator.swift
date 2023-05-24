//
//  FederalTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/12/23.
//

import SwiftUI

class FederalTaxCalculator{
    
    //Constant
    var taxBracket = [0, 10.0, 12.0, 22.0, 24.0, 32.0, 35.0, 37.0]
    
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
        
        //        print("Federal Standard Deduction is =", fedStandardDeduction)
        return fedStandardDeduction
    }
    
    //Calculate Federal Taxable Income
    func calFederalTaxableIncome(annualizedSalary: Double, fedStandardDeduction: Double) -> Double {
        var federalTaxableIncome = 0.0
        
        federalTaxableIncome = annualizedSalary - fedStandardDeduction
        
        // Check if annualized salary is less than the federal Standard Deduction
        if federalTaxableIncome < 0.0 {
            federalTaxableIncome = 0.0
        }
        
        //        print("Federal Taxable Income =", federalTaxableIncome)
        return federalTaxableIncome
    }
    
    //Calculate Tax Bracket Rate
    func taxBracketRate(federalTaxableIncome: Double, taxBracketAmountList: [Double]) -> Double{
        var fedTaxRate = 0.0
        for count in 0..<taxBracket.count {
            if federalTaxableIncome < taxBracketAmountList[count] {
                fedTaxRate = taxBracket[count]
                break
            }
        }
        return fedTaxRate
    }
    
    //Calculate Annualized Federal Tax
    func calAnnualizedFederalTax(federalTaxableIncome: Double, taxBracketAmountList: [Double]) -> Double {
        var annualizedFederalTax = 0.0
        var fedTaxableIncome = federalTaxableIncome
        //        print("Tax Bracket size =", taxBracket.count-1)
        for count in 0..<taxBracket.count{
            print("************")
            print(count)
            if fedTaxableIncome >= 0 {
                
                print("Federal Taxable Income =", fedTaxableIncome)
                print("Tax Bracket Amount =", taxBracketAmountList[count])
                
                if fedTaxableIncome > taxBracketAmountList[count] {
                    annualizedFederalTax += taxBracketAmountList[count] * (taxBracket[count]/100)
                    print("Annualized Federal Tax", annualizedFederalTax)
                    
                    print("\(fedTaxableIncome) - \(taxBracketAmountList[count]) =", (fedTaxableIncome - taxBracketAmountList[count]))
                    fedTaxableIncome = fedTaxableIncome - taxBracketAmountList[count]
                    print("Federal Taxable Income", fedTaxableIncome)
                }else{
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
    
    //Calculate Federal Tax per salary Type
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
        }else if salaryType == "Annually"{
            federalTaxAmount = annualizedFederalTax
        }
        //        print("Federal Tax =", federalTaxAmount)
        return federalTaxAmount
    }
    
    
    func calculateFederalTax(totalSalary: Double, year: Int, selectedMaritalStatus: String ) -> [Double] {
        var taxBracketValue = 0.0
        var annualizedFederalTax = 0.0
        var effectiveTaxRate = 0.0
        var marginalTaxRate = 0.0

        let standardDeduction = FederalStdDedByYear.federalData.filter { $0.year == year }[0].standardDeduction
        var fedTaxableIncome = calFederalTaxableIncome(annualizedSalary: totalSalary, fedStandardDeduction: standardDeduction)
        
        // Check the year and marital status to get the Tax Bracket List
        let taxBracketAmountList = FederalTaxBracketListByYear.federalTaxBracketListData.filter {
            $0.year == year &&
            $0.maritalStatus == selectedMaritalStatus
        }[0].taxBracketList
        
        print("Tax Bracket size =", taxBracket.count-1)
        for count in 1..<taxBracket.count{
            print("************")
            print(count)
            if fedTaxableIncome >= 0 {
                taxBracketValue = taxBracketAmountList[count] - taxBracketAmountList[count-1]
                if fedTaxableIncome > taxBracketValue {
                    annualizedFederalTax += taxBracketValue * (taxBracket[count]/100)
                    fedTaxableIncome = fedTaxableIncome - (taxBracketValue)
                }else{
                    annualizedFederalTax += fedTaxableIncome * (taxBracket[count]/100)
                    fedTaxableIncome = fedTaxableIncome - (taxBracketValue)
                    marginalTaxRate = taxBracket[count]
                }
            }
        }

        effectiveTaxRate = (annualizedFederalTax/totalSalary) * 100
        
        return [annualizedFederalTax, marginalTaxRate, effectiveTaxRate]
    }
}

struct FederalStdDedByYear {
    let year: Int
    let standardDeduction: Double
    
    static let federalData = [
        FederalStdDedByYear(year: 2023, standardDeduction: 13850.0),
        FederalStdDedByYear(year: 2022, standardDeduction: 12950.0),
        FederalStdDedByYear(year: 2021, standardDeduction: 12550.0)
    ]
}
