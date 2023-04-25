//
//  History+CoreDataProperties.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/25/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var federalTax: Double
    @NSManaged public var salaryAfterTax: Double
    @NSManaged public var stateTax: Double
    @NSManaged public var id: String?
    @NSManaged public var date: Date?

}

extension History : Identifiable {

}
