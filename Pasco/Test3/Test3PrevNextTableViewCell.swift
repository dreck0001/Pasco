//
//  Test3PrevNextTableViewCell.swift
//  Pasco
//
//  Created by Denis on 8/1/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class Test3PrevNextTableViewCell: UITableViewCell {

    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func prevNextAction(_ sender: UIButton) {
        if sender.titleLabel?.text == Constants.testPrevButtonText {
            if Test3ViewController.curQuestionNumber > 1 {
                Test3ViewController.curQuestionNumber -= 1
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil)
            }
        }
        if sender.titleLabel?.text == Constants.testNextButtonText {
            if Test3ViewController.curQuestionNumber < 40 {
                Test3ViewController.curQuestionNumber += 1
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
