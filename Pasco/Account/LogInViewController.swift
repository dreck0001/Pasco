//
//  LogInViewController.swift
//  Pasco
//
//  Created by denis on 6/21/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---LogInVC")
        setupEnvironment()

        // Do any additional setup after loading the view.
    }
    
    private func setupEnvironment() {
        signInButton.setTitle(Constants.signInButtonText, for: .normal)
        errorLabel.alpha = 0
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        print("description =--= " + message)
    }
    @IBAction func signInAction(_ sender: UIButton) {
    //create cleaned version od the text fields and create the user
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    //validate fields
        if let error = Utilities.checkStringsForBlank(strings: [email, password]) { showError(error) }
        else {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//                guard let strongSelf = self else { return }
                guard let error = error else {
                    if let navcon = self?.parent as? UINavigationController {
                        navcon.popViewController(animated: true)
                    }
                    return
                }
                self?.showError(error.localizedDescription)
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

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField      == emailTextField { passwordTextField.becomeFirstResponder() }
        else { textField.resignFirstResponder() }
        return false
    }
}

