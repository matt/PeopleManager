//
//  DataStore.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 7/14/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import CoreData

class DataStore {
    class func sharedStore() -> DataStore {
        struct Static {
            static var instance: DataStore?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token, {
            Static.instance = DataStore()
        })
        
        return Static.instance!
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.matthewmohrman.PeopleManager" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("PeopleManager", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PeopleManager.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func createPersonWithFirstName(firstName: String, lastName: String, personalPhoneNumber: String, personalEmailAddress: String, personalStreetAddress: String, personalStreetAddressTwo: String, personalSubSubRegion: String, personalSubRegion: String, personalPostalCode: String, personalRegion: String) -> Person? {
        var person: Person?
        
        if let moc = self.managedObjectContext {
            person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as? Person
            
            if person != nil {
                person!.firstName = firstName
                person!.lastName = lastName
                person!.personalPhoneNumber = personalPhoneNumber
                person!.personalEmailAddress = personalEmailAddress
                person!.personalStreetAddress = personalStreetAddress
                person!.personalStreetAddressTwo = personalStreetAddressTwo
                person!.personalSubSubRegion = personalSubSubRegion
                person!.personalSubRegion = personalSubRegion
                person!.personalPostalCode = personalPostalCode
                person!.personalRegion = personalRegion
            }
        }
        
        return person
    }
    
    func deletePerson(person: Person) {
        if let moc = self.managedObjectContext {
            moc.deleteObject(person)
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
            }
        }
    }
    
    deinit {
        saveContext()
    }
}
