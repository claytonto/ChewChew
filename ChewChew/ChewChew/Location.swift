//
//  Location.swift
//  ChewChew
//
//  Created by Maureen Naval on 9/27/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import UIKit

class Location {
    var name: String
    var price: String
    var rating: String
    var coordindates: [Double]
    
    init(name: String, price: String, rating: String, location: [Double]) {
        self.name = name
        self.price = price
        self.rating = rating
        self.coordindates = location
    }
    
}