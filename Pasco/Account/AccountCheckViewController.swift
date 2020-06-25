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
    var userIsSignedIn = Bool() { didSet { print("---userIsSignedIn = \(userIsSignedIn)") } }
    
    var handle: AuthStateDidChangeListenerHandle?

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
//            chechIfUserIsSignedIn()
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
    private func checkSignInStatus() -> Bool {
        if Auth.auth().currentUser != nil {
            print("---AccountCheckVC: user is signed in.Segue to AccountVC")
            performSegue(withIdentifier: "toAccountVC", sender: nil)
            return true
        } else {
            print("---AccountCheckVC: user is not signed in. Staying here")
            return false
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool { //if user is not already signed in, then u can create an account or log in
        if let sendingButton = sender as? UIButton, let title = sendingButton.currentTitle, title == Constants.registerButtonText || title == Constants.signInButtonText {
            return false
        } else { return true }
    }
    @IBAction func RegisterAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {
        
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