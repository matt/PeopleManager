//
//  PeopleViewController.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 7/14/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import UIKit
import CoreData

class PeopleViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, ManagePersonViewControllerDelegate {
    func fetchedResultsControllerWithSearchString(searchString: String) -> NSFetchedResultsController {
        var fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true, selector: "caseInsensitiveCompare:"),
            NSSortDescriptor(key: "firstName", ascending: true, selector: "caseInsensitiveCompare:")]
        
        var sectionNameKeyPath: String?
        if countElements(searchString) > 0 {
            let predicate = NSPredicate(format: "(firstName CONTAINS[c] %@) OR (lastName CONTAINS[c] %@)", searchString, searchString)
            fetchRequest.predicate = predicate
            sectionNameKeyPath = nil
        } else {
            sectionNameKeyPath = "firstLetterOfLastName"
        }
        
        NSFetchedResultsController.deleteCacheWithName("People")
        
        _fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.sharedStore().managedObjectContext!,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: "People"
        )
        
        _fetchedResultsController!.delegate = self
        
        return _fetchedResultsController!
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController == nil {
            return fetchedResultsControllerWithSearchString("")
        }
            
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func performFetchAndReload(reload: Bool) {
        var error: NSError? = nil
        if !fetchedResultsController.performFetch(&error) {
            println("\(error)")
        }
        
        if reload {
            self.tableView.reloadData()
        }
    }
    
    lazy var searchController: UISearchController = {
        let searchResultsController = UITableViewController()
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self
        
        var searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    let cellIdentifier = "personCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All People"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector.convertFromStringLiteral("addTapped"))
        navigationItem.rightBarButtonItem = addItem;
        
        fetchedResultsControllerWithSearchString("")
        performFetchAndReload(false)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)
        
        definesPresentationContext = true
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let tableViewHeaderFooterView = view as UITableViewHeaderFooterView
        tableViewHeaderFooterView.textLabel.font = UIFont.boldSystemFontOfSize(18)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let person = fetchedResultsController.objectAtIndexPath(indexPath) as Person
        
        configureCell(cell!, person: person)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPerson = fetchedResultsController.objectAtIndexPath(indexPath) as Person
        let personDetailViewController = PersonDetailViewController(person: selectedPerson)
        
        navigationController!.pushViewController(personDetailViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        let tableView = currentTableView()
        
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let tableView = currentTableView()
        
        if type == .Insert {
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        } else if type == .Delete {
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type:NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        let tableView = currentTableView()
        
        if type == .Insert {
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        } else if type == .Update {
            configureCell(tableView.cellForRowAtIndexPath(indexPath)!, person: anObject as Person)
        } else if type == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        let tableView = currentTableView()
        
        tableView.endUpdates()
    }
    
    func currentTableView() -> UITableView {
        var tableView: UITableView
        
        if searchController.active {
            tableView = (searchController.searchResultsController as UITableViewController).tableView
        } else {
            tableView = self.tableView
        }
        
        return tableView
    }
    
    func configureCell(cell: UITableViewCell, person: Person) {
        let fullName = person.fullName()
        var attrFullName = NSMutableAttributedString(string: fullName)
        
        let fullNameLength = countElements(fullName)
        let lastNameLength = countElements(person.lastName)
        let range = NSMakeRange(fullNameLength - lastNameLength, lastNameLength)
        
        attrFullName.beginEditing()
        
        attrFullName.addAttribute(NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(18),
            range: range
        )
        
        attrFullName.endEditing()
        
        cell.textLabel!.attributedText = attrFullName
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        fetchedResultsControllerWithSearchString(searchController.searchBar.text)
        
        if searchController.active {
            performFetchAndReload(searchController.searchBar.text.isEmpty)
            (searchController.searchResultsController as UITableViewController).tableView.reloadData()
        } else {
            performFetchAndReload(true)
        }
    }
    
    // MARK: - ManagePersonViewControllerDelegate
    
    func doneManagingPerson(person: Person?) {
        let personDetailViewController = PersonDetailViewController(person: person!)
        
        navigationController!.pushViewController(personDetailViewController, animated: false)
    }
    
    func personDeleted() {
        // This will never be called
    }
    
    func addTapped() {
        let managePersonViewController = ManagePersonViewController(person: nil, delegate: self)
        let navigationController = UINavigationController(rootViewController: managePersonViewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
