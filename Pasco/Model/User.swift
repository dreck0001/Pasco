//
//  User.swift
//  Pasco
//
//  Created by denis on 6/23/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct User {
//    let key: String!
    let uid: String!
    let email: String!
    let username: String!
    let itemRef: DatabaseReference?


    init(uid: String, email: String, userName: String) {
//        self.key = key
        self.email = email
        self.username = userName
        self.itemRef = nil
        self.uid = uid
    }
    
    init(data: [String : Any]) {
        uid = data["uid"] as? String
        email = data["email"] as? String
        username = data["username"] as? String
        itemRef = nil
    }
    
    init(snapshot: DataSnapshot) {
//        key = snapshot.key
        itemRef = snapshot.ref
        if let snapshotVDict = snapshot.value as? NSDictionary {
            if let userEmail        = snapshotVDict["emial"] as? String         { email = userEmail }         else { email = "" }
            if let userUserName     = snapshotVDict["username"] as? String      { username = userUserName }   else { username = "" }
            if let userUid          = snapshotVDict["uid"] as? String           { uid = userUid }             else { uid = "" }
        }
        else { uid = ""; email = ""; username = ""; }
    }
    
    func toAnyObject() -> Any {
        return [
            "email"     : email as Any,
            "username"  : username as Any,
            "uid"       : uid as Any
        ]
    }
    
    
    
//    static func getUsers() -> [String] {
//        var usernames = [String]()
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting users: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let username = document.documentID
//                    usernames.append(username)
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//        print(usernames)
//        return usernames
//    }
    
//    init(userData: AuthDataResult) {
//        uid = userData.user.uid
//        if let mail = userData.user.providerData.first?.email {
//            email = mail
//        } else { email = "" }
//        userName = userData.additionalUserInfo?.username ?? "username"
//    }
//    init(uid: String, email: String, username: String) {
//        self.uid = uid
//        self.email = email
//        self.userName = username
//    }
}
