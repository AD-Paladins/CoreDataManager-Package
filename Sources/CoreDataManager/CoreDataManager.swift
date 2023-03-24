//
//  CoreDataManager.swift
//  
//
//  Created by andres paladines on 3/24/23.
//

import Foundation
import CoreData

open class CoreDataManager {
    
    /**
     *  Data select
     *  Returns an array with the found objects.
     */
    public func listOf<T: NSManagedObject>(
        entity: T.Type,
        multiPredicate: [NSPredicate]? = nil,
        sortDescriptor: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext = CoreDataStack.managedObjectContext
    ) -> NSMutableArray? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        var predicates = [NSPredicate]()
        if(multiPredicate != nil){
            for predic in multiPredicate!{
                predicates.append(predic)
            }
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                // returns mutable copy of result array
                return NSMutableArray.init(array: searchResult)
            } else {
                // returns nil in case no object found
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     * Data Delete
     * Deletion of the found objects.
     */
    public static func deleteObjetcs<T: NSManagedObject>(
        entity: T.Type,
        multiPredicate: [NSPredicate]? = nil,
        sortDescriptor: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext = CoreDataStack.managedObjectContext
    ) -> Bool? {
        var response = false
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        var predicates = [NSPredicate]()
        if let multiPredicate_ = multiPredicate {
            for predic in multiPredicate_ {
                predicates.append(predic)
            }
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                // returns mutable copy of result array
                for object in searchResult {
                    context.delete(object)
                }
                response = true
            }
            do {
                try context.save() // <- remember to put this :)
            } catch {
                return nil
            }
            
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /**
     * SortDecriptor
     * Sorting list
     */
    public static func OrdenarPor(fields: [String], ascending: Bool) -> [NSSortDescriptor] {
        var sorts = [NSSortDescriptor]()
        if(fields.count > 0) {
            for field in fields {
               sorts.append(NSSortDescriptor(key: field, ascending: ascending))
            }
        }
        return sorts
    }
    
    
    /**
     * Predicates
     * Options to make predicates a little easier
     */
    
    public static func newWhere(field: String, contains text: String, caseSensitive: Bool) -> NSPredicate {
        return NSPredicate(
            format: "%K CONTAINS\(caseSensitive ? "[c]" : "" ) %@",
            field, text
        )
    }
    
    public static func newWhere(field: String, is text: String) -> NSPredicate {
        return NSPredicate(format: "%K == %@", field, text)
    }
    
    public static func ignore(in field: String, text: String) -> NSPredicate{
        return NSPredicate(format: "NOT %K BEGINSWITH %@", field, text)
    }
    
    public static func since(hoursAgo: HoursInSeconds) ->NSPredicate {
        //The time interval is made in seconds
        let hoursAgo = Date().addingTimeInterval(-hoursAgo.rawValue)
        return NSPredicate(format: "date > %@", hoursAgo as NSDate)
    }
    
    public static func newWhere(field: String, from: Date, to: Date) -> NSPredicate {
        
        return NSPredicate(
            format: "%K > %@ AND %K < %@",
            field, from as NSDate,
            field, to as NSDate
        )
    }
    
    public static func startsIn(field: String, with text: String) -> NSPredicate {
        return NSPredicate(format: "%K BEGINSWITH %@", field, text)
    }
    
    public static func endsIn(field: String, with text: String) -> NSPredicate {
        return NSPredicate(format: "%K ENDSWITH %@", field, text)
    }
    
    public func matching(field: String, with regExp: String) -> NSPredicate {
        return NSPredicate(format: "%K MATCHES %@", field, regExp)
    }
    
    
    
//    static func adsad() -> NSPredicate{
//        return NSPredicate(format: "name contains[c] %@ AND nickName contains[c] %@", argumentArray: [name, nickname])
//        return NSPredicate(format: "name = %@ AND nickName = %@", argumentArray: [name, nickname])
//    }
    
    
    
}
        
