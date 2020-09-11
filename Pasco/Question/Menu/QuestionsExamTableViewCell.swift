//
//  QuestionsExamTableViewCell.swift
//  Pasco
//
//  Created by denis on 9/9/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class QuestionsExamTableViewCell: UITableViewCell {

    @IBOutlet weak var examPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        examPicker.delegate = self
        examPicker.dataSource = self
        
    }
}

extension QuestionsExamTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.exam.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.exam[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update TestMenuViewController.exam
        QuestionsMenuViewController.selection.exam = Constants.exam[row]
        // send notification to TestSubjectTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "examSelected1"), object: nil)
    }
}
