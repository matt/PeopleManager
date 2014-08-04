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
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!

    var person: Person?
    var delegate: ManagePersonViewControllerDelegate?
    
    let separatorColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(person: Person?, delegate: ManagePersonViewControllerDelegate?) {
        self.person = person
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var firstNameUnderlineView = UIView(frame: CGRectMake(92, 45.75, view.frame.size.width - 92, 0.5))
        firstNameUnderlineView.backgroundColor = separatorColor
        
        var lastNameUnderlineView = UIView(frame: CGRectMake(92, 91.75, view.frame.size.width - 92, 0.5))
        lastNameUnderlineView.backgroundColor = separatorColor
        NSLog("\(view.frame)")
        view.addSubview(firstNameUnderlineView)
        view.addSubview(lastNameUnderlineView)
    }
    
    func cancelTapped() {
        dismissViewControllerAnimated(self.person == nil, completion: nil)
    }
    
    func doneTapped() {
        var animated = false
        
        if person != nil {
            person!.firstName = firstName.text
            person!.lastName = lastName.text
        } else {
            person = DataStore.sharedStore().createPersonWithFirstName(firstName.text, lastName: lastName.text)
            animated = true
        }
        
        delegate?.doneManagingPerson(person)
        
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
    @IBAction func updateDoneButton(sender: AnyObject) {
        let emptyNameField = firstName.text.isEmpty || lastName.text.isEmpty
        var modifiedName = person != nil ? person!.firstName != firstName.text || person!.lastName != lastName.text : true
        
        navigationItem.rightBarButtonItem.enabled = !emptyNameField && modifiedName
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
