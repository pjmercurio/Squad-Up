//
//  EventViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/19/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet weak var noSquadAlert: UIView!
    @IBOutlet weak var mainSquadWindow: UIView!
    @IBOutlet weak var videoHolder: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var squadScroll: UIScrollView!
    @IBOutlet weak var profPic: UIView!
    @IBAction func tabChanged(sender: AnyObject) {
        if (sender.selectedSegmentIndex == 1) {
            hideShowMySquad(110, alpha: 0)
        }
        else {
            hideShowMySquad(-110, alpha: 1);
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = delegate.backgroundImage;
        
        loadSquad();
    }
    
    // POP FRIENDS SCROLL VIEW UP AND DOWN
    func hideShowMySquad(y: CGFloat, alpha: CGFloat) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.squadScroll.center.y += y;
            self.mainSquadWindow.alpha = alpha;
        }) { (finished: Bool) in
            // Animation Done
        }
    }
    
    // ADD A NEW MEMBER TO YOUR SQUAD
    func addMember() {
        print("Member Added!");
    }
    
    // CREATE A NEW SQUAD
    func createSquad() {
        print("Squad created!");
    }
    
    // CHECK IF PART OF A SQUAD ALREADY, IF SO LOAD IT UP, IF NOT OFFER OPTION TO CREATE
    func loadSquad() {
        if (true) { // Check global squad ID variable to see if it has a value
            noSquadAlert.hidden = true;
            loadSquadBar();
        }
        else {
            noSquadAlert.hidden = false;
        }
    }
    
    // LOAD MEMBERS OF YOUR SQUAD TO DISPLAY AT BOTTOM OF SCREEN
    func loadSquadBar() {
        let Friends = [["Dylan","dylan_prof.jpg",false],["Taylor","taylor_prof.jpg",true],["Tao","tao_prof.jpg",false],["Chris","chris_prof.jpg",true]];
        var squadWidth:CGFloat = 20;
        
        for friend in Friends {
            let profPic: UIView = UIView.init(frame: CGRectMake(squadWidth, 13, 88, 84));
            let subView: UIView = UIView.init(frame: CGRectMake(2, 2, 84, 80));
            let profImage: UIImageView = UIImageView.init(frame: CGRectMake(0, 0, 84, 80));
            let onlineDotImage: UIImageView = UIImageView.init(frame: CGRectMake(69, 5, 10, 10));
            let labelView: UIView = UIView.init(frame: CGRectMake(0, 60, 84, 20));
            let label: UILabel = UILabel.init(frame: CGRectMake(0, 0, 84, 20));
            let font = UIFont.init(name: "HelveticaNeue-Light", size: 14.0);
            
            profPic.backgroundColor = UIColor.whiteColor();
            subView.backgroundColor = UIColor.whiteColor();
            profImage.image = UIImage.init(named: friend[1] as! String);
            onlineDotImage.image = UIImage.init(named: "online_dot.png");
            profPic.layer.cornerRadius = 10.0;
            subView.layer.cornerRadius = 10.0;
            subView.layer.masksToBounds = true;
            labelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5);
            
            label.text = friend[0] as? String;
            label.textColor = UIColor.whiteColor();
            label.textAlignment = .Center;
            label.font = font;
            
            onlineDotImage.hidden = !(friend[2] as! Bool);
            
            labelView.addSubview(label);
            subView.addSubview(profImage);
            subView.addSubview(onlineDotImage);
            subView.addSubview(labelView);
            profPic.addSubview(subView);
            squadScroll.addSubview(profPic);
            
            squadWidth += 100;
        }
        
        let addMember:UIButton = UIButton.init(frame: CGRectMake(squadWidth, 20, 70, 70));
        addMember.setImage(UIImage.init(named: "add_member.png"), forState: UIControlState.Normal);
        addMember.addTarget(self, action: #selector(EventViewController.addMember), forControlEvents: .TouchUpInside);
        addMember.alpha = 0.5;
        squadScroll.addSubview(addMember);
        squadScroll.contentSize.width = squadWidth + 85;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
