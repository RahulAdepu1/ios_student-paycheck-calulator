//
//  IncomeCalculatorView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct IncomeCalculatorView: View {
    @State var annualSalary: String = ""
    @State var selectedAnnualSalary: Double = 0.0
    @State var selectedMaritalStatus: String = "Single"
    @State var selectedState: String = "Illinois"
    
    @State var marginalFedTaxRate: Double = 0.0
    @State var effectiveFedTaxRate: Double = 0.0
    @State var fedTaxAmount: Double = 0.0
    @State var marginalStateTaxRate: Double = 0.0
    @State var effectiveStateTaxRate: Double = 0.0
    @State var stateTaxAmount: Double = 0.0
    @State var effectiveTotalTaxRate: Double = 0.0
    @State var totalTaxAmount: Double = 0.0
    @State var incomeAfterTax: Double = 0.0
    
    // App Storage
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            HStack{
                
                VStack{
                    Text("State")
                        .modifier(CustomTextDesign2())
                    Text("IL")
                        .modifier(CustomBlockDesign2())
                }
                
                
                VStack{
                    Text("Annual Salary")
                        .modifier(CustomTextDesign2())
                    TextField("$0.00", value: $annualSalary, formatter: currencyFormatter)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button {
                                    
                                    // Performing All Calculations
                                    selectedAnnualSalary = (Double(annualSalary) ?? 0.0)
                                    calFedTaxAmount()
                                    calIncomeAfterTax()
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } label: {
                                    Text("Done")
                                }
                                Spacer()
                                Button {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                }
                            }
                        }
                        .modifier(CustomBlockDesign())
                }
                
                VStack{
                    Text("Filing Status")
                        .modifier(CustomTextDesign2())
                    Text(selectedMaritalStatus)
                        .modifier(CustomBlockDesign2())
                }
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            
            
            VStack(spacing: 10){
                ColumnTitle()
                FederalTax(marginalFedTaxRate: calMarginalFedTax(),
                           effectiveFedTaxRate: calEffectiveFedTax(),
                           fedTaxAmount: currencyFormatter.string(from: NSNumber(value: fedTaxAmount)) ?? "")
                
                StateTax(marginalStateTaxRate: calMarginalStateTax(),
                         effectiveStateTaxRate: calEffectiveStateTax(),
                         stateTaxAmount: currencyFormatter.string(from: NSNumber(value: calStateTaxAmount())) ?? "")
                
                TotalTax(effectiveTotalTaxRate: calEffectiveTotalTax(),
                         totalTaxAmount: currencyFormatter.string(from: NSNumber(value: calTotalTaxAmount())) ?? "")
                
                IncomeAfterTax(incomeAfterTax: currencyFormatter.string(from: NSNumber(value: incomeAfterTax)) ?? "")
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
        }
    }
    
    // LOGIC
    // Federal Taxes
    func calMarginalFedTax() -> String {
        return "22.00%"
    }
    
    func calEffectiveFedTax() -> String {
        return "9.95%"
    }
    
    func calFedTaxAmount(){
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let federalTaxCalculator = FederalTaxCalculator()

        let fedStandardDeduction = federalTaxCalculator.calFedStandardDeduction(nationality: selectedCountry ?? "",
                                                                                w4Filled: selectedW4Filled ?? "")
        let federalTaxableIncome = federalTaxCalculator.calFederalTaxableIncome(annualizedSalary: Double(selectedAnnualSalary),
                                                                                fedStandardDeduction: fedStandardDeduction)

        let taxBracketAmountList = annualizedSalaryCalculator.calTaxBracket(maritalStatus: selectedMaritalStatus)

        fedTaxAmount = federalTaxCalculator.calAnnualizedFederalTax(federalTaxableIncome: federalTaxableIncome, taxBracketAmountList: taxBracketAmountList)
    }
    
    // State Taxes
    func calMarginalStateTax() -> String {
        return "4.95%"
    }
    
    func calEffectiveStateTax() -> String {
        return "4.75%"
    }
    
    func calStateTaxAmount() -> Double {
        var stateTaxAmount = 0.0
        let stateTaxCalculator = StateTaxCalculator()
        
        let stateStandardDeduction = stateTaxCalculator.calStateStandardDeduction(nationality: selectedCountry ?? "",
                                                                                  w4Filled: selectedW4Filled ?? "")
        
        let stateTaxableIncome = stateTaxCalculator.calStateTaxableIncome(annualizedSalary: Double(selectedAnnualSalary),
                                                                          stateStandardDeduction: stateStandardDeduction)
        
        stateTaxAmount = stateTaxCalculator.calAnnualizedStateTax(state: selectedState,
                                                                          stateTaxableIncome: stateTaxableIncome)
        return stateTaxAmount
    }

    // Total Taxes
    func calEffectiveTotalTax() -> String {
        return "22.35%"
    }
    
    func calTotalTaxAmount() -> Double {
        let totalTaxAmount = fedTaxAmount + calStateTaxAmount()
        return totalTaxAmount
    }
    
    // Income After Taxes
    func calIncomeAfterTax(){
        incomeAfterTax = selectedAnnualSalary - fedTaxAmount - calStateTaxAmount()
    }
}

struct IncomeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCalculatorView()
    }
}

struct ColumnTitle:View {
    var body: some View{
        HStack{
            Text("Tax \nType")
                .modifier(CustomTextDesign2())
            Text("Marginal Tax Rate")
                .modifier(CustomTextDesign2())
            Text("Effective Tax Rate")
                .modifier(CustomTextDesign2())
            Text("Tax \nAmount")
                .modifier(CustomTextDesign2())
        }
    }
}

struct FederalTax: View {
    var marginalFedTaxRate: String
    var effectiveFedTaxRate: String
    var fedTaxAmount: String
    
    var body: some View{
        HStack{
            Text("Federal")
                .modifier(CustomTextDesign3())
            Text(marginalFedTaxRate)
                .modifier(CustomTextDesign3())
            Text(effectiveFedTaxRate)
                .modifier(CustomTextDesign3())
            Text(fedTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

struct StateTax: View {
    var marginalStateTaxRate: String
    var effectiveStateTaxRate: String
    var stateTaxAmount: String
    
    var body: some View{
        HStack{
            Text("State")
                .modifier(CustomTextDesign3())
            Text(marginalStateTaxRate)
                .modifier(CustomTextDesign3())
            Text(effectiveStateTaxRate)
                .modifier(CustomTextDesign3())
            Text(stateTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

struct TotalTax: View {
    var effectiveTotalTaxRate: String
    var totalTaxAmount: String
    
    var body: some View{
        HStack{
            Text("Total")
                .modifier(CustomTextDesign3())
            Text("")
                .modifier(CustomTextDesign3())
            Text(effectiveTotalTaxRate)
                .modifier(CustomTextDesign3())
            Text(totalTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

struct IncomeAfterTax: View {
    var incomeAfterTax: String
    
    var body: some View{
        HStack{
            Text("Income After Tax")
                .modifier(CustomTextDesign3())
            Text("")
                .modifier(CustomTextDesign3())
            Text("")
                .modifier(CustomTextDesign3())
            Text(incomeAfterTax)
                .modifier(CustomTextDesign3())
        }
    }
}
