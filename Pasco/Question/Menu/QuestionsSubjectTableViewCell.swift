//
//  QuestionsSubjectTableViewCell.swift
//  Pasco
//
//  Created by denis on 9/9/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class QuestionsSubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectPicker: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
        
        NotificationCenter.default.addObserver( self, selector: #selector(onDidSelectExam(_:)), name: NSNotification.Name(rawValue: "examSelected1"), object: nil )

    }
    
    @objc func onDidSelectExam(_ notification:Notification) {
            // reset the picker to first element
            subjectPicker.selectRow(0, inComponent: 0, animated: true)
            subjectPicker.reloadAllComponents()
            // update TestMenuViewController.selection.subject
            let selectedSubRow = subjectPicker.selectedRow(inComponent: 0)
            if QuestionsMenuViewController.selection.exam == Constants.bece {
                let selectedSub = Constants.Subject.allValues[selectedSubRow]?.rawValue
                QuestionsMenuViewController.selection.subject = selectedSub ?? "Error1"
            } else if QuestionsMenuViewController.selection.exam == Constants.wassce {
                let selectedSub = Constants.Wassce.data[selectedSubRow]?.sub
                QuestionsMenuViewController.selection.subject = selectedSub ?? "Error2"
            }
            // send notification to TestYearTableViewCell
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subjectSelected1"), object: nil)
        }
}

extension QuestionsSubjectTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            return Constants.Subject.allValues.count
        } else { return Constants.Wassce.data.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            return Constants.Subject.allValues[row]?.rawValue
        } else {
            let selectedSub = Constants.Wassce.data[row]?.sub
            return selectedSub ?? "Error3"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update TestMenuViewController.selection.subject
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            QuestionsMenuViewController.selection.subject = String(Constants.Subject.allValues[row]?.rawValue ?? "Error5" )
        } else if QuestionsMenuViewController.selection.exam == Constants.wassce {
            QuestionsMenuViewController.selection.subject = Constants.Wassce.data[row]?.sub ?? "Error4"
        }
        // send notification to TestYearTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subjectSelected1"), object: nil)
    }
}

