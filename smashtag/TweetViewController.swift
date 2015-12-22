//
//  TweetViewController.swift
//  smashtag
//
//  Created by iPicnic Digital on 12/21/15.
//  Copyright © 2015 Dyego Silva. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController
{
    var tweet: Tweet? { didSet { print(tweet) } }

    @IBOutlet weak var tweetText: UITextView! { didSet { updateUI() } }
    
    func updateUI()
    {
        tweetText?.text = nil
        
        if let tweet = self.tweet
        {
            tweetText?.text = tweet.text
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
