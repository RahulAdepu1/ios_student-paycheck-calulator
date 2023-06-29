//
//  EffectiveTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/27/23.
//

import SwiftUI

protocol EffectiveTaxCalProtocol {
    var allValuesAdded: Bool { get }
}

class EffectiveTaxCalculator: ObservableObject {
    
    @Published var currentTotalGross:String = "---"
    @Published var currentNetPay:String = "---"
    @Published var currentTotalTax:String = "---"
    @Published var currentState:String = "Choose One"
    @Published var currentMaritalStatus:String = "Choose One"
    @Published var payGroup:String = "Choose One"
    @Published var payYear:String = "Choose One"
    
    func annualSalary() -> Double {
        var annualSalary = 0.0
        
        if currentTotalGross != "---"{
//            print("Current Total Gross -",currentTotalGross.stringToDouble)
            
            if payGroup == "Annually"{
                annualSalary = currentTotalGross.stringToDouble * 1
            }else if payGroup == "Monthly"{
                annualSalary = currentTotalGross.stringToDouble * 12
            }else if payGroup == "Bi-Monthly"{
                annualSalary = currentTotalGross.stringToDouble * 24
            }else if payGroup == "Bi-Weekly"{
                annualSalary = currentTotalGross.stringToDouble * 26
            }else if payGroup == "Weekly"{
                annualSalary = currentTotalGross.stringToDouble * 52
            }
        }
        
        return annualSalary
    }
    
    func calculateFedTax_TaxCal() -> [Double] {
        var marginalFederalTaxRate = 0.0
        var effectiveFederalTaxRate = 0.0
        
        let federalTaxCalculator = FederalTaxCalculator()
        
        if (annualSalary() != 0.0){
            let federalTaxOutput = federalTaxCalculator.calculateFederalTax(totalSalary: annualSalary(),
                                                                            year: payYear.stringToIntYear,
                                                                            selectedMaritalStatus: currentMaritalStatus )
            marginalFederalTaxRate = federalTaxOutput[1]
            effectiveFederalTaxRate = federalTaxOutput[2]
        }
        
        return [marginalFederalTaxRate, effectiveFederalTaxRate]
    }
    
    func calculateStateTax_TaxCal() -> [Double] {
        var marginalStateTaxRate = 0.0
        var effectiveStateTaxRate = 0.0
        
        let stateTaxCalculator = StateTaxCalculator()
        
        if (annualSalary() != 0.0){
            let stateTaxOutput = stateTaxCalculator.calculateStateTax(totalSalary: annualSalary(),
                                                                      year: payYear.stringToIntYear,
                                                                      state: currentState)
            marginalStateTaxRate = stateTaxOutput[1]
            effectiveStateTaxRate = stateTaxOutput[2]
        }
        
        return [marginalStateTaxRate, effectiveStateTaxRate]
    }
    
    func calculateTotalTax_TaxCal() -> Double {
        var effectiveTotalTaxRate = 0.0
        
        if (currentTotalTax != "---" && currentTotalGross != "---") {
            effectiveTotalTaxRate = (currentTotalTax.stringToDouble / currentTotalGross.stringToDouble) * 100
        }
        return effectiveTotalTaxRate
    }
    
    func federalTax_TaxCal() -> Double {
        let federalTax = currentTotalGross.stringToDouble * calculateFedTax_TaxCal()[1]
        return federalTax
    }
    
    func stateTax_TaxCal() -> Double {
        let stateTax = currentTotalGross.stringToDouble * calculateStateTax_TaxCal()[1]
        return stateTax
    }
    
}
