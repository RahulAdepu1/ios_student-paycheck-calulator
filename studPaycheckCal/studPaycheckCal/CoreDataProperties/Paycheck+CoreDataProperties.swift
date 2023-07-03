//
//  Paycheck+CoreDataProperties.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//
//

import Foundation
import CoreData


extension Paycheck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paycheck> {
        return NSFetchRequest<Paycheck>(entityName: "Paycheck")
    }

    @NSManaged public var date: Date?
    @NSManaged public var maritalStatus: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var w4: String?
    @NSManaged public var payPeriod: String?
    @NSManaged public var payRateAmount: Double
    @NSManaged public var hours: Double
    @NSManaged public var minutes: Double
    @NSManaged public var salaryType: String?
    @NSManaged public var federalTax: Double
    @NSManaged public var stateTax: Double
    @NSManaged public var salaryAfterTax: Double
    @NSManaged public var id: String?
    
    public var unwrappedMaritalStatus: String { maritalStatus ?? "" }
    public var unwrappedCountry: String { country ?? "" }
    public var unwrappedState: String { state ?? "" }
    public var unwrappedW4: String { w4 ?? "" }
    public var unwrappedPayPeriod: String { payPeriod ?? "" }
    public var unwrappedSalaryType: String { salaryType ?? "" }
    public var unwrappedDate: Date {
        let date = date ?? Date()
        return date
    }

}

extension Paycheck : Identifiable {

}
