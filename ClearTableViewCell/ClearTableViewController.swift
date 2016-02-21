//
//  ClearTableViewController.swift
//  ClearTableViewCell
//
//  Created by Allen on 16/1/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ClearTableViewController: UITableViewController {
    
    var tableData = ["Ann 12000", "Frank 11000", "Jamie 10000", "Angela (you), 9999", "Holly 9000", "Andrew 8000", "Nick 3000"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If logged in
        if let token = FBSDKAccessToken.currentAccessToken() {
            
            
            
        } else {
            // Present login view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            
            loginVC.modalPresentationStyle = .FullScreen
            loginVC.modalTransitionStyle = .CoverVertical
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
//        self.tableView.reloadData()
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        self.view.backgroundColor = UIColor.blackColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called")
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    func colorforIndex(index: Int) -> UIColor {
        
        let itemCount = tableData.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }
    
}
