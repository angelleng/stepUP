//
//  FirstViewController.swift
//  stepUP
//
//  Created by Jing LENG on 2/20/16.
//  Copyright (c) 2016 Jing LENG. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifer = "NewCellIdentifier"
    
    let friends_ranking = ["Amy", "Brian", "Charlie",]
    let newFriends_rankng = ["David", "Emily", "Fiona", "George", "Haemin"]
    
    var friendsData = [String]()
    var tableViewController = UITableViewController(style: .Plain)
    
    var refreshControl = UIRefreshControl()
    var navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 375, height: 64))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsData = friends_ranking
        
        let friendsTableView = tableViewController.tableView
        friendsTableView.backgroundColor = UIColor(red:0.092, green:0.096, blue:0.116, alpha:1)
        friendsTableView.dataSource = self
        friendsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
        tableViewController.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "didRoadEmoji", forControlEvents: .ValueChanged)
        
        self.refreshControl.backgroundColor = UIColor(red:0.113, green:0.113, blue:0.145, alpha:1)
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())", attributes: attributes)
        self.refreshControl.tintColor = UIColor.whiteColor()
        
        self.title = "Daily"
        self.navBar.barStyle = UIBarStyle.BlackTranslucent
        
        friendsTableView.rowHeight = UITableViewAutomaticDimension
        friendsTableView.estimatedRowHeight = 60.0
        friendsTableView.tableFooterView = UIView(frame: CGRectZero)
        friendsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        self.view.addSubview(friendsTableView)
        self.view.addSubview(navBar)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer)! as UITableViewCell
        
        cell.textLabel!.text = self.friendsData[indexPath.row]
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.font = UIFont.systemFontOfSize(20)
        cell.backgroundColor = UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    
    //RoadEmoji
    
    func didRoadEmoji() {
        self.friendsData = newFriends_rankng
        self.tableViewController.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

