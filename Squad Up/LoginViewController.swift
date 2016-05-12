//
//  LoginViewController.swift
//  Squad Up
//
//  Created by Paul Mercurio on 5/6/16.
//  Copyright © 2016 Paul Mercurio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInSpinner: UIActivityIndicatorView!
    @IBAction func signIn(sender: UIButton) {
        signInButton.setTitle("Signing in...", forState: UIControlState.Normal);
        signInSpinner.startAnimating();
        signIn(emailTF.text!, password: passwordTF.text!);
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signIn(email: String, password: String) -> Bool {
        
        // IF FAIL:
        signInSpinner.stopAnimating();
        signInButton.setTitle("Sign In", forState: UIControlState.Normal);
        return true;
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
