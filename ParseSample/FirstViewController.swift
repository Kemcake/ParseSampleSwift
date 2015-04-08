//
//  FirstViewController.swift
//  ParseSample
//
//  Created by Remi Santos on 05/04/15.
//  Copyright (c) 2015 Remi Santos. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    func updateView() {
        if PFUser.currentUser() == nil {
            loginView.hidden = false
            logoutButton.hidden = true
            usernameLabel.text = ""
        } else {
            loginView.hidden = true
            logoutButton.hidden = false
            usernameLabel.text = PFUser.currentUser().username
        }
    }
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        
        var username = usernameField.text
        var password = passwordField.text
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) -> Void in
            if error == nil {
                self.updateView()
            } else {
                println(error.description)
            }
        }
    }

    @IBAction func signupButtonClicked(sender: UIButton) {
        
        var username = usernameField.text
        var password = passwordField.text
        var user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock { (user, error) -> Void in
            if error == nil {
                self.updateView()
            } else {
                println(error.description)
            }
        }
    }
    
    @IBAction func facebookButtonClicked(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"], block: { (user, error) -> Void in
            if error == nil {
                self.updateView()
            } else {
                println(error.description)
            }
        })
    }
    
    @IBAction func logoutButtonClicked(sender: UIButton) {
        PFUser.logOut()
        self.updateView()
    }
    @IBAction func closeKeyboard(sender: UIButton) {
        sender.resignFirstResponder()
    }
}

