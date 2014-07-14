//
//  Person.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 7/14/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import CoreData

class Person: NSManagedObject {
    @NSManaged
    var firstName: String,
    lastName: String
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
    func firstLetterOfLastName() -> String {
        let firstLetter = lastName.substringToIndex(1) as String
        
        return firstLetter.uppercaseString
    }
}
