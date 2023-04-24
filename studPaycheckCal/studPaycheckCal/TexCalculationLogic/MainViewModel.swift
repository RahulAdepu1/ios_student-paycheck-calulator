//
//  MainViewModel.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import Foundation

class StudentPaycheckCalculatorVM: ObservableObject{
    @Published var studentPaycheckCoreDataVM = StudentPaycheckCoreDataVM()
    
    @Published var selectedCountry = "Choose One"
    @Published var selectedState = "Choose One"
    @Published var selectedW4 = "Choose One"
    @Published var selectedMaritalStatus = "Choose One"
    @Published var selectedPayPeriod = "Choose One"
    @Published var selectedPayRateAmount = ""
    @Published var selectedHours = "0"
    @Published var selectedMinutes = "0"
    @Published var selectedSalaryType = "Choose One"
    
    @Published var navToSelfCheck2 = false
    @Published var navToSelfCheckResult = false
    
    //Dictionary for charts
    var salaryAfterTaxDict: [Date: Int] = [Date: Int]()
    var federalTaxDict: [Date: Int] = [Date: Int]()
    var stateTaxDict: [Date: Int] = [Date: Int]()
    
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
    
    //Four things to find
    // 1. Salary Before Tax
    func SalaryBeforeTax() -> Double {
        var salaryBeforeTax = 0.00
        let annualizedSalaryCalulator = AnnualizedSalaryCalculator()
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        salaryBeforeTax = annualizedSalaryCalulator.salaryBeforeTax(salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
        return salaryBeforeTax
    }
    
    // 2. Federal Tax
    func FederalTax() -> Double {
        var federalTax = 0.00
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let federalTaxCalculator = FederalTaxCalculator()
        
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        let annualizedSalary = annualizedSalaryCalculator.calAnnualizedSalary(payPeriod: selectedPayPeriod, salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
        let fedStandardDeduction = federalTaxCalculator.calFedStandardDeduction(nationality: selectedCountry, w4Filled: selectedW4)
        let federalTaxableIncome = federalTaxCalculator.calFederalTaxableIncome(annualizedSalary: annualizedSalary, fedStandardDeduction: fedStandardDeduction)
        let taxBracketAmountList = annualizedSalaryCalculator.calTaxBracket(maritalStatus: selectedMaritalStatus)
        let annualizedFederalTax = federalTaxCalculator.calAnnualizedFederalTax(federalTaxableIncome: federalTaxableIncome, taxBracketAmountList: taxBracketAmountList)
        
        federalTax = federalTaxCalculator.federalTax(annualizedFederalTax: annualizedFederalTax, salaryType: selectedSalaryType)
        return federalTax
    }
    
    // 3. State Tax
    func StateTax() -> Double {
        var stateTax = 0.00
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let stateTaxCalculator = StateTaxCalculator()
        
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        let annualizedSalary = annualizedSalaryCalculator.calAnnualizedSalary(payPeriod: selectedPayPeriod, salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
        let stateStandardDeduction = stateTaxCalculator.calStateStandardDeduction(nationality: selectedCountry, w4Filled: selectedW4)
        let stateTaxableIncome = stateTaxCalculator.calStateTaxableIncome(annualizedSalary: annualizedSalary, stateStandardDeduction: stateStandardDeduction)
        let annualizedStateTax = stateTaxCalculator.calAnnualizedStateTax(state: selectedState, stateTaxableIncome: stateTaxableIncome)
        
        stateTax = stateTaxCalculator.stateTax(annualizedFederalTax: annualizedStateTax, salaryType: selectedSalaryType)
        return stateTax
    }
    
    // 4. Salary After Tax
    func SalaryAfterTax() -> Double {
        var salaryAfterTax = 0.00
        salaryAfterTax = SalaryBeforeTax() - FederalTax() - StateTax()
        return salaryAfterTax
    }
    
    func SaveToCoreData() {
        let doubleSelectedHours = (Double(selectedHours) ?? 0.00)
        let doubleSelectedMinutes = ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        studentPaycheckCoreDataVM.addPantry(country: selectedCountry, state: selectedState, maritalStatus: selectedMaritalStatus, payPeriod: selectedPayPeriod,
                                            payRateAmount: doubleSelectedPayRateAmount, salaryType: selectedSalaryType, w4: selectedW4,
                                            federalTax: FederalTax(), stateTax: StateTax(), salaryAfterTax: SalaryAfterTax(), hours: doubleSelectedHours, minutes: doubleSelectedMinutes)
        
        
    }
    
}
