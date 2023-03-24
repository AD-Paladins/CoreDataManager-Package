# CoreDataManager

A description of this package.

Usage:

```swift
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Add Predicate
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "name = someName"))
        
        let dataValuess = CoreDataManager.listOf(entity: Usuario.self, multiPredicate: predicates, sortDescriptor: [sortDescriptor])
        
        for data in dataValuess as! [NSManagedObject] {
            print(data.value(forKey: "property") ?? "FETCH GENERICO SINDATOS")
        }

```
