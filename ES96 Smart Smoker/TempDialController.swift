//
//  FirstViewController.swift
//  ES96 Smart Smoker
//
//  Created by Jerry Chang on 4/28/15.
//  Copyright (c) 2015 JerryChang. All rights reserved.
//

import UIKit
import Parse

class TempDialController: UIViewController {

    @IBOutlet weak var smokerDial: SmokerDial!
    @IBOutlet weak var meatDial: MeatDial!
    @IBOutlet weak var smokerLabel: UILabel!
    @IBOutlet weak var meatLabel: UILabel!
    @IBOutlet var meatPosition: UIButton!
    
    var meatState = "Point"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smokerLabel.text = String(smokerDial.smokerTemp) + "°F"
        meatLabel.text = String(meatDial.meatTemp) + "°F"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchLastObject() {
        var query = PFQuery(className: "Dual_Testing")
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    var lastObject = objects[0]
                    
                    self.smokerDial.smokerTemp = lastObject["A_Smoker_Temp"] as! Int
                    self.meatDial.flatTemp = lastObject["A_Flat_Temp"] as! Int
                    self.meatDial.pointTemp = lastObject["A_Point_Temp"] as! Int
                    
                    self.smokerLabel.text = String(self.smokerDial.smokerTemp) + "°F"
                    
                    if (self.meatState == "Point") {
                        self.meatDial.meatTemp = self.meatDial.pointTemp
                    }
                    else {
                        self.meatDial.meatTemp = self.meatDial.flatTemp
                    }
                    
                    self.meatLabel.text = String(self.meatDial.meatTemp) + "°F"
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }

    }
    
    @IBAction func updateTemp(sender: AnyObject) {
        fetchLastObject()
    }

    @IBAction func toggleMeatPosition(sender: AnyObject) {
        if (meatState == "Point")
        {
            meatState = "Flat"
            self.meatDial.meatTemp = self.meatDial.pointTemp
            meatPosition.setTitle("Flat", forState: UIControlState.Normal)
        }
        else {
            meatState = "Point"
            self.meatDial.meatTemp = self.meatDial.flatTemp
            meatPosition.setTitle("Point", forState: UIControlState.Normal)
        }
        self.meatLabel.text = String(self.meatDial.meatTemp) + "°F"
    }

}

