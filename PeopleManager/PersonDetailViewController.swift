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
    @IBOutlet weak var photoView: UIImageView!
    
    var person: Person?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(person: Person) {
        self.person = person
        
        super.init(nibName: "PersonDetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector.convertFromStringLiteral("editTapped"))
        navigationItem.rightBarButtonItem = editItem;
        
        let separatorColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
        
        photoView.layer.cornerRadius = photoView.bounds.size.width / 2
        photoView.layer.masksToBounds = true
        photoView.layer.borderColor = separatorColor.CGColor
        photoView.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if person != nil {
            fullName.text = person!.fullName()
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

