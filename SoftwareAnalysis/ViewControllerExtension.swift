//
//  ViewControllerExtension.swift
//  SoftwareAnalysis
//
//  Created by Maxime Peralez on 23/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayPopUp(title: String, action: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
