//
//  SettingsViewController.swift
//  ClearTableViewCell
//
//  Created by Haemin Park on 2/20/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logoutPressed(sender: AnyObject) {

        let manager = FBSDKLoginManager()
        manager.logOut()
        
        // Present login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        
        loginVC.modalPresentationStyle = .FullScreen
        loginVC.modalTransitionStyle = .CoverVertical
        self.presentViewController(loginVC, animated: true, completion: nil)
        
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
