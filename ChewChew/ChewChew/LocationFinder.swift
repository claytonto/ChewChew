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
        let url: NSString = "\(baseURL)location=\(self.latitude),\(self.longitude)&radius=\(self.distance)&types=food&key=\(apiKey)"
        
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
            
            
            // Create the URL request to Google Places for REVIEW
            
            // TO DO: RE-ENABLE REVIEWS
            // TEMPORARILY DISABLED FOR TESTING PURPOSES
            // SO THAT API QUOTA DOES NOT HIT LIMIT
            
            //let placeID:String = result["place_id"].stringValue
            //let reviews:[Review] = getReviews(placeID)
            
            // TO DO: GET RID OF EMPTY REVIEWS LIST
            // TEMPORARILY USED SO THAT LOCATION CLASS CAN BE USED
            // WHILE REVIEW FETCHING IS DISABLED
            let reviews:[Review] = [Review]()
            
            // Populate list of locations with restaurants
            let location = Location(name: resultName, price: resultPrice, rating: resultRating, coordinates: locationData, reviews: reviews)
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
        
        //print(json)
        
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