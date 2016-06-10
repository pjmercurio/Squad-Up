//
//  LoginViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/6/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInSpinner: UIActivityIndicatorView!
    @IBAction func signIn(sender: UIButton) {
        signIn(emailTF.text!, password: passwordTF.text!);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(Int(delegate.getHour() as! NSNumber));
        
        /*
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
            print("Credendials found! Entering returning user mode...");
            print("Username: \(username)");
            let password = NSUserDefaults.standardUserDefaults().stringForKey("password");
            emailTF.text = username;
            passwordTF.text = password;
            signInButton.setTitle("Sign In", forState: UIControlState.Normal);
            signInButton.tag = 1;
        }
        else {
            print("Credentials not found, entering new user mode...");
            signInButton.setTitle("Sign Up", forState: UIControlState.Normal);
            signInButton.tag = 0;
        }*/
        
    }
    
    // Change background image based on time of day
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
    }
    
    // Submit a sign in request to the server with email and password and if successful, segue to main screen
    func signIn(email: String, password: String) -> Bool {
        signInButton.setTitle("Signing in...", forState: UIControlState.Normal);
        signInSpinner.startAnimating();
        signUpButton.hidden = true;
        
        let url: NSURL! = NSURL(string: "http://www.squadup.us/PHP/login.php");
        let params = "email=\(email)&password=\(password)";
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url);
        request.HTTPMethod = "POST";
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if (error != nil) {
                print("Response Error: \(error)");
            }
            else {
                do { // Try parsing returned data as JSON object, if it works and there are no errors, segue to main screen
                    let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary;
                    if let parseJSON = myJSON {
                        if let err_code:NSInteger = parseJSON["err_code"] as? NSInteger {
                            var errorTitle: String = "ERROR";
                            var errorMessage: String = "Please try again.";
                            switch (err_code) {
                                case 0:
                                    print("LOGIN SUCCESSFUL!");
                                    if let uid:Int = parseJSON["uid"]!.integerValue {
                                        NSUserDefaults.standardUserDefaults().setInteger(uid, forKey: "uid");
                                        //self.delegate.uid = uid;
                                    }
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        self.performSegueWithIdentifier("LoginSegue", sender: self);
                                    });
                                    break;
                                case 1:
                                    errorTitle = "Password Incorrect";
                                    break;
                                case 2:
                                    errorMessage = "Could not find account.";
                                    break;
                                case 3:
                                    errorMessage = "Could not connect to server.";
                                    break;
                                default:
                                    errorTitle = "Unknown Error";
                            }
                            if (err_code != 0) {
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert);
                                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
                                    self.signInButton.setTitle("Sign In", forState: .Normal);
                                    self.signInSpinner.stopAnimating();
                                    self.signUpButton.hidden = false;
                                    self.presentViewController(alert, animated: true, completion: nil);
                                });
                            }
                        }
                        
                        print("ParseJSON: \(parseJSON)");
                    }
                }
                catch let error as NSError {
                    print("Parse Error: \(error)");
                }
            }
        }
        
        
        task.resume();
        
        return true;
    }
    
    func createAccount(email: String, password: String) {
        //NSUserDefaults.standardUserDefaults().setObject(email, forKey: "username");
        //NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // Either transitions to next text field, or closes keyboard if we are on the last text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch(textField) {
            case emailTF:
                emailTF.resignFirstResponder();
                passwordTF.becomeFirstResponder();
                break;
            case passwordTF:
                signIn(emailTF.text!, password: passwordTF.text!);
                break;
            default:
                textField.resignFirstResponder();
        }
        return true;
    }
}
