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
            
            
            // Create the URL request to Google Places for REVIEW
            let placeID:String = result["place_id"].stringValue
            let reviews:[Review] = getReviews(placeID)
            
            // Populate list
            let location = Location(name: resultName, price: resultPrice, rating: resultRating, location: locationData, reviews: reviews)
            self.locations.append(location)
        }
    }
    
    // getReview function
    func getReviews(placeID: String) -> [Review]{
        // Create the URL request to Google Places for REVIEW
        let urlReview: NSString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlReviewString: NSString = urlReview.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrlReview: NSURL = NSURL(string: urlReviewString as String)!
        
        // Retrieve list of places (JSON)
        let jsonData = NSData(contentsOfURL: searchUrlReview)
        let json = JSON(data: jsonData!)
        
        print(json)
        
        var reviews: [Review] = []

        // Parse JSON
        for result in json["result"]["reviews"].arrayValue {
            // Location name
            let author_name:String = result["author_name"].stringValue
            let rating:String = result["rating"].stringValue
            let text:String = result["text"].stringValue
            
            //Create a review list for each location
            let review: Review = Review(author_name: author_name, rating: rating, review: text)
            reviews.append(review)
        }
        
        return reviews
    }

}