//
//  ClearTableViewController.swift
//  ClearTableViewCell
//
//  Created by Allen on 16/1/17.
//  Copyright © 2016年 Allen. All rights reserved.
//


import UIKit
import HealthKit

class NameScore {
    var Name : String = ""
    var Score: Int = 0
    
}

func sortScores(NSArray : [NameScore]) -> [NameScore]{
    return NSArray.sort({ (s1: NameScore, s2: NameScore) -> Bool in
        return s1.Score > s2.Score
    })
}

class ClearTableViewController: UITableViewController {
    
    var healthStore: HKHealthStore?
    
    
    var friendNames  = ["Ann", "Frank", "Jamie", "Holly", "Andrew", "Nick"]
    var friendScores = [1200, 11000, 10000, 8888, 7777, 6666]
    
    var userName = "Lily"
    var userScore = 9999

    var tableData :[String] = []
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
        let completion: ((Bool, NSError?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                // TODO: Handle no result.
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                
                // Update the user interface based on the current user's health information.
//                self.updateUserAge()
//                self.updateUsersHeight()
            })
        }
        
        self.healthStore?.requestAuthorizationToShareTypes(writeDataTypes, readTypes: readDataTypes, completion: completion)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Daily Ranking"
        
        // HEALTHKIT
        
        
        // RANKING
        var allNameScore : [NameScore] = []
        var allScores = friendScores
        allScores.append(userScore)
        var allNames = friendNames
        allNames.append(userName)
        for i in 0..<allScores.count {
            let newNameScore = NameScore()
            newNameScore.Name = allNames[i]
            newNameScore.Score = allScores[i]
            allNameScore.append(newNameScore)
        }
        var allNameScoreSorted = sortScores(allNameScore)
        for i in 0..<allScores.count {
            let toAdd = allNameScoreSorted[i].Name + " " + String(allNameScoreSorted[i].Score)
            tableData.append(toAdd)
        }

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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func colorforIndex(index: Int) -> UIColor {
        
        let itemCount = tableData.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }
    
    
    
    
    
    
    private func dataTypesToWrite() -> Set<HKSampleType>
    {
        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let heightType:  HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
        
        return writeDataTypes
    }
    
    private func dataTypesToRead() -> Set<HKObjectType>
    {
        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let heightType:  HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        let birthdayType: HKCharacteristicType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        let biologicalSexType: HKCharacteristicType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType]
        
        return readDataTypes
    }
    
    
}
