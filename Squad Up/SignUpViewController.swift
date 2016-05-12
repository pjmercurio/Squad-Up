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
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupSpinner: UIActivityIndicatorView!
    
    @IBAction func checkPassword(sender: UITextField) {
        let alert = UIAlertController(title: "Confirm Password", message: "Please confirm your password", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addTextFieldWithConfigurationHandler({ (confirmTF) -> Void in
            confirmTF.placeholder = "Enter password here...";
            confirmTF.becomeFirstResponder();
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            print("closed");
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
            print("checking pass...");
            if (alert.textFields![0].text == self.passwordTF.text) {
                print("pass match!");
            }
            else {
                print("pass mismatch!");
            }
            self.passwordTF.resignFirstResponder();
        }));
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createAccount(name: String, email: String, password: String, age: Int) -> Void {
        print("Creating account for \(name)...\nEmail: \(email)\nPassword: \(password)");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        if (textField != passwordTF) {
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder();
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
