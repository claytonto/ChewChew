//
//  Review.swift
//  ChewChew
//
//  Created by Sippanon Kitimoon on 11/12/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import UIKit

class Review {
    var author_name: String
    var rating: String
    var review: String
    
    
    init(author_name: String, rating: String, review: String) {
        self.author_name = author_name
        self.rating = rating
        self.review = review
    }
    
}