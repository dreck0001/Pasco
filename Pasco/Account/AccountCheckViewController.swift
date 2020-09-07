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
    
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var signInButton: DesignableButton!
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
    
//    private func chechIfUserIsSignedIn() {
//        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
//            if let user = user {
//                self.userIsSignedIn = true
//                print("the user is \(user)")
//                self.performSegue(withIdentifier: "toAccountVC", sender: nil)
//            } else {
//                self.userIsSignedIn = false
//            }
//        })
//    }
    
    private func setupEnvironment() {
        registerButton.setTitle(Constants.registerButtonText, for: .normal)
        signInButton.setTitle(Constants.signInButtonText, for: .normal)
    }
    

    @IBAction func RegisterAction(_ sender: UIButton) {
        
    }
  
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Navigation
    private func checkSignInStatus() -> Bool {
            if Auth.auth().currentUser != nil {
                print("---AccountCheckVC: user is signed in. Segue to AccountVC")
    //            getUser(with: user.email!)
                performSegue(withIdentifier: "toAccountVC", sender: nil)
//                present(AccountViewController(), animated: true)
                return true
            } else {
                print("---AccountCheckVC: user is not signed in. Staying here")
                return false
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Utilities.vibrate()
        print("---AccountCheckVC: Prepare")
        if let accountVC = segue.destination.contentViewController as? AccountViewController {
//            let navcon = segue.destination
//            navcon.modalPresentationStyle = .fullScreen
//            segue.destination.modalPresentationStyle = .fullScreen
//            accountVC.modalPresentationStyle = .currentContext
            while user != nil {
                accountVC.user = user
            }
        }
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
    


}
