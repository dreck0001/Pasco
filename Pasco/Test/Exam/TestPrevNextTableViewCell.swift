//
//  TestPrevNextTableViewCell.swift
//  Pasco
//
//  Created by Denis on 8/14/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class TestPrevNextTableViewCell: UITableViewCell {

    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func prevNextAction(_ sender: UIButton) {
        if sender.titleLabel?.text == Constants.testPrevButtonText {
            if TestViewController.curQuestionNumber > 1 {
                TestViewController.curQuestionNumber -= 1
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil)
            }
        }
        if sender.titleLabel?.text == Constants.testNextButtonText {
            if TestViewController.curQuestionNumber < 40 {
                TestViewController.curQuestionNumber += 1
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
