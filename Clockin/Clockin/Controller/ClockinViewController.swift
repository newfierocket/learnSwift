//
//  Clockin.swift
//  Clockin
//
//  Created by Christopher Hynes on 2018-01-26.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import SVProgressHUD
import SCLAlertView

class ClockinViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    let locationManager = CLLocationManager() //Set locationManager instance varible from class CLLocationManager
    var myTimer = Timer()
    var myClockInData : [PunchData] = [PunchData]()
    var latitude : Double = 0
    var longitude : Double = 0
    var jobDescription = ""
    let dateID = DateTime().currentDay().dropLast(3)
    
    
    @IBOutlet weak var height: NSLayoutConstraint!
   
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextField: UITextField!
    @IBOutlet weak var lastCheckin: UILabel!
    
   
    //###############################################################################
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        updateTime()
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        jobDescriptionTextField.delegate = self
    }
   
    //################################################################################
    //MARK: UPDATE WITH LIVE TIME - SEE TIMER
    
    @objc func updateTime() {
        let dateTime = DateTime().currentDate()
        dateTimeLabel.text = "Current Date: \(dateTime)"
    }
    
    //################################################################################
    //MARK: GET LOCATION
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    
    }
    //###############################################################################
    //MARK: TEXT FIELD BEGIN EDITING
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.height.constant = 358
            self.view.layoutIfNeeded()
        }
    }
    //###############################################################################
    //MARK: TEXT FIELD END EDITING
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.height.constant = 55
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    //################################################################################
    
    //MARK: LOCATION MANAGER DID UPDATE LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations[0]
        
        longitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        print("hey I Got location long:\(longitude) lat:\(latitude)")
        writeToDataBase()
        updateLastCheckin()
    }
    //##################################################################################
    //MARK: WRITE TO DATA BASE
    
    func writeToDataBase() {
        let user = Auth.auth().currentUser?.email
        let hashID = String(user!.hashValue)
       
        let checkinDictionary = ["Location" : "\(latitude),\(longitude)", "time" : DateTime().currentDate(), "job" : jobDescriptionTextField.text!]
        jobDescriptionTextField.text = ""
        jobDescriptionTextField.endEditing(true)
        let clockInData = Database.database().reference().child(hashID).child(String(dateID))
        
        clockInData.childByAutoId().setValue(checkinDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                
            } else {
                print("Data saved succesfully")
                SVProgressHUD.dismiss()
                
            }
        }
        
    }
    
    
    //################################################################################
    //MARK: LOCATION MANAGER DID FAIL
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could Not get Location")
        print(error)
        SVProgressHUD.dismiss()
    }
    
    //################################################################################
    //MARK: IBACTION SEND BUTTON
    @IBAction func sendButton(_ sender: UIButton) {
        SVProgressHUD.show()
        getLocation()
        
    }
    //################################################################################
    //MARK: UPDATE LAST CHECK-IN
    func updateLastCheckin() {
        let dateTime = DateTime().currentTime()
        lastCheckin.text = "Last Check-in was: " + String(dateTime)
        
    }
    
    
    //#################################################################################
    //MARK: LOGOUT
    @IBAction func logOut(_ sender: UIButton) {
        do {
           try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            SCLAlertView().showError("Error Signing out.", subTitle: "Please try again")
        }
    }
    //#################################################################################
    //MARK: UPDATE DATA
    
    func updateData() {
        let user = Auth.auth().currentUser?.email
        let hashID = String(user!.hashValue)
        
        let clockinDB = Database.database().reference().child(hashID).child(String(dateID))
        
        clockinDB.observe(.childAdded) { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary <String,String>
            //            print(snapShotValue)
            
            let location = snapShotValue["Location"]
            let time = snapShotValue["time"]
            let job = snapShotValue["job"]
            
            let clockIn = PunchData()
            clockIn.clockin = time!
            clockIn.location = location!
            clockIn.jobDescription = job!
            
            self.myClockInData.append(clockIn)
            
        }
    }
    
    @IBAction func getData(_ sender: UIButton) {
//        for i in 1...self.myClockInData.count {
//            print(myClockInData[i-1].jobDescription)
//        }
        
    }

    
    
}
