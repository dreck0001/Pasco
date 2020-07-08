//
//  SelectionTableViewCell.swift
//  Pasco
//
//  Created by denis on 5/11/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    let subjects = Constants.Subject.allValues
    @IBOutlet weak var selectionSubjectLabel: UILabel!
    @IBOutlet weak var selectionYearLabel: UILabel!
    @IBOutlet weak var selectionPicker: UIPickerView!
    @IBOutlet weak var expansionIndicatorLabel: UILabel!
    
    
    var selectedSubjectRow = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionPicker.delegate = self
        selectionPicker.dataSource = self
//        selectionPicker.selectRow(0, inComponent: 0, animated: true)
//        selectionPicker.selectRow(0, inComponent: 1, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SelectionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { return Constants.subject_years.count }
        else { return Constants.subject_years[selectedSubjectRow]!.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { return Constants.Subject.allValues[row]?.rawValue }
        else { return String(Constants.subject_years[selectedSubjectRow]![row]) }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("Picker(\(selectionPicker.selectedRow(inComponent: 0)), \(selectionPicker.selectedRow(inComponent: 1)))")
        if component == 0 {
            selectedSubjectRow = selectionPicker.selectedRow(inComponent: 0)
            selectionPicker.selectRow(0, inComponent: 1, animated: true)
        }
//        print("Picker(\(selectionPicker.selectedRow(inComponent: 0)), \(selectionPicker.selectedRow(inComponent: 1)))")
        
        let selectedYearRow = selectionPicker.selectedRow(inComponent: 1)
        selectionSubjectLabel.text = "\(Constants.Subject.allValues[selectedSubjectRow]!.rawValue)    -"
        selectionYearLabel.text    = "    \(Constants.subject_years[selectedSubjectRow]![selectedYearRow])"
        selectionPicker.reloadAllComponents()
        QuestionsViewController.selectedSubject_Year = (Constants.Subject.allValues[selectedSubjectRow]!.rawValue, Constants.subject_years[selectedSubjectRow]![selectedYearRow])


    }
}

