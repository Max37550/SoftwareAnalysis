//
//  SocketCom.swift
//  SoftwareAnalysis
//
//  Created by Arthur Crocquevieille on 25/05/2017.
//  Copyright © 2017 Maxime Peralez. All rights reserved.
//

import Foundation
import SwiftSocket
import FirebaseAuth

class SocketCom {
    private var _client:TCPClient!
    private var  _dataImage:Data!
    
    init(ip : String, port : Int32, dataImage: Data){
        _client = TCPClient(address: ip, port: port)
        _dataImage = dataImage
    }
    func sendImage()-> Bool {
        switch _client.connect(timeout: 1) {
        case .success:
            //LOL c'est pas static normaement
            var dict = Dictionary<String , String>()
            if let curUser = FIRAuth.auth()?.currentUser {
                // User is signed in.
                dict["userID"] = curUser.uid
                dict["imageName"] = "\(curUser.uid)\(Date().timeIntervalSince1970).jpg"
                print("start current user: " + curUser.email! )
            } else {
                // No current user is signed in.
                return false
                print("Currently, no user is signed in.")
            }
            dict["sizeImage"] = "\(_dataImage.count)"
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                var score: Int = jsonData.count
                let data = Data(bytes: &score, count: MemoryLayout<Int>.size)
                //Taille du json
                _client.send(data: data)
                //json
                _client.send(data:jsonData)
                //Maintenat on peut envoyer l'image
                return _client.send(data: _dataImage).isSuccess
            }catch let err as NSError {
                print(err)
                return false
            }
            
        case .failure(let error):
            print(error)
            return false
        }
    }
}
