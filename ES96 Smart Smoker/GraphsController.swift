//
//  SecondViewController.swift
//  ES96 Smart Smoker
//
//  Created by Jerry Chang on 4/28/15.
//  Copyright (c) 2015 JerryChang. All rights reserved.
//

import UIKit
import Parse

class GraphsController: UIViewController {

    @IBOutlet weak var smokeContainer: UIView!
    @IBOutlet weak var smokeGraph: SmokerGraph!
    
    @IBOutlet weak var meatContainer: UIView!
    @IBOutlet weak var meatGraph: MeatGraph!
    
    @IBOutlet var meatGraphPosition: UIButton!
    
    var meatGraphState = "Point"
    var smokeID = 1
    var smokerData : [Int] = []
    var PointData : [Int] = []
    var FlatData : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSmokeID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSmokeID() {
        var query = PFQuery(className: "Dual_Testing")
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    var lastObject = objects[0]
                    self.smokeID = lastObject["Smoke_ID"] as! Int
                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
            
        }
    }
    
    func fetchSmokeData() {
        var smokeQuery = PFQuery(className: "Dual_Testing")
        smokeQuery.whereKey("Smoke_ID", equalTo:smokeID)
        smokeQuery.orderByDescending("updatedAt")
        smokeQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.smokerData.removeAll()
                    
                    for object in objects {
                        var t = object["A_Smoker_Temp"] as! Int
                        self.smokerData.insert(t, atIndex: 0)
                    }
                    self.smokeGraph.smokerPoints = self.smokerData
                    self.smokeGraph.setNeedsDisplay()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
        }
    }
    
    func fetchMeatData() {
        var smokeQuery = PFQuery(className: "Dual_Testing")
        smokeQuery.whereKey("Smoke_ID", equalTo:smokeID)
        smokeQuery.orderByDescending("updatedAt")
        smokeQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.PointData.removeAll()
                    self.FlatData.removeAll()
                    
                    for object in objects {
                        var tf = object["A_Flat_Temp"] as! Int
                        var tp = object["A_Point_Temp"] as! Int
                        self.PointData.insert(tp, atIndex: 0)
                        self.FlatData.insert(tf, atIndex: 0)
                    }
                    
                    if (self.meatGraphState == "Point") {
                        self.meatGraph.meatPoints = self.PointData
                    }
                    else {
                        self.meatGraph.meatPoints = self.FlatData
                    }
                    self.meatGraph.setNeedsDisplay()
                    
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
        }
    }

    @IBAction func fetchData(sender: AnyObject) {
        fetchSmokeData()
        fetchMeatData()
    }

    @IBAction func toggleMeatPosition(sender: AnyObject) {
        if (meatGraphState == "Point")
        {
            meatGraph.meatPoints = self.FlatData
            meatGraphState = "Flat"
            meatGraphPosition.setTitle("Flat", forState: UIControlState.Normal)
        }
        else {
            self.meatGraph.meatPoints = self.PointData
            meatGraphState = "Point"
            meatGraphPosition.setTitle("Point", forState: UIControlState.Normal)
        }
        meatGraph.setNeedsDisplay()
    }

}

