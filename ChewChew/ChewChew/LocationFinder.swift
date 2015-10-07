//
//  LocationFinder.swift
//  ChewChew
//
//  Created by Maureen Naval on 10/1/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LocationFinder {
    var distance: Double
    var locations: [Location]
    
    init(distance: Double, locations: [Location]) {
        self.distance = distance;
        self.locations = locations
        
        // Create the URL request to Google Places
        // Set union station as default station
        let url: NSString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=34.05618,-118.236487&radius=\(self.distance)&types=food&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string: urlString as String)!
        
        // Retrieve list of places (JSON)
        let jsonData = NSData(contentsOfURL: searchUrl)
        let json = JSON(data: jsonData!)
        
        // Parse JSON
        for result in json["results"].arrayValue {
            let resultName:String = result["name"].stringValue
            let resultRating:String = result["rating"].stringValue
            
            // Populate list
            let location = Location(name: resultName, rating: resultRating)
            self.locations.append(location)
        }
    }

}