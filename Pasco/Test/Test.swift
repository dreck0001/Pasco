//
//  Test.swift
//  Pasco
//
//  Created by Denis on 8/14/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import Firebase

class Test {
    var user: Pasco.User?
    enum Status { case NotStarted, Started, Paused, Stopped }
    var status: Status = .NotStarted { didSet { print(status) } }
    var answers = [Int : String]()
    var chosen = [Int : String]()
    var results = [Int : Bool]()
    var totalTime = (min: 0, sec: 0)
    var completionTime = Timestamp()
    var percent = Double()
//    var exam: String!
//    var sub: String?
//    var yr: Int?

    func gradeTest() {
        print("Test: gradeTest called")
        
        for num in 1...answers.count {
            print("\(num): \(chosen[num]!) --- \(answers[num]!) = \(results[num]!)")
        }
    }
    
    func calcGrade() -> (percent: Double, correct: Int, total: Int) {
        var correct = 0.0
        for res in results { if res.value == true { correct += 1 } }
        let total = Double(results.count)
        percent = (correct / total) * 100
//            print("Grade: \(percent)%\n\(correct) out of \(total) correct")
        return (percent.round(to: 2), Int(correct), Int(total))
    }
    
    func getUser(){
        let usersRef = Firestore.firestore().collection("users")
        if let curUser = Auth.auth().currentUser {
            usersRef.whereField("email", isEqualTo: curUser.email!).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("---AccountVC: Eror Could not find the userinfo using the email: \(err)")
                } else {
                    if querySnapshot!.count > 1 {
                        print("---AccountVC: email returned more than 1 user. Investigate why!: \(querySnapshot!.documents)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            self.user = Pasco.User(data: data)
                        }
                    }
                }
            }
        }
    }
}
