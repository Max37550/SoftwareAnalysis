//
//  LogInVC.swift
//  SoftwareAnalysis
//
//  Created by Maxime Peralez on 23/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class LogInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func logInTapped(_ sender: Any) {
        if let email = usernameTextField.text , let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                //User already exists
                if error == nil {

                    if let user = user {
                        self.completeLogIn(id: user.uid)
                    }
                } else {

                    self.displayPopUp(title: "Alert", action: "Dismiss", message: "Email addres or password invalid")
                }
            })
        } else {
            self.displayPopUp(title: "Alert", action: "Dismiss", message: "Email addres or password invalid")
        }
    }
    
    func completeLogIn(id: String){
        
        _ = KeychainWrapper.standard.set(id, forKey: "uid")

        performSegue(withIdentifier: "HomeUI", sender: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        performSegue(withIdentifier: "SignUpUI", sender: nil)
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        
    }

}

