//
//  QuestionTableViewCell.swift
//  Pasco
//
//  Created by Denis on 6/13/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionALabel: UILabel!
    @IBOutlet weak var optionBLabel: UILabel!
    @IBOutlet weak var optionCLabel: UILabel!
    @IBOutlet weak var optionDLabel: UILabel!
    @IBOutlet weak var optionELabel: UILabel!
    
    @IBOutlet weak var optionALetter: UILabel!
    @IBOutlet weak var optionBLetter: UILabel!
    @IBOutlet weak var optionCLetter: UILabel!
    @IBOutlet weak var optionDLetter: UILabel!
    @IBOutlet weak var optionELetter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
