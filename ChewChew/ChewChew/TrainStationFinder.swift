//
//  TrainStationFinder.swift
//  ChewChew
//
//  Created by Maureen Naval on 10/9/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrainStationFinder {
    var station: String
    var coordinates: [Double]
    
    init(station: String, coordinates: [Double]) {
        self.station = station;
        self.coordinates = coordinates
        
        // Look up the Place ID
        let placeID:String = trainStationInfo[station]!
                
        // Create the URL request for Place Details
        let url: NSString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string:urlString as String)!
        
        // Retrieve Place Details (JSON)
        let jsonData = NSData(contentsOfURL: searchUrl)
        let json = JSON(data: jsonData!)
                
        // Parse JSON for latitude and longitude
        let latitude:Double = json["result"]["geometry"]["location"]["lat"].double!
        let longitude:Double = json["result"]["geometry"]["location"]["lng"].double!

        self.coordinates.append(latitude)
        self.coordinates.append(longitude)
    }
}