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

class ManagePersonViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var personalPhoneNumber: UITextField!
    @IBOutlet weak var personalEmailAddress: UITextField!
    @IBOutlet weak var personalStreetAddress: UITextField!
    @IBOutlet weak var personalStreetAddressTwo: UITextField!
    @IBOutlet weak var personalCity: UITextField!
    @IBOutlet weak var personalState: UITextField!
    @IBOutlet weak var personalPostalCode: UITextField!
    @IBOutlet weak var personalCountry: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!

    var person: Person?
    var delegate: ManagePersonViewControllerDelegate?
    
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
        
        firstName.text = person?.firstName
        lastName.text = person?.lastName
        personalPhoneNumber.text = person?.personalPhoneNumber
        personalEmailAddress.text = person?.personalEmailAddress
        personalStreetAddress.text = person?.personalStreetAddress
        personalStreetAddressTwo.text = person?.personalStreetAddressTwo
        personalCity.text = person?.personalCity
        personalState.text = person?.personalState
        personalPostalCode.text = person?.personalPostalCode
        personalCountry.text = person?.personalCountry
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var firstNameUnderlineView = UIView(frame: CGRectMake(92, 45.75, view.frame.size.width - 92, 0.5))
        firstNameUnderlineView.backgroundColor = separatorColor
        
        var lastNameUnderlineView = UIView(frame: CGRectMake(92, 91.75, view.frame.size.width - 92, 0.5))
        lastNameUnderlineView.backgroundColor = separatorColor
        
        var phoneUnderlineView = UIView(frame: CGRectMake(16, 137.75, view.frame.size.width - 16, 0.5))
        phoneUnderlineView.backgroundColor = separatorColor
        
        var emailUnderlineView = UIView(frame: CGRectMake(16, 183.75, view.frame.size.width - 16, 0.5))
        emailUnderlineView.backgroundColor = separatorColor
        
        var streetUnderlineView = UIView(frame: CGRectMake(16, 229.75, view.frame.size.width - 16, 0.5))
        streetUnderlineView.backgroundColor = separatorColor
        
        var streetTwoUnderlineView = UIView(frame: CGRectMake(16, 275.75, view.frame.size.width - 16, 0.5))
        streetTwoUnderlineView.backgroundColor = separatorColor
        
        var cityUnderlineView = UIView(frame: CGRectMake(16, 321.75, view.frame.size.width - 16, 0.5))
        cityUnderlineView.backgroundColor = separatorColor
        
        var stateUnderlineView = UIView(frame: CGRectMake(16, 367.75, view.frame.size.width / 2 - 16, 0.5))
        stateUnderlineView.backgroundColor = separatorColor
        
        var zipUnderlineView = UIView(frame: CGRectMake(view.frame.size.width / 2 + 16, 367.75, view.frame.size.width / 2 - 16, 0.5))
        zipUnderlineView.backgroundColor = separatorColor
        
        var countryUnderlineView = UIView(frame: CGRectMake(16, 413.75, view.frame.size.width - 16, 0.5));
        countryUnderlineView.backgroundColor = separatorColor
        
        view.addSubview(firstNameUnderlineView)
        view.addSubview(lastNameUnderlineView)
        view.addSubview(phoneUnderlineView)
        view.addSubview(emailUnderlineView)
        view.addSubview(streetUnderlineView)
        view.addSubview(streetTwoUnderlineView)
        view.addSubview(cityUnderlineView)
        view.addSubview(stateUnderlineView)
        view.addSubview(zipUnderlineView)
        view.addSubview(countryUnderlineView)
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
            person!.personalCity = personalCity.text
            person!.personalState = personalState.text
            person!.personalPostalCode = personalPostalCode.text
            person!.personalCountry = personalCountry.text
        } else {
            person = DataStore.sharedStore().createPersonWithFirstName(firstName.text,
                lastName: lastName.text,
                personalPhoneNumber: personalPhoneNumber.text,
                personalEmailAddress: personalEmailAddress.text,
                personalStreetAddress: personalStreetAddress.text,
                personalStreetAddressTwo: personalStreetAddressTwo.text,
                personalCity: personalCity.text,
                personalState: personalState.text,
                personalPostalCode: personalPostalCode.text,
                personalCountry: personalCountry.text
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
                            person!.personalCity != personalCity.text ||
                            person!.personalState != personalState.text ||
                            person!.personalPostalCode != personalPostalCode.text ||
                            person!.personalCountry != personalCountry.text
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField == firstName) {
            lastName.becomeFirstResponder()
        } else {
            firstName.becomeFirstResponder()
        }
        
        return true;
    }
}
