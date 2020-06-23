//
//  LogInViewController.swift
//  Pasco
//
//  Created by denis on 6/21/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("i am in \(self.description)")
//        setUserEnvironment()
//        performSegue(withIdentifier: "test", sender: nil)
//        performSegue(withIdentifier: "test2", sender: nil)
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
