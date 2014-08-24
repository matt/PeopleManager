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
    lastName: String,
    personalPhoneNumber: String,
    personalEmailAddress: String,
    personalStreetAddress: String,
    personalStreetAddressTwo: String,
    personalSubSubRegion: String,
    personalSubRegion: String,
    personalPostalCode: String,
    personalRegion: String
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
    func firstLetterOfLastName() -> String {
        let firstLetter = lastName.substringToIndex(advance(lastName.startIndex, 1))
        
        return firstLetter.uppercaseString
    }
    
    func personalSubSubRegionSubRegionPostalCode() -> String {
        var pieces = [String]()
    
        if !personalSubSubRegion.isEmpty {
            pieces.append(personalSubSubRegion)
        }
    
        if !personalSubRegion.isEmpty {
            pieces.append(personalSubRegion)
        }
    
        if !personalPostalCode.isEmpty {
            pieces.append(personalPostalCode)
        }
    
        return " ".join(pieces)
    }
}
