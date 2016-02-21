//
//  DashboardViewController.swift
//  ClearTableViewCell
//
//  Created by Jing LENG on 2/20/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import HealthKit

class DashboardViewController: UIViewController {

    var healthStore: HKHealthStore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard" 

        UIApplication.sharedApplication().statusBarHidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
