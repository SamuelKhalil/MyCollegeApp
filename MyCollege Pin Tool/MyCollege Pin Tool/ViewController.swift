//
//  ViewController.swift
//  MyCollege Pin Tool
//
//  Created by Apple Developer on 3/15/19.
//  Copyright © 2019 Denny Homes. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var lblLatCord: UILabel!
    @IBOutlet weak var lblLongCord: UILabel!
    @IBOutlet weak var txtNameBox: UITextField!
    @IBOutlet weak var txtPinList: UITextView!
    
    
    //Used for managing location
    let locationManager = CLLocationManager()
    var pinsArray = [[String]]()
    let savedPinsKey = "pin_list"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtNameBox.delegate = self as UITextFieldDelegate
        
        //check if there are saved pins, if not set default text and save
        if (UserDefaults.standard.string(forKey: savedPinsKey) == nil){
            //make new
            txtPinList.text = "Name\t\t\tLatitude      Longitude\n"
            UserDefaults.standard.set(txtPinList.text, forKey: savedPinsKey)
        }else{
            //retreave old date
            txtPinList.text = UserDefaults.standard.string(forKey: savedPinsKey)
        }
       
        
        
        
        //enable location and authorize
        enableLocationServices();
        
        
    
        
    
    }
    
    // Called on 'Return' pressed. Return false to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Check and enable location services
    func enableLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
            
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    //Method updates coord. when location chamges
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        //update the labels with the current long and lat
        lblLatCord.text = locValue.latitude.description
        lblLongCord.text = locValue.longitude.description
        
    }
    
    
    
    
    
    @IBAction func addPin(_ sender: Any) {
        
//        var TempArray = [[String]]()
//        TempArray[0][0] = txtNameBox.text ?? "Error"
//        TempArray[0][1] = lblLatCord.text ?? "Error"
//        TempArray[0][2] = lblLongCord.text ?? "Error"
//        
//        
//        pinsArray.insert(TempArray[0], at: 0)
        
        if let name = txtNameBox.text, let lat = lblLatCord.text, let long = lblLongCord.text{
            
            txtPinList.text.append("\(name)\t\t\t\(String(Array(lat)[0..<7]))    \(String(Array(long)[0..<8]))\n")
            UserDefaults.standard.set(txtPinList.text, forKey: savedPinsKey)
            
        }
        
        
        
        //txtPinList.text = "\(String(describing: txtNameBox.text)) \(String(describing: lblLatCord.text)) \(String(describing: lblLongCord.text))\n\(txtNameBox.text!)"
        
    }
    
    
    @IBAction func ClearPins_Clicked(_ sender: Any) {
    
        //prompt user with message to make sure they really wanna clear
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "You are about to delete all saved pins!", message: "Are you sure?", preferredStyle: .actionSheet)
        
        // create an action for options
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            
            //clear saved pin list
            self.txtPinList.text = "Name\t\t\tLatitude      Longitude\n"
            UserDefaults.standard.set(self.txtPinList.text, forKey: self.savedPinsKey)
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(yesAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
    
    }
    
    
    


}

