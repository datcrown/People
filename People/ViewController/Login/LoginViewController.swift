//
//  LoginViewController.swift
//  People
//
//  Created by Quoc Dat on 1/24/18.
//  Copyright © 2018 Quoc Dat. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate{
    var SignInButton : GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        SignInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        SignInButton.center = view.center
        SignInButton.style = GIDSignInButtonStyle.standard
        view.addSubview(SignInButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func LoginbuttonAction(sender: GIDSignInButton!) {
        GIDSignIn.sharedInstance().signIn()
        SignInButton.isEnabled = false
    }

}
