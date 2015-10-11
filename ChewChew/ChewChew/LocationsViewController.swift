//
//  LocationsViewController.swift
//  ChewChew
//
//  Created by Maureen Naval on 9/27/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import UIKit

class LocationsViewController: UITableViewController {
    
    // Data from home page
    var toPass:[Location]!

    // List of retrieved restaurants (initially empty)
    var locations:[Location] = ViewController().locationsList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color of bottom bar
        self.navigationController!.toolbar.barTintColor = UIColor.redColor()
        
        // Retrieve data from home page
        locations = toPass
        
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
        // Currently showing all possible location results
        return locations.count
    }

    // Show location information on corresponding cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)

        let location = locations[indexPath.row] as Location
        
        // Show location name
        if let nameLabel = cell.viewWithTag(100) as? UILabel {
            nameLabel.text = location.name
        }
        
        // Show location price level
        if let priceLabel = cell.viewWithTag(101) as? UILabel {
            priceLabel.text = location.price
        }
        
        // Show ratings as a row of stars
        if let ratingImageView = cell.viewWithTag(102) as? UIImageView {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
