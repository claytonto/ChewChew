//
//  ViewController.swift
//  ChewChew
//
//  Created by Clayton To on 9/17/15.
//  Copyright (c) 2015 ChewChew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    var trainStation: String = ""
    var distanceRadius: Double = 0.0;
    
    @IBOutlet weak var button: UIButton!
    
    // Update the slider label
    @IBAction func sliderValueChanged(sender: UISlider) {
        distanceRadius = Double(sender.value)
        distanceRadius = round(10*distanceRadius)/10
        
        // round to 1 digit after decimal
        label.text = "\(distanceRadius) miles"
    }
    
    // Save the train station and distance radius
    // when user hits search button
    @IBAction func searchPressed(sender: UIButton) {
        trainStation = search.text!
        
        // DEBUGGING: Check if saved
        print(trainStation)
        print(distanceRadius)
    }
    
    // GETTER FUNCTIONS //
    
    // Get the user's train station
    func getStation() -> String {
        return trainStation
    }
    
    // Get the user's distance radius
    func getDistance() -> Double {
        return distanceRadius
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

