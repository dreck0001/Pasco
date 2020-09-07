//
//  ExamTableViewCell.swift
//  Pasco
//
//  Created by Denis on 9/5/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {

    @IBOutlet weak var examSubjectYearLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var completionTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
