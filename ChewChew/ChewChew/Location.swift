//
//  Location.swift
//  ChewChew
//
//  Created by Maureen Naval on 9/27/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import UIKit

/*
    Location represents each restaurant shown in the list
*/
class Location {
    var name: String
    var price: String
    var rating: String
    var coordinates: [Double]
    var reviews: [Review]

    init(name: String, price: String, rating: String, coordinates: [Double], reviews: [Review]) {
        self.name = name
        self.price = price
        self.rating = rating
        self.coordinates = coordinates
        self.reviews = reviews
    }
    
}