//
//  RoundedButton.swift
//  Words
//
//  Created by Maxime Peralez on 16/04/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }
    
}
