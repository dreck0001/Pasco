//
//  QuesstionYearTableViewCell.swift
//  Pasco
//
//  Created by denis on 9/8/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class QuesstionYearTableViewCell: UITableViewCell {

    @IBOutlet weak var yearPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        NotificationCenter.default.addObserver( self, selector: #selector(onDidSelectSubject(_:)), name: NSNotification.Name(rawValue: "subjectSelected1"), object: nil )
    }
    
     @objc func onDidSelectSubject(_ notification:Notification) {
//        print("TestYrVC:  subjectSelected recieved! Reloading cell!!")
        // reset the picker to first element
        yearPicker.selectRow(0, inComponent: 0, animated: true)
        yearPicker.reloadAllComponents()
        
        // update QuestionsMenuViewController.selection.year
        let selectedYrRow = yearPicker.selectedRow(inComponent: 0)
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            let selectedSub = QuestionsMenuViewController.selection.subject
            let subKey = Constants.Subject.findKey(With: selectedSub)
            let yr = Constants.subject_years[subKey]![selectedYrRow]
            QuestionsMenuViewController.selection.year = yr
        } else if QuestionsMenuViewController.selection.exam == Constants.wassce {
            let yrs = Constants.Wassce.data[selectedYrRow]?.yrs
            QuestionsMenuViewController.selection.year = yrs![selectedYrRow]
        }
    }
}

extension QuesstionYearTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            let subjectKey = Constants.Subject.findKey(With: QuestionsMenuViewController.selection.subject)
            return Constants.subject_years[subjectKey]!.count
        } else { return Constants.Wassce.findYearCount(With: QuestionsMenuViewController.selection.subject) }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            let subjectKey = Constants.Subject.findKey(With: QuestionsMenuViewController.selection.subject)
            return String(Constants.subject_years[subjectKey]![row])
        } else {
            let subjectKey = Constants.Wassce.findKey(With: QuestionsMenuViewController.selection.subject)
            return String(Constants.Wassce.data[subjectKey]!.yrs[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update QuestionsMenuViewController.selection.year
        if QuestionsMenuViewController.selection.exam == Constants.bece {
            let subjectKey = Constants.Subject.findKey(With: QuestionsMenuViewController.selection.subject)
            QuestionsMenuViewController.selection.year = Constants.subject_years[subjectKey]?[row] ?? 1000
        } else {
            let subjectKey = Constants.Wassce.findKey(With: QuestionsMenuViewController.selection.subject)
            QuestionsMenuViewController.selection.year = Constants.Wassce.data[subjectKey]?.yrs[row] ?? 1000
        }
    }
}



