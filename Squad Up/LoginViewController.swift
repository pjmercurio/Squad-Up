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
    @IBOutlet weak var signInSpinner: UIActivityIndicatorView!
    @IBAction func signIn(sender: UIButton) {
        if (signInButton.tag ==  1) {
            signInButton.setTitle("Signing in...", forState: UIControlState.Normal);
            signInSpinner.startAnimating();
            signIn(emailTF.text!, password: passwordTF.text!);
        }
        else {
            performSegueWithIdentifier("SignUpSegue", sender: self);
            //createAccount(emailTF.text!, password: passwordTF.text!);
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(Int(delegate.getHour() as! NSNumber));
        
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
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
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
    
    func signIn(email: String, password: String) -> Bool {
        print("Signing in returning user...");
        
        performSegueWithIdentifier("LoginSegue", sender: self);
        return true;
    }
    
    func createAccount(email: String, password: String) {
        //NSUserDefaults.standardUserDefaults().setObject(email, forKey: "username");
        //NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == emailTF) {
            emailTF.resignFirstResponder();
            passwordTF.becomeFirstResponder();
        }
        else {
            textField.resignFirstResponder();
        }
        return true;
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
