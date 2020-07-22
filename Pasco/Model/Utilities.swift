//
//  Utilities.swift
//  Pasco
//
//  Created by denis on 6/24/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class Utilities {
    
    static var questions = [Question]() {
        didSet {
            // sort by number, add to alreadyLoadedQuestionSets, reload
            questions.sort(by: { (q1, q2) -> Bool in return q1.number < q2.number }, stable: true)
            Utilities.alreadyLoadedQuestionSets[QuestionsViewController.incomingName] = questions
            print("alreadyLoadedQuestionSets.keys: \(Utilities.alreadyLoadedQuestionSets.keys)")
        }
    }
    static var alreadyLoadedQuestionSets = [String: [Question]]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "questionsLoaded"), object: nil)

        }
    }
    static func loadQuestionSet(sub: String, yr: Int) {
//        if alreadyLoadedQuestionSets is empty, lead questions from firebase
        if Utilities.alreadyLoadedQuestionSets.isEmpty {
            loadQuestionSetFromFirebase(sub: sub, yr: yr)
            return
        } else {  //else if alreadyLoadedQuestionSets contains the questions, do nothing
            let incomingName = sub + "_" + String(yr)
            let loadedNames = Array(Utilities.alreadyLoadedQuestionSets.keys)
            for name in loadedNames {
                if String(name) == incomingName { // it already exists, just update alreadyLoadedQuestionSets
                    questions = Utilities.alreadyLoadedQuestionSets[incomingName]!
                    return
                }
            }
            // it doesn't exist so load, display and store it
            loadQuestionSetFromFirebase(sub: sub, yr: yr)
        }
    }
    
    static func loadQuestionSetFromFirebase(sub: String, yr: Int) {
        let db = Firestore.firestore()
        db.collection("BECE/" + sub + "/" + String(yr)).getDocuments { (querySnapshot, error) in
            if let error = error { print("error getting data: " + error.localizedDescription) }
            else {
                if let snapshot = querySnapshot {
                    let questions = snapshot.documents.compactMap({ (document) in return Question(data: document.data()) })
                    self.questions = questions
                }
            }
        }
    }
    static func validate(withType type: Constants.RegEx, andInput input: String) -> (result: Bool, msg: String?) {
        let stringTest = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        let alertMessage: String
        switch type {
            case .email:                        alertMessage = Constants.AlertMessages.email.rawValue
            case .username:                     alertMessage = Constants.AlertMessages.username.rawValue
            case .alphaStringFirstLetterCaps:   alertMessage = Constants.AlertMessages.alphaStringFirstLetterCaps.rawValue
            case .alphaStringWithSpace1:        alertMessage = Constants.AlertMessages.alphaStringWithSpace1.rawValue
            case .alphaStringWithSpace2:        alertMessage = Constants.AlertMessages.alphaStringWithSpace2.rawValue
            case .phoneNo:                      alertMessage = Constants.AlertMessages.phoneNo.rawValue
            case .password:                     alertMessage = Constants.AlertMessages.password.rawValue
        }
        return (stringTest.evaluate(with: input)) ? (true, nil) : (false, alertMessage)
    }
    
    static func validateFields(strings : [Constants.RegEx : String]) -> String? {
        let values = Array(strings.values)
        if let error = checkStringsForBlank(strings: values) { return error }
        for type_string in strings {
            let result = validate(withType: type_string.key, andInput: type_string.value)
            if let errorMsg = result.msg { return errorMsg }
        }
        return nil
    }
    
    static func checkStringsForBlank(strings : [String]) -> String? {
        for string in strings {
            if string == "" { return Constants.fillAllFieldsError }
        }
        return nil
    }

}
extension UIViewController{
    var contentViewController: UIViewController?{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else {return self }
    }
}
extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
//        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
    }
}
