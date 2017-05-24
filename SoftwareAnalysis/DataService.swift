//
//  DataService.swift
//  SoftwareAnalysis
//
//  Created by Maxime Peralez on 23/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createOrUpdateFirebaseDBUser(uid: String, userData: Dictionary<String, AnyObject>) {
        
        _REF_USERS.child(uid).updateChildValues(userData)
    }

}
