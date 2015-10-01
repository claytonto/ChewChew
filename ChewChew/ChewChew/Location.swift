//
//  Location.swift
//  ChewChew
//
//  Created by Maureen Naval on 9/27/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import UIKit


struct Location {
    var name: String
    var distance: String
    
    init(name: String, distance: String) {
        self.name = name
        self.distance = distance + " miles"
    }
}