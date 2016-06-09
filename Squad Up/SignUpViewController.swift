//
//  SignUpViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/6/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var pwMatchLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signupSpinner: UIActivityIndicatorView!
    
    @IBAction func checkFields(sender: UITextField) {
        if (nameTF.text! == "" || emailTF.text! == "" || passwordTF.text! == "" || confirmPasswordTF.text! == "") {
            signupButton.enabled = false;
            signupButton.alpha = 0.5;
        }
        else {
            signupButton.enabled = true;
            signupButton.alpha = 1.0;
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController");
        presentViewController(vc!, animated: true, completion: nil);
    }
    @IBAction func checkPassword(sender: UITextField) {
        if (passwordTF.text! == confirmPasswordTF.text!) {
            pwMatchLabel.hidden = true;
            signupButton.enabled = true;
            signupButton.alpha = 1.0;
        }
        else {
            pwMatchLabel.hidden = false;
            signupButton.enabled = false;
            signupButton.alpha = 0.5;
        }
    }
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        let age: Int = Int(sender.value);
        ageLabel.text = "Age: \(age)";
    }
    
    @IBAction func squadUp(sender: UIButton) {
        self.view.endEditing(true);
        signupButton.setTitle("Creating your account...", forState: UIControlState.Normal);
        signupSpinner.startAnimating();
        createAccount(nameTF.text!, email: emailTF.text!, password: passwordTF.text!, age: Int(ageSlider.value));
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation();
    }
    
    func getLocation() {
        let url:NSURL = NSURL(string: "https://freegeoip.net/json/")!;
        var city:String = "Santa Barbara";
        var state:String = "CA";
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: .MutableContainers);
                    city = jsonResult["city"] as! String;
                    state = jsonResult["region_code"] as! String;
                    dispatch_async(dispatch_get_main_queue(), {
                        self.locationLabel.text = "\(city), \(state)";
                    })
                } catch {
                    print("JSON FAIL");
                }
            }
        }
        task.resume();
    }
    
    
    func createAccount(name: String, email: String, password: String, age: Int) -> Void {
        print("Creating account for \(name)...\nEmail: \(email)\nPassword: \(password)\nAge: \(age)");
        
        let url: NSURL! = NSURL(string: "http://www.squadup.us/PHP/signup.php");
        let params = "username=\(name)&email=\(email)&password=\(password)&age=\(age)";
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url);
        request.HTTPMethod = "POST";
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if (error != nil) {
                print("Response Error: \(error)");
            }
            else {
                let stringdg:NSString! = NSString.init(data: data!, encoding: NSUTF8StringEncoding);
                print("Data: \(stringdg)");
                
                
                do {
                    let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray;
                    print("myJSON: \(myJSON)");
                    if let parseJSON = myJSON {
                        print("ParseJSON: \(parseJSON)");
                    }
                } catch let error as NSError {
                    print("Parse Error: \(error)");
                }
            }
        }
        
        
        task.resume();
        
        //NSUserDefaults.standardUserDefaults().setObject(email, forKey: "username");
        //NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password");
        performSegueWithIdentifier("WelcomeSegue", sender: self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        if (textField != confirmPasswordTF) {
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder();
        }
        return true;
    }
    
    /*func sha256(data: NSData) -> NSData {
        let hash =
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
