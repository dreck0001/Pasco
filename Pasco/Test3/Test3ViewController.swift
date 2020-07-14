//
//  Test3ViewController.swift
//  Pasco
//
//  Created by denis on 7/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class Test3ViewController: UIViewController {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    var subject: Int? { didSet { print("---Test3VC: subject = \(subject!)") } }
    var year: Int? { didSet { print("---Test3VC: year = \(year!)") } }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()

    }
    
    private func updateUI() {
        subjectLabel.text = subject?.description
        yearLabel.text = year?.description    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
