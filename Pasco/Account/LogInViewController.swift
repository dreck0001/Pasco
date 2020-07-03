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
