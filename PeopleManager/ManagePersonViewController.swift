//
//  ManagePersonViewController.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 7/14/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import UIKit

protocol ManagePersonViewControllerDelegate {
    func doneManagingPerson(person: Person?)
    func personDeleted()
}

class ManagePersonViewController: UIViewController, UITextFieldDelegate, SubRegionViewControllerDelegate, RegionViewControllerDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var personalPhoneNumber: UITextField!
    @IBOutlet weak var personalEmailAddress: UITextField!
    @IBOutlet weak var personalStreetAddress: UITextField!
    @IBOutlet weak var personalStreetAddressTwo: UITextField!
    @IBOutlet weak var personalSubSubRegion: UITextField!
    @IBOutlet weak var personalSubRegion: UITextField!
    @IBOutlet weak var personalPostalCode: UITextField!
    @IBOutlet weak var personalRegion: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!

    var person: Person?
    var delegate: ManagePersonViewControllerDelegate?
    
    let regionTerminologyMapping: [String: [String: String]] = {
        var error: NSError? = nil
        let filePath = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
        let data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: &error)
        
        let regionObjs = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as [String: [String: String]]!
        
        return regionObjs
        }()
    
    let separatorColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
    
    init(person: Person?, delegate: ManagePersonViewControllerDelegate?) {
        self.person = person
        self.delegate = delegate
        
        super.init(nibName: "ManagePersonViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        if person != nil {
            toolbar.hidden = false
        } else {
            title = "New Person"
        }
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector.convertFromStringLiteral("cancelTapped"))
        navigationItem.leftBarButtonItem = cancelItem;
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector.convertFromStringLiteral("doneTapped"))
        navigationItem.rightBarButtonItem = doneItem;
        navigationItem.rightBarButtonItem.enabled = false;
        
        photoView.layer.cornerRadius = photoView.bounds.size.width / 2
        photoView.layer.masksToBounds = true
        photoView.layer.borderColor = separatorColor.CGColor
        photoView.layer.borderWidth = 1.0
        
        firstName.delegate = self
        lastName.delegate = self
        personalPhoneNumber.delegate = self
        personalEmailAddress.delegate = self
        personalStreetAddress.delegate = self
        personalStreetAddressTwo.delegate = self
        personalSubSubRegion.delegate = self
        personalSubRegion.delegate = self
        personalPostalCode.delegate = self
        personalRegion.delegate = self
        
        firstName.text = person?.firstName
        lastName.text = person?.lastName
        personalPhoneNumber.text = person?.personalPhoneNumber
        personalEmailAddress.text = person?.personalEmailAddress
        personalStreetAddress.text = person?.personalStreetAddress
        personalStreetAddressTwo.text = person?.personalStreetAddressTwo
        personalSubSubRegion.text = person?.personalSubSubRegion
        personalSubRegion.text = person?.personalSubRegion
        personalPostalCode.text = person?.personalPostalCode
        personalRegion.text = person?.personalRegion
        
        if personalRegion.text.isEmpty {
            personalRegion.text = "United States"
        } else {
            personalSubSubRegion.placeholder = regionTerminologyMapping[personalRegion.text]!["subSubRegionName"]
            personalSubRegion.placeholder = regionTerminologyMapping[personalRegion.text]!["subRegionName"]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var firstNameUnderlineView = UIView(frame: CGRectMake(92, 45.75, view.frame.size.width - 92, 0.5))
        firstNameUnderlineView.backgroundColor = separatorColor
        
        var lastNameUnderlineView = UIView(frame: CGRectMake(92, 91.75, view.frame.size.width - 92, 0.5))
        lastNameUnderlineView.backgroundColor = separatorColor
        
        var phoneUnderlineView = UIView(frame: CGRectMake(16, 153.75, view.frame.size.width - 16, 0.5))
        phoneUnderlineView.backgroundColor = separatorColor
        
        var emailUnderlineView = UIView(frame: CGRectMake(16, 199.75, view.frame.size.width - 16, 0.5))
        emailUnderlineView.backgroundColor = separatorColor
        
        var streetUnderlineView = UIView(frame: CGRectMake(16, 261.75, view.frame.size.width - 16, 0.5))
        streetUnderlineView.backgroundColor = separatorColor
        
        var streetTwoUnderlineView = UIView(frame: CGRectMake(16, 307.75, view.frame.size.width - 16, 0.5))
        streetTwoUnderlineView.backgroundColor = separatorColor
        
        var cityUnderlineView = UIView(frame: CGRectMake(16, 353.75, view.frame.size.width - 16, 0.5))
        cityUnderlineView.backgroundColor = separatorColor
        
        var subRegionUnderlineView = UIView(frame: CGRectMake(16, 399.75, view.frame.size.width / 2 - 16, 0.5))
        subRegionUnderlineView.backgroundColor = separatorColor
        
        var postalUnderlineView = UIView(frame: CGRectMake(view.frame.size.width / 2 + 16, 399.75, view.frame.size.width / 2 - 16, 0.5))
        postalUnderlineView.backgroundColor = separatorColor
        
        var regionUnderlineView = UIView(frame: CGRectMake(16, 445.75, view.frame.size.width - 16, 0.5));
        regionUnderlineView.backgroundColor = separatorColor
        
        view.addSubview(firstNameUnderlineView)
        view.addSubview(lastNameUnderlineView)
        view.addSubview(phoneUnderlineView)
        view.addSubview(emailUnderlineView)
        view.addSubview(streetUnderlineView)
        view.addSubview(streetTwoUnderlineView)
        view.addSubview(cityUnderlineView)
        view.addSubview(subRegionUnderlineView)
        view.addSubview(postalUnderlineView)
        view.addSubview(regionUnderlineView)
    }
    
    func cancelTapped() {
        dismissViewControllerAnimated(self.person == nil, completion: nil)
    }
    
    func doneTapped() {
        var animated = false
        
        if person != nil {
            person!.firstName = firstName.text
            person!.lastName = lastName.text
            person!.personalPhoneNumber = personalPhoneNumber.text
            person!.personalEmailAddress = personalEmailAddress.text
            person!.personalStreetAddress = personalStreetAddress.text
            person!.personalStreetAddressTwo = personalStreetAddressTwo.text
            person!.personalSubSubRegion = personalSubSubRegion.text
            person!.personalSubRegion = personalSubRegion.text
            person!.personalPostalCode = personalPostalCode.text
            person!.personalRegion = personalRegion.text
        } else {
            person = DataStore.sharedStore().createPersonWithFirstName(firstName.text,
                lastName: lastName.text,
                personalPhoneNumber: personalPhoneNumber.text,
                personalEmailAddress: personalEmailAddress.text,
                personalStreetAddress: personalStreetAddress.text,
                personalStreetAddressTwo: personalStreetAddressTwo.text,
                personalSubSubRegion: personalSubSubRegion.text,
                personalSubRegion: personalSubRegion.text,
                personalPostalCode: personalPostalCode.text,
                personalRegion: personalRegion.text
            )
            animated = true
        }
        
        delegate?.doneManagingPerson(person)
        
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
    @IBAction func updateDoneButton(sender: AnyObject) {
        let emptyNameField = firstName.text.isEmpty || lastName.text.isEmpty
        var modifiedField = true
        
        if person != nil {
            modifiedField = person!.firstName != firstName.text ||
                            person!.lastName != lastName.text ||
                            person!.personalPhoneNumber != personalPhoneNumber.text ||
                            person!.personalEmailAddress != personalEmailAddress.text ||
                            person!.personalStreetAddress != personalStreetAddress.text ||
                            person!.personalStreetAddressTwo != personalStreetAddressTwo.text ||
                            person!.personalSubSubRegion != personalSubSubRegion.text ||
                            person!.personalSubRegion != personalSubRegion.text ||
                            person!.personalPostalCode != personalPostalCode.text ||
                            person!.personalRegion != personalRegion.text
        }
        
        navigationItem.rightBarButtonItem.enabled = !emptyNameField && modifiedField
    }
    
    @IBAction func deleteTapped(sender: AnyObject) {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete Person", style: .Destructive, handler: { action in
            DataStore.sharedStore().deletePerson(self.person!)
            
            self.delegate?.doneManagingPerson(nil)
            
            self.dismissViewControllerAnimated(false, completion: {
                if let delegate = self.delegate {
                    self.delegate?.personDeleted()
                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
        if textField == personalSubRegion {
            let subRegionViewController = SubRegionViewController(country: personalRegion.text, title: personalSubRegion.placeholder, delegate: self)
            let navigationController = UINavigationController(rootViewController: subRegionViewController)
            
            presentViewController(navigationController, animated: true, completion: nil)
            
            return false;
        } else if textField == personalRegion {
            let regionViewController = RegionViewController(delegate: self)
            let navigationController = UINavigationController(rootViewController: regionViewController)
            
            presentViewController(navigationController, animated: true, completion: nil)
            
            return false;
        }
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == firstName {
            lastName.becomeFirstResponder()
        } else {
            firstName.becomeFirstResponder()
        }
        
        return true;
    }
    
    // MARK: - SubRegionViewControllerDelegate
    
    func doneSelectingSubRegion(subRegion: String) {
        if personalSubRegion.text != subRegion {
            personalSubRegion.text = subRegion
            
            updateDoneButton(personalSubRegion)
        }
    }
    
    // MARK: - RegionViewControllerDelegate
    
    func doneSelectingRegion(region: String) {
        if personalRegion.text != region {
            personalRegion.text = region
            personalSubSubRegion.placeholder = regionTerminologyMapping[region]!["subSubRegionName"]
            personalSubRegion.placeholder = regionTerminologyMapping[region]!["subRegionName"]
            personalSubRegion.text = ""
            personalPostalCode.placeholder = regionTerminologyMapping[region]!["postalCodeName"]
            personalPostalCode.text = ""
            
            updateDoneButton(personalRegion)
        }
    }
}
