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
    @Published var selectedPaymentDate = Date()
    @Published var selectedYear = Year.yearList[0].year
    
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
        let annualizedSalaryCalulator = AnnualizedSalaryCalculator()
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        return annualizedSalaryCalulator.salaryBeforeTax(salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
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
        var taxableIncome = 0.0
        let year = Int(selectedYear) ?? 0
        
        let stateTaxCalculator = StateTaxCalculator()
        
        let doubleSelectedTime = (Double(selectedHours) ?? 0.0) + ((Double(selectedMinutes) ?? 0.0)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.0
        
        if selectedSalaryType == "Hourly" {
            taxableIncome = doubleSelectedTime * doubleSelectedPayRateAmount
        }else {
            taxableIncome = doubleSelectedPayRateAmount
        }
        
//        let year = Calendar.current.component(.year, from: selectedPaymentDate)
        stateTax = stateTaxCalculator.stateTaxCal(taxableIncome: taxableIncome, year: year, state: selectedState,
                                       payPeriod: selectedPayPeriod, nationality: selectedCountry, w4Filled: selectedW4)
       
        return stateTax
    }
    
    // 4. Salary After Tax
    func SalaryAfterTax() -> Double {
        return SalaryBeforeTax() - FederalTax() - StateTax()
    }
    
    func SaveToCoreData() {
        let doubleSelectedHours = (Double(selectedHours) ?? 0.00)
        let doubleSelectedMinutes = ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        studentPaycheckCoreDataVM.addPantry(date: selectedPaymentDate, country: selectedCountry, state: selectedState, maritalStatus: selectedMaritalStatus,
                                            payPeriod: selectedPayPeriod,payRateAmount: doubleSelectedPayRateAmount, salaryType: selectedSalaryType, w4: selectedW4,
                                            hours: doubleSelectedHours, minutes: doubleSelectedMinutes,
                                            federalTax: FederalTax(),
                                            stateTax: StateTax(),
                                            salaryAfterTax: SalaryAfterTax())
    }
    
    
    
    
}
