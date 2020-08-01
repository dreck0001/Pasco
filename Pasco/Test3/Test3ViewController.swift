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
    var test = Test()
    
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
        print("testVC: vieeDidLoad")
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        Test3ViewController.questions = nil
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver( self,
//                                           selector: #selector(onDidReceiveData(_:)),
//                                           name: NSNotification.Name(rawValue: "questionsLoaded"),
//                                           object: nil
//        )
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        Test3ViewController.questions = nil
//        NotificationCenter.default.removeObserver(self)
        
    }
//    @objc func onDidReceiveData(_ notification:Notification) {
//        Do something now
//        print("test3VC: Notification recieved! upating questions")
//        updateQuestions()
//        tableView.reloadData()
//    }
    
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
        switch sender.title {
        case Constants.testBeginButtonText:
            BeginBArItem.title = Constants.testStopButtonText
            updateQuestions()
            tableView.reloadData()
            initializeTime()
        case Constants.testStopButtonText:
            BeginBArItem.title = Constants.testBeginButtonText
            stopTime()
        default:
            BeginBArItem.title = Constants.testContinueButtonText
        }
    }
    
    // MARK: - Timer
    private var timer:Timer?
    private var mins = 2
    private var secs = 0
    private var timeLeft = String() {
        didSet {
            print(timeLeft)
            rightLabel.text = timeLeft
        }
    }
    
    private func stopTime() {
        timer?.invalidate()
        timer = nil
    }
    
    private func initializeTime() {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
        @objc func onTimerFires()
        {
            if mins < 0 {
                stopTime()
            } else {
                if secs < 10 { timeLeft = "\(mins):0\(secs)" }
                else { timeLeft = "\(mins):\(secs)" }
                
                if secs <= 0 {
                    secs = 60
                    mins -= 1
                }
            }
        secs -= 1
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
            case 1:
                cell.checkBoxImage.image = UIImage(systemName: "a.square")
                cell.optionLabel.text = Test3ViewController.curQuestion?.optionA
            case 2:
                cell.checkBoxImage.image = UIImage(systemName: "b.square")
                cell.optionLabel.text = Test3ViewController.curQuestion?.optionB
            case 3:
                cell.checkBoxImage.image = UIImage(systemName: "c.square")
                cell.optionLabel.text = Test3ViewController.curQuestion?.optionC
            case 4:
                cell.checkBoxImage.image = UIImage(systemName: "d.square")
                cell.optionLabel.text = Test3ViewController.curQuestion?.optionD
            case 5:
                cell.checkBoxImage.image = UIImage(systemName: "e.square")
                cell.optionLabel.text = Test3ViewController.curQuestion?.optionE
            default:cell.checkBoxImage.image = UIImage(systemName: "square")}
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    

}
