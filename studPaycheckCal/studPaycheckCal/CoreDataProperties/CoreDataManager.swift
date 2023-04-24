//
//  CoreDataManager.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/22/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    let containerName: String = "StudentPaycheckDataModel"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved sucessfully")
            } catch let error {
                print("Error saving Core Data. \(error.localizedDescription)")
            }
        }
    }
    
}


class StudentPaycheckCoreDataVM: ObservableObject {
    
    let manager = CoreDataManager.instance
    let studentPayCheckEntity = ""
    
    @Published var studentPayCheckCoreData: [Paycheck] = []
    
    //Seacrh Box and Sort Function for Pantry
    @Published var studentPayCheckSearchText: String = ""
    @Published var studentPayCheckSortOption: StudentPayCheckSortOption = .default
    @Published var studentPayCheckAscending: Bool = true
    enum StudentPayCheckSortOption {
        case `default`  // By Default Sort by date
        case salaryAfterTax
    }
    
    init(){
        whereIsMySQLite()
        fetchStudentPayCheck()
    }
    
    //Find Database Location
    func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        print(path ?? "Not found")
    }
    
//------------------------------------------------------------------------------------------------------------------------
    func fetchStudentPayCheck() {
        let requestStudentPayCheck = NSFetchRequest<Paycheck>(entityName: studentPayCheckEntity)
        requestStudentPayCheck.sortDescriptors = sortStudentPayCheckDescriptor()
        
        // For Search Bar
//        if !studentPayCheckSearchText.isEmpty {
//            requestStudentPayCheck.predicate = NSPredicate(format: "itemName CONTAINS[c] %@", studentPayCheckSearchText)
//        }
        
        // Try to fetch Data
        do {
            studentPayCheckCoreData = try manager.context.fetch(requestStudentPayCheck)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
//------------------------------------------------------------------------------------------------------------------------
    // Sort Function for studentPayCheck
    func sortStudentPayCheckDescriptor() -> [NSSortDescriptor] {
        
        let sortByDate = NSSortDescriptor(keyPath: \Paycheck.date, ascending: studentPayCheckAscending)
        let sortBySalaryAfterTax =  NSSortDescriptor(keyPath: \Paycheck.salaryAfterTax, ascending: studentPayCheckAscending)
        
        switch studentPayCheckSortOption {
        case .default:
            return [sortByDate]
        case .salaryAfterTax:
            return [sortBySalaryAfterTax]
        }
    }
    
    func toggleStudentPayCheckSortOrder() {
        studentPayCheckAscending.toggle()
        fetchStudentPayCheck()
    }
    
    func studentPayCheckSortList(by sortOrder: StudentPayCheckSortOption) {
        if sortOrder == self.studentPayCheckSortOption {
            studentPayCheckAscending.toggle()
        } else {
            self.studentPayCheckSortOption = sortOrder
            studentPayCheckAscending = true
        }
        fetchStudentPayCheck()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    // Add Pantry Items
    func addPantry(country: String, state: String, maritalStatus: String, payPeriod: String, payRateAmount: Double, salaryType: String,
                   w4: String, federalTax: Double, stateTax: Double, salaryAfterTax: Double, hours: Double, minutes: Double) {
        let newPaycheckItems = Paycheck(context: manager.context)
        newPaycheckItems.id = UUID().uuidString
        newPaycheckItems.country = country
        newPaycheckItems.state = state
        newPaycheckItems.maritalStatus = maritalStatus
        newPaycheckItems.payPeriod = payPeriod
        newPaycheckItems.payRateAmount = payRateAmount
        newPaycheckItems.salaryType = salaryType
        newPaycheckItems.w4 = w4
        newPaycheckItems.date = Date()
        newPaycheckItems.federalTax = federalTax
        newPaycheckItems.stateTax = stateTax
        newPaycheckItems.salaryAfterTax = salaryAfterTax
        newPaycheckItems.hours = hours
        newPaycheckItems.minutes = minutes
        save()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    func save() {
        manager.save()
        fetchStudentPayCheck()
    }
}
