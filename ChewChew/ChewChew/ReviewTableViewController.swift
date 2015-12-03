//
//  ReviewTableViewController.swift
//  ChewChew
//
//  Created by Sippanon Kitimoon on 11/12/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewTableViewController: UITableViewController {
    
    // Data from home page
    var placeID:String   = ""
    var reviews:[Review] = []
    
    // getReview function
    func getReviews(placeID: String) -> [Review]{
        // Create the URL request to Google Places for REVIEW
        let urlReview: NSString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlReviewString: NSString = urlReview.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrlReview: NSURL = NSURL(string: urlReviewString as String)!
        
        // Retrieve list of places (JSON)
        let jsonData = NSData(contentsOfURL: searchUrlReview)
        let json = JSON(data: jsonData!)
        
        var reviews: [Review] = []
        
        // Parse JSON
        for result in json["result"]["reviews"].arrayValue {
            // reviews data
            let author_name:String = result["author_name"].stringValue
            let rating:String = result["rating"].stringValue
            let text:String = result["text"].stringValue
            
            //Create a review list for each location
            let review: Review = Review(author_name: author_name, rating: rating, review: text)
            reviews.append(review)
        }
        
        return reviews
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set color of bottom bar
        self.navigationController!.toolbar.barTintColor = UIColor.redColor()
        
        // Retrieve data from home page
        reviews = getReviews(placeID)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // show all reviews
        return reviews.count
    }

    // Show review information on corresponding cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewBox", forIndexPath: indexPath)

        let review = reviews[indexPath.row] as Review

        // Show location name
        if let authorName = cell.viewWithTag(100) as? UILabel {
            authorName.text = review.author_name
        }
        
        // Show content of a review
        if let comment = cell.viewWithTag(101) as? UILabel {
            comment.text = review.review
        }
        
        // Show ratings as a row of stars
        if let ratingImageView = cell.viewWithTag(102) as? UIImageView {
            let exactRating = Double(review.rating)   // string to double
            let rating: Int = Int(round(exactRating!))  // double to integer
            
            // Do not show ratings for places that don't have any
            if (rating != 0) {
                ratingImageView.image = self.imageForRating(rating)
            }
        }
        
        return cell
    }
    
    // Retrieve image to match rating
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
