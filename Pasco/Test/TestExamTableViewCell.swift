//
//  TestExamTableViewCell.swift
//  Pasco
//
//  Created by Denis on 8/8/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class TestExamTableViewCell: UITableViewCell {

    @IBOutlet weak var yearPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yearPicker.delegate = self
        yearPicker.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TestExamTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.exam.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.exam[row]
    }

}
