//
//  HistoryView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    var body: some View {
        TabView{
            historySalaryAfterTax()
            historyFederalTax()
            historyStateTax()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HistoryView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
    }
}

struct historySalaryAfterTax: View {
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    //MARK: View Properties
    @State var currentTab: String = "2023"
    
    var body: some View{
        VStack{
            Spacer()
            Text("Salary After Tax")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 25)
            //MARK: New Chart API
            VStack(alignment: .leading, spacing: 0) {
                let uniqueYears = Array(Set(studentPaycheckCoreDataVM.studentHistoryCoreData.map { Calendar.current.component(.year, from: $0.unwrappedDate) }))
                
                HStack{
                    Text("Salary")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("", selection: $currentTab) {
                        ForEach(uniqueYears, id:\.self) { years in
                            Text(years.stringIntFormat)
                                .tag(years.stringIntFormat)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.leading, 50)
                }
                
                
                // LOGIC FOR CHART
                // Get the Total Salary Amount for Entire Year
                let totalSalary = studentPaycheckCoreDataVM.studentHistoryCoreData.reduce(0.0) { result, item in
                    item.salaryAfterTax + result
                }
                
                // Group by Date
                let groupedData = Dictionary(grouping: studentPaycheckCoreDataVM.studentHistoryCoreData) { historyData -> Date in
                    let components = Calendar.current.dateComponents([.year, .month], from: historyData.unwrappedDate)
                    return Calendar.current.date(from: components)!
                }
                
                // Get current Year
                let currentYear = Calendar.current.dateComponents([.year], from: Date())
                let yearInt = Int(currentTab) ?? currentYear.year
                
                // Get sorted dictionary of salary after tax value by each month for the year choosen on the picker view
                let sortedMonthlyData = groupedData.reduce(into: [Date: Double]()) { result, group in
                    let (date, data) = group
                    let yearComponents = Calendar.current.dateComponents([.year], from: date)
                    if yearComponents.year == yearInt {
                        let monthComponents = Calendar.current.dateComponents([.month], from: date)
                        let monthDate = Calendar.current.date(from: monthComponents)!
                        let sum = data.reduce(0) { $0 + $1.salaryAfterTax }
                        result[monthDate] = sum
                    }
                }.sorted { $0.key < $1.key }
                
                Text(totalSalary.doubleToString1)
                    .font(.largeTitle.bold())
                Text("Total")
                    .font(.caption2)
                    .padding(.bottom, 15)
                Chart{
                    ForEach(sortedMonthlyData, id: \.0) { (date, amount) in
                        // BAR GRAPH
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Salary", amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text(amount == 0.0 ? "" : amount.doubleToString1)
                                .font(.caption)
                        }
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 8)))
            )
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        
        //Simple updating values for segmented tabs
        .onChange(of: currentTab) { newValue in
            
        }
    }
}

struct historyFederalTax: View {
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    //MARK: View Properties
    @State var currentTab: String = "2023"
    
    var body: some View{
        VStack{
            Spacer()
            Text("Federal Tax")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 25)
            //MARK: New Chart API
            VStack(alignment: .leading, spacing: 0) {
                let uniqueYears = Array(Set(studentPaycheckCoreDataVM.studentHistoryCoreData.map { Calendar.current.component(.year, from: $0.unwrappedDate) }))
                
                HStack{
                    Text("Tax")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("", selection: $currentTab) {
                        ForEach(uniqueYears, id:\.self) { years in
                            Text(years.stringIntFormat)
                                .tag(years.stringIntFormat)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.leading, 50)
                }
                
                // LOGIC FOR CHART
                
                // Get the Total Salary Amount for Entire Year
                let totalFedTax = studentPaycheckCoreDataVM.studentHistoryCoreData.reduce(0.0) { result, item in
                    item.federalTax + result
                }
                
                // Group by Date
                let groupedData = Dictionary(grouping: studentPaycheckCoreDataVM.studentHistoryCoreData) { historyData -> Date in
                    let components = Calendar.current.dateComponents([.year, .month], from: historyData.unwrappedDate)
                    return Calendar.current.date(from: components)!
                }
                
                // Get current Year
                let currentYear = Calendar.current.dateComponents([.year], from: Date())
                let yearInt = Int(currentTab) ?? currentYear.year
                
                // Get sorted dictionary of salary after tax value by each month for the year choosen on the picker view
                let sortedMonthlyData = groupedData.reduce(into: [Date: Double]()) { result, group in
                    let (date, data) = group
                    let yearComponents = Calendar.current.dateComponents([.year], from: date)
                    if yearComponents.year == yearInt {
                        let monthComponents = Calendar.current.dateComponents([.month], from: date)
                        let monthDate = Calendar.current.date(from: monthComponents)!
                        let sum = data.reduce(0) { $0 + $1.federalTax }
                        result[monthDate] = sum
                    }
                }.sorted { $0.key < $1.key }
                
                Text(totalFedTax.doubleToString1)
                    .font(.largeTitle.bold())
                Text("Total")
                    .font(.caption2)
                    .padding(.bottom, 15)
                Chart{
                    ForEach(sortedMonthlyData, id: \.0) { (date, amount) in
                        // BAR GRAPH
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Salary", amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text(amount == 0.0 ? "" : amount.doubleToString1)
                                .font(.caption)
                        }
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 8)))
            )
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        
        //Simple updating values for segmented tabs
        .onChange(of: currentTab) { newValue in
            
        }
    }
}

struct historyStateTax: View {
    @EnvironmentObject var studentPaycheckCoreDataVM: StudentPaycheckCoreDataVM
    
    //MARK: View Properties
    @State var currentTab: String = "2023"
    
    var body: some View{
        VStack{
            Spacer()
            Text("State Tax")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 25)
            //MARK: New Chart API
            VStack(alignment: .leading, spacing: 0) {
                let uniqueYears = Array(Set(studentPaycheckCoreDataVM.studentHistoryCoreData.map { Calendar.current.component(.year, from: $0.unwrappedDate) }))
                
                HStack{
                    Text("Tax")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("", selection: $currentTab) {
                        ForEach(uniqueYears, id:\.self) { years in
                            Text(years.stringIntFormat)
                                .tag(years.stringIntFormat)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.leading, 50)
                }
                
                // LOGIC FOR CHART
                // Get the Total Salary Amount for Entire Year
                let totalSalary = studentPaycheckCoreDataVM.studentHistoryCoreData.reduce(0.0) { result, item in
                    item.stateTax + result
                }
                
                // Group by Date
                let groupedData = Dictionary(grouping: studentPaycheckCoreDataVM.studentHistoryCoreData) { historyData -> Date in
                    let components = Calendar.current.dateComponents([.year, .month], from: historyData.unwrappedDate)
                    return Calendar.current.date(from: components)!
                }
                
                // Get current Year
                let currentYear = Calendar.current.dateComponents([.year], from: Date())
                let yearInt = Int(currentTab) ?? currentYear.year
                
                // Get sorted dictionary of salary after tax value by each month for the year choosen on the picker view
                let sortedMonthlyData = groupedData.reduce(into: [Date: Double]()) { result, group in
                    let (date, data) = group
                    let yearComponents = Calendar.current.dateComponents([.year], from: date)
                    if yearComponents.year == yearInt {
                        let monthComponents = Calendar.current.dateComponents([.month], from: date)
                        let monthDate = Calendar.current.date(from: monthComponents)!
                        let sum = data.reduce(0) { $0 + $1.stateTax }
                        result[monthDate] = sum
                    }
                }.sorted { $0.key < $1.key }
                
                Text(totalSalary.doubleToString1)
                    .font(.largeTitle.bold())
                Text("Total")
                    .font(.caption2)
                    .padding(.bottom, 15)
                Chart{
                    ForEach(sortedMonthlyData, id: \.0) { (date, amount) in
                        // BAR GRAPH
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Salary", amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text(amount == 0.0 ? "" : amount.doubleToString1)
                                .font(.caption)
                        }
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 8)))
            )
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        
        //Simple updating values for segmented tabs
        .onChange(of: currentTab) { newValue in
            
        }
    }
}
