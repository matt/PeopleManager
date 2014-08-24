//
//  PersonDetailViewController.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 7/14/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, ManagePersonViewControllerDelegate {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var personalPhone: UILabel!
    @IBOutlet weak var personalEmail: UILabel!
    @IBOutlet weak var personalStreetAddress: UILabel!
    @IBOutlet weak var personalStreetAddressTwo: UILabel!
    @IBOutlet weak var personalSubSubRegionSubRegionPostalCode: UILabel!
    @IBOutlet weak var personalRegion: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var personalStreetAddressTwoHeightConstraint: NSLayoutConstraint!
    
    var person: Person?
    
    let separatorColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)

    init(person: Person) {
        self.person = person
        
        super.init(nibName: "PersonDetailViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector.convertFromStringLiteral("editTapped"))
        navigationItem.rightBarButtonItem = editItem;
        
        photoView.layer.cornerRadius = photoView.bounds.size.width / 2
        photoView.layer.masksToBounds = true
        photoView.layer.borderColor = separatorColor.CGColor
        photoView.layer.borderWidth = 1.0
        
        var phoneUnderlineView = UIView(frame: CGRectMake(16, 127.75, view.frame.size.width - 16, 0.5));
        phoneUnderlineView.backgroundColor = separatorColor
        
        var emailUnderlineView = UIView(frame: CGRectMake(16, 173.75, view.frame.size.width - 16, 0.5));
        emailUnderlineView.backgroundColor = separatorColor
        
        view.addSubview(phoneUnderlineView)
        view.addSubview(emailUnderlineView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if person != nil {
            fullName.text = person!.fullName()
            personalPhone.text = person!.personalPhoneNumber
            personalEmail.text = person!.personalEmailAddress
            personalStreetAddress.text = person!.personalStreetAddress
            personalStreetAddressTwo.text = person!.personalStreetAddressTwo
            personalSubSubRegionSubRegionPostalCode.text = person!.personalSubSubRegionSubRegionPostalCode()
            personalRegion.text = person!.personalRegion
            
            personalStreetAddressTwoHeightConstraint.constant = personalStreetAddressTwo.text.isEmpty ? 0.0 : 25.0
        }
    }
    
    func editTapped() {
        let managePersonViewController = ManagePersonViewController(person: person, delegate: self)
        let navigationController = UINavigationController(rootViewController: managePersonViewController)
        
        presentViewController(navigationController, animated: false, completion: nil)
    }
    
    // MARK: - ManagePersonViewControllerDelegate
    
    func doneManagingPerson(person: Person?) {
        self.person = person
    }
    
    func personDeleted() {
        navigationController.popViewControllerAnimated(true)
    }
}

