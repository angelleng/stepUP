//
//  ClearTableViewController.swift
//  ClearTableViewCell
//
//  Created by Allen on 16/1/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit
import HealthKit
import FBSDKLoginKit

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
    // Health related members
    var healthStore: HKHealthStore?
    
    var StepCount : Int = 0
    
    
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
        
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Daily Ranking"
        self.StepCount = 0
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
        let completion: ((Bool, NSError?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                
                // Update the user interface based on the current user's health information.
                self.getStepCount()
                
            })
        }
        
        self.healthStore?.requestAuthorizationToShareTypes(writeDataTypes, readTypes: readDataTypes, completion: completion)
        
        //        self.healthStore?.requestAuthorizationToShareTypes(writeDataTypes, readTypes: readDataTypes, completion: { success, error in
//            
//            if !success {
//                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
//                // TODO: Handle no result.
//                
//                return
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                () -> Void in
//                
//                // Update the user interface based on the current user's health information.
//                //            self.getStepCount()
//                //                self.updateUsersHeight()
//            })
//        })
        
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
    
    
        //MARK: - Private Method
        //MARK: HealthKit Permissions
    
        private func dataTypesToWrite() -> Set<HKSampleType>
        {
            let stepCountType : HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
            
            let writeDataTypes: Set<HKSampleType> = [stepCountType]
            return writeDataTypes
        }
    
        private func dataTypesToRead() -> Set<HKObjectType>
        {
            let stepCountType : HKQuantityType =  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
            
            let readDataTypes: Set<HKObjectType> = [stepCountType]
            return readDataTypes
        }
    
        //MARK: - Reading HealthKit Data
    
        private func updateUserAge() -> Void
        {
            let dateOfBirth: NSDate?
    
            do {
    
                dateOfBirth = try self.healthStore?.dateOfBirth()
    
            } catch _ as NSError {
    
                dateOfBirth = nil
    
            }
    
            if dateOfBirth == nil {
                print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.")
    
                return
            }
    
            let now: NSDate = NSDate()
    
            let ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: dateOfBirth!, toDate: now, options: .WrapComponents)
    
            let userAge: Int = ageComponents.year
    
            let ageValue: String = NSNumberFormatter.localizedStringFromNumber(userAge, numberStyle: NSNumberFormatterStyle.NoStyle)
            print(ageValue)
    
        }
    
    private func getStepCount() -> Void {
        let heightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        
        // Query to get the user's latest height, if it exists.
        let completion: HKCompletionHandle = {
            (mostRecentQuantity, error) -> Void in
            
            if mostRecentQuantity == nil {
                print("Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.")
                
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    let heightValue: String = NSLocalizedString("Not available", comment: "")
                    
//                    setHeightInformationHandle(heightValue)
                })
                
                return
            }
            
            // Determine the height in the required unit.
            let heightUnit: HKUnit = HKUnit.inchUnit()
            let usersHeight: Double = mostRecentQuantity.doubleValueForUnit(heightUnit)
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                let heightValue: String = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: usersHeight), numberStyle: NSNumberFormatterStyle.NoStyle)
                
//                setHeightInformationHandle(heightValue)
            })
        }
        
        self.healthStore!.mostRecentQuantitySampleOfType(heightType, predicate: nil, completion: completion)
    }
    
//        private func updateUsersHeight() -> Void
//        {
//            let setHeightInformationHandle: ((String) -> Void) = {
//                (heightValue) -> Void in
//    
//                // Fetch user's default height unit in inches.
//                let lengthFormatter: NSLengthFormatter = NSLengthFormatter()
//                lengthFormatter.unitStyle = NSFormattingUnitStyle.Long
//    
//                let heightFormatterUnit: NSLengthFormatterUnit = .Inch
//                let heightUniString: String = lengthFormatter.unitStringFromValue(10, unit: heightFormatterUnit)
//                let localizedHeightUnitDescriptionFormat: String = NSLocalizedString("Height (%@)", comment: "");
//    
//                let heightUnitDescription: NSString = NSString(format: localizedHeightUnitDescriptionFormat, heightUniString);
//    
//                if var userProfiles = self.userProfiles {
//                    var height: [String] = userProfiles[ProfileKeys.Height] as [String]!
//                    height[self.kProfileUnit] = heightUnitDescription as String
//                    height[self.kProfileDetail] = heightValue as String
//    
//                    userProfiles[ProfileKeys.Height] = height
//                    self.userProfiles = userProfiles
//                }
//    
//                // Reload table view (only height row)
//                let indexPath: NSIndexPath = NSIndexPath(forRow: ProfileViewControllerTableViewIndex.Height.rawValue, inSection: 0)
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
//    
//            let heightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
//    
//            // Query to get the user's latest height, if it exists.
//            let completion: HKCompletionHandle = {
//                (mostRecentQuantity, error) -> Void in
//    
//                if mostRecentQuantity == nil {
//                    print("Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.")
//    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        () -> Void in
//                        let heightValue: String = NSLocalizedString("Not available", comment: "")
//    
//                        setHeightInformationHandle(heightValue)
//                    })
//    
//                    return
//                }
//    
//                // Determine the height in the required unit.
//                let heightUnit: HKUnit = HKUnit.inchUnit()
//                let usersHeight: Double = mostRecentQuantity.doubleValueForUnit(heightUnit)
//    
//                // Update the user interface.
//                dispatch_async(dispatch_get_main_queue(), {
//                    () -> Void in
//                    let heightValue: String = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: usersHeight), numberStyle: NSNumberFormatterStyle.NoStyle)
//    
//                    setHeightInformationHandle(heightValue)
//                })
//            }
//    
//            self.healthStore!.mostRecentQuantitySampleOfType(heightType, predicate: nil, completion: completion)
//        }
//    
//        private func updateUsersWeight() -> Void
//        {
//            let setWeightInformationHandle: ((String) -> Void) = {
//                (weightValue) -> Void in
//    
//                // Fetch user's default height unit in inches.
//                let massFormatter: NSMassFormatter = NSMassFormatter()
//                massFormatter.unitStyle = NSFormattingUnitStyle.Long
//    
//                let weightFormatterUnit: NSMassFormatterUnit = .Pound
//                let weightUniString: String = massFormatter.unitStringFromValue(10, unit: weightFormatterUnit)
//                let localizedHeightUnitDescriptionFormat: String = NSLocalizedString("Weight (%@)", comment: "");
//    
//                let weightUnitDescription: NSString = NSString(format: localizedHeightUnitDescriptionFormat, weightUniString);
//    
//                if var userProfiles = self.userProfiles {
//                    var weight: [String] = userProfiles[ProfileKeys.Weight] as [String]!
//                    weight[self.kProfileUnit] = weightUnitDescription as String
//                    weight[self.kProfileDetail] = weightValue
//    
//                    userProfiles[ProfileKeys.Weight] = weight
//                    self.userProfiles = userProfiles
//                }
//    
//                // Reload table view (only height row)
//                let indexPath: NSIndexPath = NSIndexPath(forRow: ProfileViewControllerTableViewIndex.Weight.rawValue, inSection: 0)
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
//    
//            let weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
//    
//            // Query to get the user's latest weight, if it exists.
//            let completion: HKCompletionHandle = {
//                (mostRecentQuantity, error) -> Void in
//    
//                if mostRecentQuantity == nil {
//                    print("Either an error occured fetching the user's weight information or none has been stored yet. In your app, try to handle this gracefully.")
//    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        () -> Void in
//                        let weightValue: String = NSLocalizedString("Not available", comment: "")
//    
//                        setWeightInformationHandle(weightValue)
//                    })
//    
//                    return
//                }
//    
//                // Determine the weight in the required unit.
//                let weightUnit: HKUnit = HKUnit.poundUnit()
//                let usersWeight: Double = mostRecentQuantity.doubleValueForUnit(weightUnit)
//    
//                // Update the user interface.
//                dispatch_async(dispatch_get_main_queue(), {
//                    () -> Void in
//                    let weightValue: String = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: usersWeight), numberStyle: NSNumberFormatterStyle.NoStyle)
//    
//                    setWeightInformationHandle(weightValue)
//                })
//            }
//    
//            self.healthStore!.mostRecentQuantitySampleOfType(weightType, predicate: nil, completion: completion)
//        }
//    
//        private func saveHeightIntoHealthStore(height:Double) -> Void
//        {
//            // Save the user's height into HealthKit.
//            let inchUnit: HKUnit = HKUnit.inchUnit()
//            let heightQuantity: HKQuantity = HKQuantity(unit: inchUnit, doubleValue: height)
//    
//            let heightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
//            let nowDate: NSDate = NSDate()
//    
//            let heightSample: HKQuantitySample = HKQuantitySample(type: heightType, quantity: heightQuantity, startDate: nowDate, endDate: nowDate)
//    
//            let completion: ((Bool, NSError?) -> Void) = {
//                (success, error) -> Void in
//    
//                if !success {
//                    print("An error occured saving the height sample \(heightSample). In your app, try to handle this gracefully. The error was: \(error).")
//    
//                    abort()
//                }
//    
//                self.updateUsersHeight()
//            }
//    
//            self.healthStore!.saveObject(heightSample, withCompletion: completion)
//        }
//    
//        private func saveWeightIntoHealthStore(weight:Double) -> Void
//        {
//            // Save the user's weight into HealthKit.
//            let poundUnit: HKUnit = HKUnit.poundUnit()
//            let weightQuantity: HKQuantity = HKQuantity(unit: poundUnit, doubleValue: weight)
//    
//            let weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
//            let nowDate: NSDate = NSDate()
//    
//            let weightSample: HKQuantitySample = HKQuantitySample(type: weightType, quantity: weightQuantity, startDate: nowDate, endDate: nowDate)
//    
//            let completion: ((Bool, NSError?) -> Void) = {
//                (success, error) -> Void in
//    
//                if !success {
//                    print("An error occured saving the weight sample \(weightSample). In your app, try to handle this gracefully. The error was: \(error).")
//    
//                    abort()
//                }
//    
//                self.updateUsersWeight()
//            }
//    
//            self.healthStore!.saveObject(weightSample, withCompletion: completion)
//        }
//    
//        //MARK: - UITableView DataSource Methods
//    
//        override func numberOfSectionsInTableView(tableView: UITableView) -> Int
//        {
//            return 1
//        }
//    
//        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//        {
//            return 3
//        }
//    
//        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//        {
//            let CellIdentifier: String = "CellIdentifier"
//    
//            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
//    
//            if cell == nil {
//                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier)
//            }
//    
//            var profilekey: ProfileKeys?
//    
//            switch indexPath.row {
//            case 0:
//                profilekey = .Age
//    
//            case 1:
//                profilekey = .Height
//    
//            case 2:
//                profilekey = .Weight
//    
//            default:
//                break
//            }
//    
//            if let profiles = self.userProfiles {
//                let profile: [String] = profiles[profilekey!] as [String]!
//    
//                cell!.textLabel!.text = profile.first as String!
//                cell!.detailTextLabel!.text = profile.last as String!
//            }
//    
//            return cell!
//        }
//    
//        //MARK: - UITableView Delegate Methods
//    
//        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//        {
//            let index: ProfileViewControllerTableViewIndex = ProfileViewControllerTableViewIndex(rawValue: indexPath.row)!
//    
//            // We won't allow people to change their date of birth, so ignore selection of the age cell.
//            if index == .Age {
//                tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                return
//            }
//    
//            // Set up variables based on what row the user has selected.
//            var title: String?
//            var valueChangedHandler: (Double -> Void)?
//    
//            if index == .Height {
//                title = NSLocalizedString("Your Height", comment: "")
//    
//                valueChangedHandler = {
//                    value -> Void in
//    
//                    self.saveHeightIntoHealthStore(value)
//                }
//            }
//    
//            if index == .Weight {
//                title = NSLocalizedString("Your Weight", comment: "")
//    
//                valueChangedHandler = {
//                    value -> Void in
//    
//                    self.saveWeightIntoHealthStore(value)
//                }
//            }
//    
//            // Create an alert controller to present.
//            let alertController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//    
//            // Add the text field to let the user enter a numeric value.
//            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
//                // Only allow the user to enter a valid number.
//                textField.keyboardType = UIKeyboardType.DecimalPad
//            }
//            
//            // Create the "OK" button.
//            let okTitle: String = NSLocalizedString("OK", comment: "")
//            let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
//                let textField: UITextField = alertController.textFields!.first!
//                
//                let text: NSString = textField.text!
//                let value: Double = text.doubleValue
//                
//                valueChangedHandler!(value)
//                
//                tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            }
//            
//            alertController.addAction(okAction)
//            
//            // Create the "Cancel" button.
//            let cancelTitle: String = NSLocalizedString("Cancel", comment: "")
//            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel) { (action) -> Void in
//                tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            }
//            
//            alertController.addAction(cancelAction)
//            
//            // Present the alert controller.
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
}
