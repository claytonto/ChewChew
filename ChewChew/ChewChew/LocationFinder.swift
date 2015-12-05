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

/*
    Find restaurants around the user's train station
    Input: Latitude and longitude (user's train station)
           Distance user is willing to travel
           Empty locations array
    Can directly access the updated locations array
*/
class LocationFinder {
    // User's train station coordinates
    var latitude: Double
    var longitude: Double
    
    // How far the user is willing to travel
    var distance: Double
    
    // Results
    var locations: [Location]
    
    init(latitude: Double, longitude: Double, distance: Double, locations: [Location]) {
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.locations = locations
        
        // Create the URL request to Google Places
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        let apiKey = "AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let url: NSString = "\(baseURL)location=\(self.latitude),\(self.longitude)&rankBy=distance&radius=\(self.distance)&types=food&key=\(apiKey)"
        
        // Format URL for JSON request
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string: urlString as String)!

        // Retrieve list of places
        let jsonData = NSData(contentsOfURL: searchUrl)
        let json = JSON(data: jsonData!)
        
        // Create list of locations based on retrieved information
        convertResults(json)
    }
    
    // Parse JSON for relevant restaurant information
    private func convertResults(rawResults: JSON) {
        for result in rawResults["results"].arrayValue {
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
            
            // Location coordinates
            var locationData: [Double] = []
            let latitude: Double = result["geometry"]["location"]["lat"].double!
            let longitude: Double = result["geometry"]["location"]["lng"].double!
            locationData.append(latitude)
            locationData.append(longitude)
            
            // Create placeID used in generate review
            let placeID:String = result["place_id"].stringValue
            
            // Populate list
            let location = Location(name: resultName, price: resultPrice, rating: resultRating,
                location: locationData, placeID: placeID)
            self.locations.append(location)
        }
    }

}