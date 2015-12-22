//
//  TweetTableViewController.swift
//  smashtag
//
//  Created by iPicnic Digital on 12/19/15.
//  Copyright © 2015 Dyego Silva. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    {
        didSet
        {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    var tweets = [[Tweet]]()
    var searchText: String? = "#standford"
    {
        didSet
        {
            if let _ = searchTextField?.text
            {
                lastSuccessfulRequest = nil
                searchTextField?.text = searchText
                tweets.removeAll()
                tableView.reloadData()
                refresh()
            }
        }
    }
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        setUpPushToRefresh()
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest?
    {
        if lastSuccessfulRequest == nil
        {
            if searchText != nil
            {
                return TwitterRequest(search: searchText!, count: 100)
            }
            else { return nil }
        }
        else { return lastSuccessfulRequest!.requestForNewer }
    }
    
    private func setUpPushToRefresh()
    {
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.backgroundColor = UIColor(red:0.33, green:0.67, blue:0.93, alpha:1.0)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Push to Refresh!")
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh()
    {
        if searchText == nil
        {
            self.refreshControl?.endRefreshing()
            return
        }
        
        if let request = nextRequestToAttempt
        {
            request.fetchTweets
            { newTweets in
                dispatch_async(dispatch_get_main_queue())
                {
                    if newTweets.count > 0
                    {
                        self.lastSuccessfulRequest = request
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    }
                    
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == searchTextField
        {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        
        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets[section].count
    }

    private struct Storyboard
    {
        static let CellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier(Segue.TweetIdentifier, sender: self)
    }

    // MARK: - Navigation
    
    private struct Segue
    {
        static let TweetIdentifier = "showTweet"
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let tvc = segue.destinationViewController as? TweetViewController
        {
            if let identifier = segue.identifier
            {
                switch (identifier)
                {
                case Segue.TweetIdentifier:
                    let indexPath = tableView.indexPathForSelectedRow
                    tvc.tweet = tweets[indexPath!.section][indexPath!.row]
                default: break
                }
            }
        }
    }
}
