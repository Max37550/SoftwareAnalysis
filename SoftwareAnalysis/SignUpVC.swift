//
//  SignUpVC.swift
//  SoftwareAnalysis
//
//  Created by Maxime Peralez on 23/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpBtn: RoundedButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.delegate = self
        emailTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func signUpTapped(_ sender: Any) {

        if let email = emailTextField.text , let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {

            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                //User already exists
                if error == nil {

                    self.displayPopUp(title: "Alert", action: "Dismiss", message: "Email address already used")

                } else {
                    //User doesn't exist
                    if let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text, !firstName.isEmpty, !lastName.isEmpty {
                            
                        //Create a new user
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                print("Unable to authentificate user")
                            } else {
                                print("User authentificated")
                                self.completeSignUp(id: user!.uid, userData: ["firstName":firstName as AnyObject, "lastName":lastName as AnyObject])
                            }
                        })
                    } else {
                        self.displayPopUp(title: "Alert", action: "Dismiss", message: "Please enter a valid first name and last name.")
                    }
                }
            })
        } else {
            self.displayPopUp(title: "Alert", action: "Dismiss", message: "Please enter a valid email address and password.")
        }
    }
    
    func completeSignUp(id: String, userData: Dictionary<String, AnyObject>){
        
        DataService.ds.createOrUpdateFirebaseDBUser(uid: id, userData: userData)
        
        _ = KeychainWrapper.standard.set(id, forKey: "uid")
        
        performSegue(withIdentifier: "HomeUI", sender: nil)
    }
   
    @IBAction func leftArrowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
