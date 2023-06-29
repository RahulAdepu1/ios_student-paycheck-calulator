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
        
//        print("Salary Before Tax is =", salaryBeforeTax)
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
        
//        print("tax Bracket Amount List is =", taxBracketAmountList)
        return taxBracketAmountList
    }

    func calAnnualizedSalary(payDayPeriod: String, currentTotalGross: Double) -> Double {
        var annualizedSalary = 0.0
        
        if payDayPeriod == "Monthly" {
            annualizedSalary = currentTotalGross * 12  //annualizedRate.annualizedRateList[].payRate
        }else if payDayPeriod == "Bi-Monthly"{
            annualizedSalary = currentTotalGross * 24
        }
        
//        print("Annualized Salary is =", annualizedSalary)
        return annualizedSalary
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
        
//        print("Annualized Salary is =", annualizedSalary)
        return annualizedSalary
    }

}

struct FederalTaxBracketListByYear {
    let year: Int
    let maritalStatus: String
    let taxBracketList: [Double]
    
    static let federalTaxBracketListData = [
        
        // For 2023
        FederalTaxBracketListByYear(year: 2023, maritalStatus: "Choose One",
                                    taxBracketList: [0.0, 11000.0, 44725.0, 95375.0, 182100.0, 231250.0, 578125.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2023, maritalStatus: "Single",
                                    taxBracketList: [0.0, 11000.0, 44725.0, 95375.0, 182100.0, 231250.0, 578125.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2023, maritalStatus: "Married filling separate",
                                    taxBracketList: [0.0, 11000.0, 44725.0, 95375.0, 182100.0, 231250.0, 346875.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2023, maritalStatus: "Married filling together",
                                    taxBracketList: [0.0, 22000.0, 89450.0, 190750.0, 364200.0, 462500.0, 693750.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2023, maritalStatus: "Head of Household",
                                    taxBracketList: [0.0, 15700.0, 59850.0, 95350.0, 182100.0, 231250.0, 578100.0, 99999999999999999999.0]),
        
        // For 2022
        FederalTaxBracketListByYear(year: 2022, maritalStatus: "Choose One",
                                    taxBracketList: [0.0, 10275.0, 41775.0, 89075.0, 170050.0, 215950.0, 539900.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2022, maritalStatus: "Single",
                                    taxBracketList: [0.0, 10275.0, 41775.0, 89075.0, 170050.0, 215950.0, 539900.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2022, maritalStatus: "Married filling separate",
                                    taxBracketList: [0.0, 10275.0, 41775.0, 89075.0, 170050.0, 215950.0, 539900.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2022, maritalStatus: "Married filling together",
                                    taxBracketList: [0.0, 20550.0, 83550.0, 178150.0, 340100.0, 431900.0, 647850.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2022, maritalStatus: "Head of Household",
                                    taxBracketList: [0.0, 14650.0, 55900.0, 89050.0, 170050.0, 215950.0, 539900.0, 99999999999999999999.0]),
        
        // For 2021
        FederalTaxBracketListByYear(year: 2021, maritalStatus: "Choose One",
                                    taxBracketList: [0.0, 9950.0, 40525.0, 86375.0, 164925.0, 209425.0, 523600.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2021, maritalStatus: "Single",
                                    taxBracketList: [0.0, 9950.0, 40525.0, 86375.0, 164925.0, 209425.0, 523600.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2021, maritalStatus: "Married filling separate",
                                    taxBracketList: [0.0, 9950.0, 40525.0, 86375.0, 164925.0, 209425.0, 523600.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2021, maritalStatus: "Married filling together",
                                    taxBracketList: [0.0, 19900.0, 81050.0, 172750.0, 329850.0, 418850.0, 628300.0, 99999999999999999999.0]),
        FederalTaxBracketListByYear(year: 2021, maritalStatus: "Head of Household",
                                    taxBracketList: [0.0, 14200.0, 54200.0, 86350.0, 164900.0, 209400.0, 523600.0, 99999999999999999999.0])
    ]
}
