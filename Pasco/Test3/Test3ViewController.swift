//
//  Test3ViewController.swift
//  Pasco
//
//  Created by denis on 7/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase

class Test3ViewController: UIViewController {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var BeginBArItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var numOfCells = 6
    private static var questions: [Question]? {
        didSet {
            print("questions: \(questions)")
        }
    }
    private static var curQuestionNumber = 1
    private static var curQuestion: Question? {
        if questions?.isEmpty ?? true { return nil }
        return questions![curQuestionNumber]
    }

    var subjectYear: (sub: Int, yr: Int)? {
        didSet {
            updateUI()
            updateQuestions()
        }
    }
    private func updateQuestions() {
        if let subject = Constants.Subject.allValues[subjectYear!.sub],
            let year = Constants.subject_years[subjectYear!.sub]?[subjectYear!.yr] {
            Test3ViewController.questions = Utilities.alreadyLoadedQuestionSets[subject.rawValue + "_" + String(year)]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver( self,
                                           selector: #selector(onDidReceiveData(_:)),
                                           name: NSNotification.Name(rawValue: "questionsLoaded"),
                                           object: nil
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("test3VC: Notification recieved! upating questions")
        updateQuestions()
//        tableView.reloadData()
    }
    
    private func updateUI() {
        if Utilities.userIsSignedIn() {
            if let subYr = subjectYear {
                if let subject = Constants.Subject.allValues[subYr.sub],
                    let year = Constants.subject_years[subYr.sub]?[subYr.yr] {
                    title = "\(subject) - \(year)"
                    if leftLabel != nil { leftLabel.text = "Ready" }
                    BeginBArItem.isEnabled = true
                }
            } else {
                BeginBArItem.isEnabled = false
                title = "Select a test"
                if leftLabel != nil { leftLabel.text = "" }
            }
        } else {
            BeginBArItem.isEnabled = false
            title = "Sign in to take a test"
            if leftLabel != nil { leftLabel.text = "" }
        }
    }
    
    @IBAction func beginAction(_ sender: UIBarButtonItem) {
        tableView.reloadData()
        switch sender.title {
        case Constants.testBeginButtonText:
            BeginBArItem.title = Constants.testStopButtonText
        case Constants.testStopButtonText:
            BeginBArItem.title = Constants.testBeginButtonText
        default:
            BeginBArItem.title = Constants.testContinueButtonText
        }
    }
    
    
}
extension Test3ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Test3ViewController.curQuestion != nil && Test3ViewController.curQuestion?.optionE != "" { numOfCells = 7 }
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestQuestion.rawValue, for: indexPath)
//            cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            cell.textLabel?.text = Test3ViewController.curQuestion?.question
            return cell
        case numOfCells - 1:
            return tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestNextQuestion.rawValue, for: indexPath)
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestOption.rawValue, for: indexPath) as! Test3OptionTableViewCell
            switch indexPath.row {
            case 1: cell.checkBoxImage.image = UIImage(systemName: "a.square")
            case 2: cell.checkBoxImage.image = UIImage(systemName: "b.square")
            case 3: cell.checkBoxImage.image = UIImage(systemName: "c.square")
            case 4: cell.checkBoxImage.image = UIImage(systemName: "d.square")
            case 5: cell.checkBoxImage.image = UIImage(systemName: "e.square")
            default:cell.checkBoxImage.image = UIImage(systemName: "square")}
            return cell
        }
    }
    

}
