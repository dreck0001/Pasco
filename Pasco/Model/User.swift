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
    let key: String!
    let uid: String!
    let email: String!
    let userName: String!
    let itemRef: DatabaseReference?


    init(uid: String, email: String, userName: String, key: String = "") {
        self.key = key
        self.email = email
        self.userName = userName
        self.itemRef = nil
        self.uid = uid
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        if let snapshotVDict = snapshot.value as? NSDictionary {
            if let userEmail        = snapshotVDict["Email"] as? String         { email = userEmail }         else { email = "" }
            if let userUserName     = snapshotVDict["UserName"] as? String      { userName = userUserName }   else { userName = "" }
            if let userUid          = snapshotVDict["UID"] as? String           { uid = userUid }             else { uid = "" }
        }
        else { uid = ""; email = ""; userName = ""; }
    }
    
    func toAnyObject() -> Any {
        return [
            "Email"     : email as Any,
            "UserName"  : userName as Any,
            "UID"       : uid as Any
        ]
    }
    
    static func getUsers() -> [String] {
        var usernames = [String]()
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    usernames.append(document.documentID)
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        return usernames
    }
    
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
