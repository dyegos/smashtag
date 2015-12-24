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
    var tweet: Tweet?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userhastag: UILabel!
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var media: UIImageView!
    
    func updateUI()
    {
        guard let tweet = self.tweet else { return }
        
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
        
        let attribute: NSMutableAttributedString = NSMutableAttributedString(string: tweet.text)
        
        for url in tweet.urls
        {
            attribute.addAttributes(
                [NSForegroundColorAttributeName : UIColor.blueColor()/*,
                    NSLinkAttributeName : url.keyword,
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue*/], range: url.nsrange)
        }
        
        for hashtags in tweet.hashtags
        {
            attribute.addAttributes(
                [NSForegroundColorAttributeName : UIColor.blueColor()/*,
                    /*NSLinkAttributeName : hashtags.keyword,*/
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.PatternSolid.rawValue*/], range: hashtags.nsrange)
        }
        
        for mentions in tweet.userMentions
        {
            attribute.addAttributes(
                [NSForegroundColorAttributeName : UIColor.blueColor()/*,
                NSLinkAttributeName : mentions.keyword,
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue*/], range: mentions.nsrange)
        }
        
        userName?.text = tweet.user.name
        userhastag?.text = "@" + tweet.user.screenName
        userTweet?.attributedText = attribute

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateUI()
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
