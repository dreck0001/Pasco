//
//  Test3OptionTableViewCell.swift
//  Pasco
//
//  Created by denis on 7/20/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class Test3OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
