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
        // union station
        let url: NSString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=34.05618,-118.236487&radius=\(distance)&types=food&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string: urlString as String)!
    }

}