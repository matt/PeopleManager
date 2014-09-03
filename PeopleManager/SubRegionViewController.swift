//
//  SubRegionViewController.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 8/23/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import UIKit

protocol SubRegionViewControllerDelegate {
    func doneSelectingSubRegion(subRegion: String)
}

class SubRegionViewController: UITableViewController {
    var country: String
    var delegate: SubRegionViewControllerDelegate
    
    lazy var subRegions: [String] = {
        var error: NSError? = nil
        let filePath = NSBundle.mainBundle().pathForResource(self.country, ofType: "json")
        let data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: &error)
        
        let subRegionObjs = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as [AnyObject]!
        
        var subRegions = [String]()
        
        for subRegionObj in subRegionObjs {
            if let subRegionName = subRegionObj["name"] as String! {
                subRegions.append(subRegionName)
            }
        }
        
        return sorted(subRegions, <)
        }()
    
    let cellIdentifier = "subRegionCell"
    
    init(country: String, title: String, delegate: SubRegionViewControllerDelegate) {
        self.country = country
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector.convertFromStringLiteral("cancelTapped"))
        navigationItem.rightBarButtonItem = cancelItem
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subRegions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell!.textLabel!.text = subRegions[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.doneSelectingSubRegion(subRegions[indexPath.row])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}