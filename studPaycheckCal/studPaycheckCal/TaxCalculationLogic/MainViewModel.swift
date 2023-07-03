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
    @Published var selectedYear = Year.yearList[1].year
    
    @Published var navToSelfCheck2 = false
    @Published var navToSelfCheckResult = false
    
    //Dictionary for charts
    var salaryAfterTaxDict: [Date: Int] = [Date: Int]()
    var federalTaxDict: [Date: Int] = [Date: Int]()
    var stateTaxDict: [Date: Int] = [Date: Int]()
    
    var canNavToSelfCheckResult: Bool {
        return selectedPayPeriod != "Choose One"
        && selectedPayRateAmount != ""
        && selectedHours != "0"
        && selectedSalaryType != "Choose One"
    }
    
    //Four things to find
    // 1. Salary Before Tax
    func SalaryBeforeTax() -> Double {
        let annualizedSalaryCalulator = AnnualizedSalaryCalculator()
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
//        print(annualizedSalaryCalulator.salaryBeforeTax(salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount))
        return annualizedSalaryCalulator.salaryBeforeTax(salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
    }
    
    // 2. Federal Tax
    func FederalTax() -> Double {
        var federalTax = 0.00
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let federalTaxCalculator = FederalTaxCalculator()
        
        let doubleSelectedTime = (Double(selectedHours) ?? 0.00) + ((Double(selectedMinutes) ?? 0.00)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
//        print("doubleSelectedPayRateAmount",doubleSelectedPayRateAmount)
        if doubleSelectedPayRateAmount > 0 {
            let annualizedSalary = annualizedSalaryCalculator.calAnnualizedSalary(payPeriod: selectedPayPeriod, salaryType: selectedSalaryType, hours: doubleSelectedTime, payRateAmount: doubleSelectedPayRateAmount)
//            print("annualizedSalary-\(annualizedSalary)")
            let fedStandardDeduction = FederalStdDedByYear.federalData.filter { $0.year == Int(selectedYear) }[0].standardDeduction
//            print("fedStandardDeduction-\(fedStandardDeduction)")
            let federalTaxableIncome = federalTaxCalculator.calFederalTaxableIncome(annualizedSalary: annualizedSalary, fedStandardDeduction: fedStandardDeduction)
//            print("federalTaxableIncome=\(federalTaxableIncome)")
            let taxBracketAmountList = annualizedSalaryCalculator.calTaxBracket(maritalStatus: selectedMaritalStatus)
//            print("taxBracketAmountList=\(taxBracketAmountList)")
            let annualizedFederalTax = federalTaxCalculator.calAnnualizedFederalTax(federalTaxableIncome: federalTaxableIncome, taxBracketAmountList: taxBracketAmountList)
//            print("annualizedFederalTax-\(annualizedFederalTax)")
            federalTax = federalTaxCalculator.federalTax(annualizedFederalTax: annualizedFederalTax, salaryType: selectedSalaryType)
//            print("federalTax-\(federalTax)")
        }
        return federalTax
    }
    
    // 3. State Tax
    func StateTax() -> Double {
        var stateTax = 0.00
        var taxableIncome = 0.0
        let year = Int(selectedYear) ?? Calendar.current.component(.year, from: Date())
        
        let stateTaxCalculator = StateTaxCalculator()
        
        let doubleSelectedTime = (Double(selectedHours) ?? 0.0) + ((Double(selectedMinutes) ?? 0.0)/60)
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.0
        
        if doubleSelectedPayRateAmount > 0 {
            if selectedSalaryType == "Hourly" {
                taxableIncome = doubleSelectedTime * doubleSelectedPayRateAmount
            }else {
                taxableIncome = doubleSelectedPayRateAmount
            }
            stateTax = stateTaxCalculator.stateTaxCal(taxableIncome: taxableIncome, year: year, state: selectedState,
                                           payPeriod: selectedPayPeriod, nationality: selectedCountry, w4Filled: selectedW4)
        }
        
        return stateTax
    }
    
    // 4. Salary After Tax
    func SalaryAfterTax() -> Double {
        return SalaryBeforeTax() - FederalTax() - StateTax()
    }
    
    func SaveToCoreData(date: Date, selectedPayPeriod: String = "", selectedSalaryType: String = "", federalTax: Double = 0.0, stateTax: Double = 0.0, salaryAfterTax: Double = 0.0) {
        let doubleSelectedHours = (Double(selectedHours) ?? 0.00)
        let doubleSelectedMinutes = ((Double(selectedMinutes) ?? 0.00))
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        studentPaycheckCoreDataVM.addPaycheck(date: date,
                                              country: selectedCountry,
                                              state: selectedState,
                                              maritalStatus: selectedMaritalStatus,
                                              payPeriod: selectedPayPeriod,
                                              payRateAmount: doubleSelectedPayRateAmount,
                                              salaryType: selectedSalaryType,
                                              w4: selectedW4,
                                              hours: doubleSelectedHours, minutes: doubleSelectedMinutes,
                                              federalTax: federalTax,
                                              stateTax: stateTax,
                                              salaryAfterTax: salaryAfterTax)
    }
}
