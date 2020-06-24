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
//    var ref: DatabaseReference!
    var usernames = [String]() { didSet { print(usernames)}}

    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController view has loaded")
//        ref = Database.database().reference().child("users")
//        print(ref)
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        setUserEnvironment()
//        loadUsers2()
        usernames = User.getUsers()


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
}
