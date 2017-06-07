//
//  GoogleCredentialsVC.swift
//  SoftwareAnalysis
//
//  Created by Maxime Peralez on 24/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import AVFoundation
import MobileCoreServices
import SwiftSocket

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController!
    
    var fromCamera: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if fromCamera {
            
            let mediaType = info[UIImagePickerControllerMediaType] as! NSString
            
            self.dismiss(animated: true, completion: nil)
            
            if mediaType.isEqual(to: kUTTypeImage as String) {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let dataImage = UIImageJPEGRepresentation(image, 1.0)!
                    var bool = false
                    DispatchQueue.global().async {
                        let socketCom = SocketCom.init(ip: "192.168.1.4", port: 8080, dataImage: dataImage)
                        bool = socketCom.sendImage()
                    }
                    print("\(bool)")
                } else {
                    print("Camera error")
                }
            }
            
        } else {
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                //Send the image to the server
                let dataImage = UIImageJPEGRepresentation(image, 1.0)!
                var bool = false
                DispatchQueue.global().async {
                    let socketCom = SocketCom.init(ip: "192.168.1.4", port: 8080, dataImage: dataImage)
                    bool = socketCom.sendImage()
                }
                print("\(bool)")
            } else {
                print("No valid images selected")
            }
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        
    }
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            fromCamera = true
        }
        
    }

    @IBAction func logout(_ sender: Any) {
        _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)

        try! FIRAuth.auth()?.signOut()
        
        dismiss(animated: true, completion: nil)
    }
}
