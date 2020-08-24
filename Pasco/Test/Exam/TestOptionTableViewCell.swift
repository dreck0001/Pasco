//
//  TestOptionTableViewCell.swift
//  Pasco
//
//  Created by Denis on 8/14/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class TestOptionTableViewCell: UITableViewCell {
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
