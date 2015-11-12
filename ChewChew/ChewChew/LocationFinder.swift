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
    var latitude: Double
    var longitude: Double
    var distance: Double
    var locations: [Location]
    
    init(latitude: Double, longitude: Double, distance: Double, locations: [Location]) {
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance;
        self.locations = locations
        
        // Create the URL request to Google Places
        let url: NSString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(self.latitude),\(self.longitude)&radius=\(self.distance)&types=food&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string: urlString as String)!
        
        // Retrieve list of places (JSON)
        let jsonData = NSData(contentsOfURL: searchUrl)
        let json = JSON(data: jsonData!)
        // Parse JSON
        for result in json["results"].arrayValue {
            // Location name
            let resultName:String = result["name"].stringValue
            
            // Location price level
            var resultPrice:String = result["price_level"].stringValue
            
            // Show price levels as dollar amount
            if (resultPrice == "1") {
                resultPrice = "$"
            } else if (resultPrice == "2") {
                resultPrice = "$$"
            } else if (resultPrice == "3") {
                resultPrice = "$$$"
            } else if (resultPrice == "4") {
                resultPrice = "$$$$"
            }
            
            // Location rating
            var resultRating:String = result["rating"].stringValue
            // Locations without ratings
            if (resultRating == "") {
                resultRating = "0.0"
            }
            
            var locationData: [Double] = []
            let lat :Double = result["geometry"]["location"]["lat"].double!
            let long :Double = result["geometry"]["location"]["lng"].double!
            locationData.append(lat)
            locationData.append(long)
            
            
            // Populate list
            let location = Location(name: resultName, price: resultPrice, rating: resultRating, location: locationData )
            self.locations.append(location)
        }
    }

}