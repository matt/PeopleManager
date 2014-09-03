//
//  RegionViewController.swift
//  PeopleManager
//
//  Created by Matthew Mohrman on 8/22/14.
//  Copyright (c) 2014 Matthew Mohrman. All rights reserved.
//

import UIKit

protocol RegionViewControllerDelegate {
    func doneSelectingRegion(region: String)
}

class RegionViewController: UITableViewController {
    var delegate: RegionViewControllerDelegate
    
    let regions: [String] = {
        var error: NSError? = nil
        let filePath = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
        let data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: &error)
        
        let regionObjs = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as [String: [String: String]]!
        
        var regions = [String]()
        
        for (regionName, _) in regionObjs {
            regions.append(regionName)
        }
        
        return sorted(regions, <)
    }()
    
    let cellIdentifier = "regionCell"
    
    init(delegate: RegionViewControllerDelegate) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country"
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector.convertFromStringLiteral("cancelTapped"))
        navigationItem.rightBarButtonItem = cancelItem
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell!.textLabel!.text = regions[indexPath.row]
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.doneSelectingRegion(regions[indexPath.row])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}