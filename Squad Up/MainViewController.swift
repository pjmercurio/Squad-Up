//
//  MainViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/6/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox

class MainViewController: UIViewController, UINavigationBarDelegate {
    

    @IBOutlet weak var okView: UIView!
    @IBOutlet weak var theItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mainWindow: UIView!
    @IBOutlet weak var videoHolder: UIView!
    @IBOutlet weak var videoCaption: UIView!
    @IBOutlet weak var videoCaptionLabel: UILabel!
    @IBOutlet weak var theArrow: UIImageView!
    @IBAction func playMovie(sender: AnyObject) {
        playerViewController.player?.play();
    }
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var initTouch: CGPoint = CGPointMake(0, 0);
    var initRotation: CGFloat = 0.0;
    var initArrowY: CGFloat = 0.0;
    var firstTouch: Bool = true;
    var playerViewController = AVPlayerViewController();
    var deviceCenterX: CGFloat = 0.0;
    var isUpArrow: Bool = true;
    var tmpCaptions = ["Kate and Molly think they can dance apparently...", "Things getting weird in DC tonight...", "I'm just going to pretend I don't know them..", "WTF is going on here...", "Just kill me."];
    
    // SET STATUS BAR TO BE LIGHT THEME
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceCenterX = self.view.center.x;
        setBackground(Int(delegate.getHour() as! NSNumber));
        mainWindow.layer.cornerRadius = 10.0;
        initArrowY = theArrow.center.y;
        videoCaption.layer.cornerRadius = 10.0;
        
        
        let titleImage1: UIImage = UIImage.init(named: "le_title1.png")!;
        let titleImage: UIImageView = UIImageView.init(frame: CGRectMake(0, 0, 100, 40));
        titleImage.image = titleImage1;
        titleImage.contentMode = UIViewContentMode.ScaleAspectFit;
        
        
        //titleImage.frame = CGRectMake(0, 0, 500, 45);
        theItem.titleView = titleImage;
        //theItem.titleView?.frame = CGRectMake(100, 5, 100, 45);
        
        
        loadMovie();
    }
    
    // SET THE BACKGROUND BASED ON THE CURRENT TIME
    func setBackground(hour: Int) {
        if (hour > 6 && hour < 15) {
            backgroundImage.image = UIImage.init(named: "morning_mode.png");
        }
        else if (hour > 14 && hour < 19) {
            backgroundImage.image = UIImage.init(named: "sunset_mode.png");
        }
        else {
            backgroundImage.image = UIImage.init(named: "night_mode.png");
        }
        delegate.backgroundImage = backgroundImage.image!;
    }

    // FINGER PRESSED
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        
        if (touch.view == mainWindow) {
            initTouch = CGPointMake(touch.locationInView(self.view).x, touch.locationInView(self.view).y);
        }
        else if (touch.view == videoCaption) {
            print("OPEN CAPTIOB");
            openCaption();
        }
    }
    
    // FINGER DRAGGED
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        let mainWindowCenterX: CGFloat = mainWindow.center.x;
        
        
        if (touch.view == mainWindow || touch.view == videoHolder){
            if traitCollection.forceTouchCapability == UIForceTouchCapability.Available { // CHECK FOR POPPED SQUAD
                if (touch.force > touch.maximumPossibleForce/2) {
                    //popSquad();
                    videoHolder.contentScaleFactor = 4.0;
                    print("SQUAD POPPED!");
                }
            }
            
            let curX: CGFloat = CGFloat(touch.locationInView(self.view).x);
            let deltaX:CGFloat = CGFloat(initTouch.x) - CGFloat(curX);
            if (firstTouch) { // SET THE ARROW IMAGE
                if (deltaX == 0 && firstTouch) {
                    print("FIRST TOUCH");
                }
                else {
                    setArrowImage(deltaX);
                }
            }
            mainWindow.center.x -= CGFloat(deltaX*1.5);
            theArrow.center.y += CGFloat(deltaX*0.3);
            mainWindow.transform = CGAffineTransformMakeRotation(initRotation + (0.004*deltaX));
            theArrow.alpha = abs(deviceCenterX - mainWindowCenterX)/200;
            
            if (mainWindowCenterX < deviceCenterX) {
                if (isUpArrow) {
                    theArrow.image = UIImage.init(named: "down_red_arrow.png");
                    isUpArrow = false;
                }
            }
            else {
                if (!isUpArrow) {
                    theArrow.image = UIImage.init(named: "up_green_arrow.png");
                    isUpArrow = true;
                }
            }
            initTouch.x = CGFloat(curX);
            initRotation -= 0.004*deltaX;
        }
        else{
            print("touchesMoved | This is not the Window")
        }
    }
    
    // SET ARROW TO GREEN OR RED
    func setArrowImage(direction: CGFloat) {
        if (direction < 0) {
            theArrow.image = UIImage.init(named: "up_green_arrow.png");
        }
        else {
            theArrow.image = UIImage.init(named: "down_red_arrow.png");
        }
        firstTouch = false;
    }
    
    // FINGER LET GO OF SCREEN
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        firstTouch = true;
        
        if (touch.view == mainWindow) {
            if (mainWindow.center.x > 370) { // Swipe Right
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.mainWindow.center.x = 1000;
                    self.mainWindow.transform = CGAffineTransformMakeRotation(2);
                    }, completion: { (finished: Bool) -> Void in
                        self.nextView(true);
                })
            }
            else if (mainWindow.center.x < 0) { // Swipe Left
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.mainWindow.center.x = -500;
                    self.mainWindow.transform = CGAffineTransformMakeRotation(-2);
                    }, completion: { (finished: Bool) -> Void in
                        self.nextView(true);
                })
            }
            else { // Cancel
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mainWindow.center.x = self.view.center.x;
                    self.theArrow.center.y = self.initArrowY;
                    self.mainWindow.transform = CGAffineTransformMakeRotation(0.0);
                    self.theArrow.alpha = 0.0;
                    self.nextView(false);
                })
            }
            
        }
    }
    
    // POP OPEN A SQUAD PROFILE
    func popSquad() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        
        // with no animation block, and a completion block set to 'nil' this makes a single line of code
        mainWindow.userInteractionEnabled = false;
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.mainWindow.transform = CGAffineTransformMakeScale(200.0, 200.0);
            self.mainWindow.alpha = 0.0;
        }) { (finished: Bool) in
            print("DONE");
        }
        
    }
    
    // POP OPEN VIDEO CAPTION
    func openCaption(duration: NSTimeInterval = 0.2) {
        if (videoCaption.tag == 0) {
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.videoCaption.frame.size.height += 250;
                self.videoCaption.center.y -= 250;
                }, completion: { (finished: Bool) -> Void in
                    self.videoCaption.tag = 1;
            })
        }
        else {
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.videoCaption.frame.size.height -= 250;
                self.videoCaption.center.y += 250;
                }, completion: { (finished: Bool) -> Void in
                    self.videoCaption.tag = 0;
            })
        }
        
    }
    
    // LOAD THE NEXT VIEW
    func nextView(reloadView: Bool) {
        initTouch.x = self.view.center.x;
        initRotation = 0.0;
        theArrow.alpha = 0.0;
        if (videoCaption.tag == 1) {
            openCaption(0.0);
        }
        if (reloadView) {
            playerViewController.view.removeFromSuperview();
            mainWindow.center.x = self.view.center.x;
            mainWindow.transform = CGAffineTransformMakeRotation(0.0);
            mainWindow.alpha = 0.0;
            mainWindow.center.y += 25;
            
            videoCaptionLabel.text = tmpCaptions[Int(arc4random_uniform(5))];
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.mainWindow.alpha = 1.0;
                self.mainWindow.center.y -= 25;
                }, completion: { (finished: Bool) -> Void in
                    self.loadMovie();
            })
        }
        
    }
    
    // LOAD THE MOVIE IN THE VIEW
    func loadMovie() {
        let moviePath = NSBundle.mainBundle().pathForResource("vid_sample", ofType: "m4v")
        if let path = moviePath {
            let url = NSURL.fileURLWithPath(path);
            let player = AVPlayer(URL: url);
            
            playerViewController.player = player;
            playerViewController.view.frame = CGRectMake(0, 0, videoHolder.frame.width, videoHolder.frame.height);
            playerViewController.videoGravity = "AVLayerVideoGravityResizeAspectFill";
            playerViewController.showsPlaybackControls = false;
            playerViewController.view.userInteractionEnabled = false;
            playerViewController.view.layer.masksToBounds = true;
            playerViewController.view.layer.cornerRadius = 10.0;
            
            videoHolder.layer.masksToBounds = true;
            videoHolder.layer.cornerRadius = 10.0;
            videoHolder.addSubview(playerViewController.view);
            videoHolder.sendSubviewToBack(playerViewController.view);
            
            player.play();
        }
        else {
            print("Video not loaded!");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
