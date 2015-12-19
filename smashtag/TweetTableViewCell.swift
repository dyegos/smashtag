//
//  TweetTableViewCell.swift
//  smashtag
//
//  Created by iPicnic Digital on 12/19/15.
//  Copyright © 2015 Dyego Silva. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? { didSet { updateUI() } }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var tweetCreatedDate: UILabel!
    
    private func updateUI()
    {
        userImage?.image = nil
        userName?.text = nil
        userTweet?.text = nil
        tweetCreatedDate?.text = nil
        
        if let tweet = self.tweet
        {
            userTweet?.text = tweet.text
            
            if userTweet?.text != nil
            {
                for _ in tweet.media { userTweet.text! += " 📷" }
            }
            
            userName?.text = "\(tweet.user)"
            
            if let profileImage = tweet.user.profileImageURL
            {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
                {
                    if let imageData = NSData(contentsOfURL: profileImage)
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            self.userImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60
            {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            }
            else
            {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedDate?.text = formatter.stringFromDate(tweet.created)
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
