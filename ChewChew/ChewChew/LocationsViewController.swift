//
//  LocationsViewController.swift
//  ChewChew
//
//  Created by Maureen Naval on 9/27/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import UIKit

/*
    List page
        Show the list of restaurants corresponding with user's input
*/
class LocationsViewController: UITableViewController {
    
    // Data from home page
    var toPass:[Location]!
    var stationCoordinates: [Double]!
    var stationName: String!

    // List of retrieved restaurants (initially empty)
    var locations:[Location] = ViewController().locationsList
    
    // Name of restaurant selected
    var locationName: String!
    
    // Label tag values
    let NAME_TAG = 100
    let PRICE_TAG = 101
    let RATING_TAG = 102
    
    // Red color values
    let RED_VALUE: CGFloat = 1
    let GREEN_VALUE: CGFloat = 73/255
    let BLUE_VALUE: CGFloat = 80/255
    
    // Row height
    let ROW_HEIGHT: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color of bottom bar
        let barColor = UIColor(red: RED_VALUE, green: GREEN_VALUE, blue: BLUE_VALUE, alpha: 1)
        self.navigationController!.toolbar.barTintColor = barColor
        
        // Set height of each cell
        self.tableView.rowHeight = ROW_HEIGHT;
        
        // Retrieve data from home page
        locations = toPass
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Currently showing all possible location results
        return locations.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "               Sorted by distance (Ascending)"
    }

    // Show location information on corresponding cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)
        
        let location = locations[indexPath.row] as Location
        
        // Show location name
        if let nameLabel = cell.viewWithTag(NAME_TAG) as? UILabel {
            nameLabel.text = location.name
            locationName = location.name
        }
        
        // Show location price level
        if let priceLabel = cell.viewWithTag(PRICE_TAG) as? UILabel {
            priceLabel.text = location.price
        }
        
        // Show ratings as a row of stars
        if let ratingImageView = cell.viewWithTag(RATING_TAG) as? UIImageView {
            let exactRating = Double(location.rating)   // string to double
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
    
    // MARK: - Navigation

    // Pass data from list page to map page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowMap"){
            let nextPage = segue.destinationViewController as! MapViewController
           
            // Get the selected row
            let indexPath = self.tableView.indexPathForSelectedRow!
            let clickedLocation = locations[indexPath.row]
            
            // Update location selected
            locationName = clickedLocation.name
            
            // Pass station and location data from selected row
            nextPage.locationCoordinates = clickedLocation.coordinates
            nextPage.stationCoordinates = stationCoordinates
            nextPage.stationName = stationName
            nextPage.locationName = locationName
        }
        if(segue.identifier == "ShowReview"){
            let reviewPage = segue.destinationViewController as! ReviewTableViewController
            // getting the selected review
            let position:CGPoint = (sender?.convertPoint(CGPointZero, toView: self.tableView))!
            let indexPath = self.tableView.indexPathForRowAtPoint(position)
            let clickedLocation =  locations[indexPath!.row]
            // passing the station and location data from selected row
            reviewPage.placeID = clickedLocation.placeID
        }
    }
}
