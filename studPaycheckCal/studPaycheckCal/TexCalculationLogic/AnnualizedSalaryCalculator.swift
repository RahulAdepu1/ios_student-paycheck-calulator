//
//  AnnualizedSalaryCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/12/23.
//

import SwiftUI

class AnnualizedSalaryCalculator {
    
    func salaryBeforeTax(salaryType: String, hours: Double, payRateAmount: Double) -> Double{
        var salaryBeforeTax = 0.0
        if salaryType == "Monthly" {
            salaryBeforeTax = payRateAmount //annualizedRate.annualizedRateList[].payRate
        }else if salaryType == "Hourly"{
            salaryBeforeTax = hours * payRateAmount
        }
        
        print("Salary Before Tax is =", salaryBeforeTax)
        return salaryBeforeTax
    }
    
    func calTaxBracket(maritalStatus: String) -> [Double]{
        var taxBracketAmountList: [Double] = []
        if maritalStatus == "Single"{
            taxBracketAmountList = [11000.0, 44725.0, 95375.0, 182100.0, 231250.0, 578125.0, 999999999.0]
        }else if maritalStatus == "Married filling separate"{
            taxBracketAmountList = [11000.0, 44725.0, 95375.0, 182100.0, 231250.0, 346875.0, 999999999.0]
        }else if maritalStatus == "Married filling together"{
            taxBracketAmountList = [22000.0, 89450.0, 190750.0, 364200.0, 462500.0, 693750.0, 999999999.0]
        }else if maritalStatus == "Head of Household"{
            taxBracketAmountList = [15700.0, 59850.0, 95350.0, 182100.0, 231250.0, 578100.0, 999999999.0]
        }
        
        print("tax Bracket Amount List is =", taxBracketAmountList)
        return taxBracketAmountList
    }

    func calAnnualizedSalary(payPeriod: String, salaryType: String,
                             hours: Double, payRateAmount: Double) -> Double {
        var annualizedSalary = 0.0
        
        if salaryType == "Monthly" {
            annualizedSalary = payRateAmount * 12  //annualizedRate.annualizedRateList[].payRate
        }else{
            if payPeriod == "Weekly"{
                annualizedSalary = (hours * payRateAmount) * 52
            }else if payPeriod == "Bi-Weekly"{
                annualizedSalary = (hours * payRateAmount) * 26
            }else if payPeriod == "Bi-Monthly"{
                annualizedSalary = (hours * payRateAmount) * 24
            }else if payPeriod == "Monthly"{
                annualizedSalary = (hours * payRateAmount) * 12
            }
        }
        
        print("Annualized Salary is =", annualizedSalary)
        return annualizedSalary
    }

}
