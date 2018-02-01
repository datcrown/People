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
import LocalAuthentication

class LoginViewController: UIViewController {
    var SignInButton : GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        creatLoginButton()
        SignInButton.isEnabled = true
        view.addSubview(SignInButton)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension LoginViewController: GIDSignInUIDelegate {
    func creatLoginButton() {
        SignInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        SignInButton.center = view.center
        SignInButton.style = GIDSignInButtonStyle.standard
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func LoginbuttonAction(sender: GIDSignInButton!) {
        GIDSignIn.sharedInstance().signIn()
        SignInButton.isEnabled = false
    }
}
