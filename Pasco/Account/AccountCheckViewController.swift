//
//  AccountCheckViewController.swift
//  Pasco
//
//  Created by denis on 6/21/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase

class AccountCheckViewController: UIViewController {
    
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var signInButton: DesignableButton!
    @IBOutlet weak var verifyButton: DesignableButton!
    @IBOutlet weak var refreshButton: DesignableButton!
    @IBOutlet weak var resendButton: DesignableButton!
    @IBOutlet weak var cancelEmailVerificationButton: UIButton!
    
    var userIsSignedIn = Bool()
    var user: User? { didSet { print("---AccountCheckVC: \(user!)") } }
    
    var handle: AuthStateDidChangeListenerHandle?
    let usersRef = Firestore.firestore().collection("users")

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("---AccountCheckVC: viewWillAppear")
        setupEnvironment()
        userIsSignedIn = checkSignInStatus()
    }
    
    private func setupEnvironment() {
        registerButton.setTitle(Constants.registerButtonText, for: .normal)
        signInButton.setTitle(Constants.signInButtonText, for: .normal)
    }
  
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        userIsSignedIn = false
    }

    // MARK: - Navigation
    private func checkSignInStatus() -> Bool {
        if let user = Auth.auth().currentUser {
            print("---AccountCheckVC: user is signed in.")
            registerButton.isHidden = true
            signInButton.isHidden = true
            user.reload{ (error) in
                if user.isEmailVerified {
                    print("---AccountCheckVC: User's email is already verified")
                    self.performSegue(withIdentifier: "toAccountVC", sender: nil)
                }
                else {
                    print("---AccountCheckVC: User's email is not verified. Show email verification options")
//                  self.presentEmailVerificationAlert()
                    self.verifyLabel.isHidden = false
                    self.verifyButton.isHidden = false
                    self.resendButton.isHidden = false
                    self.refreshButton.isHidden = false
                    self.cancelEmailVerificationButton.isHidden = false
                }
            }
            return true
        } else {
            print("---AccountCheckVC: user is not signed in. Staying here")
            registerButton.isHidden = false
            signInButton.isHidden = false
            verifyLabel.isHidden = true
            verifyButton.isHidden = true
            resendButton.isHidden = true
            refreshButton.isHidden = true
            cancelEmailVerificationButton.isHidden = true
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Utilities.vibrate()
        print("---AccountCheckVC: Prepare")
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool { //if user is not already signed in, then u can create an account or log in
        if let sendingButton = sender as? UIButton, let title = sendingButton.currentTitle, title == Constants.registerButtonText || title == Constants.signInButtonText, userIsSignedIn {
            return false
        } else { return true }
    }
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {
        Utilities.vibrate()
        if let accountVC = segue.source as? AccountViewController {
            print("--AccounChecktVC: prepareForUnwind is called by: \(accountVC.description)")
            signOut()
            print("--AccounChecktVC: Done signing out")
        }
    }
    @IBAction func cancelEmailVerificationPressed(_ sender: UIButton) {
        //        sign out
        signOut()
//        Need to find a way to refresh the view
        self.cancelEmailVerificationButton.isHidden = true
        self.verifyLabel.isHidden = true
        self.verifyButton.isHidden = true
        self.resendButton.isHidden = true
        self.refreshButton.isHidden = true
//        show stuff
        self.registerButton.isHidden = false
        self.signInButton.isHidden = false

    }
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        
    }
    
    


}
