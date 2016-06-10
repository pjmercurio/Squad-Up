//
//  ProfileViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/19/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBAction func logout(sender: AnyObject) {
        delegate.logout(0, uid: NSUserDefaults.standardUserDefaults().integerForKey("uid"));
        NSUserDefaults.resetStandardUserDefaults();
        let vc = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController");
        presentViewController(vc!, animated: true, completion: nil);
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = delegate.backgroundImage;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
