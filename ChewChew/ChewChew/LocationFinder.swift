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
    var station = ViewController().getStation()
    var distance = ViewController().getDistance()
    
    init(distance: Double) {
        // Create the URL request to Google Places
        // Set union station as default station
        let url: NSString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=34.05618,-118.236487&radius=\(distance)&types=food&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string: urlString as String)!
        
        print(searchUrl)
        
        // Request data from Google Places with newly created URL
        Alamofire.request(.GET, searchUrl).responseJSON() {
            (_, _, json) in
//            print(json.value)
            
            // Parse JSON data
            let jsonData = NSData(contentsOfURL: searchUrl)
            let json = JSON(data: jsonData!)
            
            for result in json["results"].arrayValue {
                let resultName:String = result["name"].stringValue
//                print("name:" + resultName)
                
                // Create list of location classes
                var locationList = [Location]()
                let location = Location(name: resultName)
                locationList.append(location);
            }
        }
    }

}