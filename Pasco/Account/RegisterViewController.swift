//
//  RegisterViewController.swift
//  Pasco
//
//  Created by denis on 6/22/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()

    //data
    var ref: DatabaseReference!
    var usernames = [String]() //{ didSet { print(usernames)}}

    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController view has loaded")
        ref = Database.database().reference().child("users")
//        print(ref)
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        setUserEnvironment()
        getUsers()


        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private func setUserEnvironment() {
        errorLabel.alpha = 0
        //if user is somehow mysteriously signed in, load details
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.emailTextField.text = user.email
                self.usernameTextField.text = user.displayName
            } else { }
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        print("description =--= " + message)
    }
    private func getUsers() {
//        var usernames = [String]()
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.usernames.append(document.documentID)
//                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
//        print(usernames)
//        return usernames
    }
    private func makeText(withText text: String, andString string: String) -> String {
        if string.isEmpty { return String(text.dropLast()) }
        return text + string
    }

    @IBAction func registerAction(_ sender: UIButton) {
        // create cleaned version od the text fields and create the user
        let userName = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        validate fields
        if let error = Utilities.validateFields( strings: [
            Constants.RegEx.username            : userName,
            Constants.RegEx.email               : email,
            Constants.RegEx.password            : password
        ]) { showError(error) }
        else if usernames.contains(userName) { showError(Constants.AlertMessages.username_alreadyTaken.rawValue)}
        else {
            Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, err1: Error?) in
                if let err1 = err1 {
                    print("---RegisterVC: Authentication: Error creating user account. show user the error and remain on this scene: \(err1)")
                    self.showError(err1.localizedDescription.description)
                } else {
//                    Firebase user created successfully, now save user info in User table
//                    var docRef: DocumentReference? = nil
                    let user = User(uid: result!.user.uid, email: email, userName: userName)
                    self.db.collection("users").document(user.userName).setData(user.toAnyObject() as! [String : Any]) { err in
                        if let err = err {
                            self.showError(Constants.creatingUserError)
                            print("---RegisterVC: Database: Error writing user to users database. Deleting the user now: \(err)")
                            let user = Auth.auth().currentUser
                            user?.delete { error in
                              if let error = error {
                                self.showError(Constants.creatingUserError)
                                print("---RegisterVC: Authentication: Error deleting user account. Need to add functionality to try to remove user account later: \(error)")
                              } else {
                                print("---RegisterVC: Authentication: User account has been deleted")
                              }
                            }
                        } else {
                            print("---RegisterVC: Database: User added to users database succesfully")
                        }
                    }
//                    userChild.setValue(user.toAnyObject()) { (error, DatabaseReference) in
//                        if let error = error {
//                            print("description =-+-= " + error.localizedDescription.description)
//                            print("debugDescription =-+-= " + error.localizedDescription.debugDescription)
//                            self.showError(error.localizedDescription.description)
//                        } else {
////                            user info successfully saved in User table, now transition to root view
////                            self.presentingViewController?.dismiss(animated: true, completion: nil) //i used to do it this way
//
//                            self.performSegue(withIdentifier: "backToAccountCheck", sender: nil)
//
                }
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField      == usernameTextField { emailTextField.becomeFirstResponder() }
        else if textField == emailTextField { passwordTextField.becomeFirstResponder() }
        else if textField == passwordTextField { confirmPasswordTextField.becomeFirstResponder() }
        else { textField.resignFirstResponder() }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = makeText(withText: textField.text!, andString: string)
        switch textField {
            case usernameTextField:  textField.textColor = (usernames.contains(text) || !Utilities.validate(withType: Constants.RegEx.username, andInput: text).result) ? .red: .white
            case emailTextField:     textField.textColor = !Utilities.validate(withType: Constants.RegEx.email, andInput: text).result ? .red: .white
            case passwordTextField:  textField.textColor = !Utilities.validate(withType: Constants.RegEx.password, andInput: text).result ? .red: .white
            default: let _ = 1
        }
        return true
    }
    
}
