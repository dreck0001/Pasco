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
    private enum PrevNextDisableText: String { case None, All, Prev, Next }
    private var disableText = PrevNextDisableText.None {
        didSet {
            tableView.reloadData()
        }
    }
    
        
    private var numOfCells = 6
    private static var questions: [Question]? {
        didSet {
            print("questions: \(questions)")
        }
    }
    static var curQuestionNumber = 1 {
        didSet {
            print(curQuestionNumber)
        }
    }
    private static var curQuestion: Question? {
        if questions?.isEmpty ?? true { return nil }
        return questions![ curQuestionNumber - 1 ]
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
        Test3ViewController.questions = nil
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver( self,
//                                           selector: #selector(onDidReceiveData(_:)),
//                                           name: NSNotification.Name(rawValue: "questionsLoaded"),
//                                           object: nil
//        )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Test3ViewController.curQuestionNumber = 1
        updateUI()
        NotificationCenter.default.addObserver( self, selector: #selector(onPrevNextPressed(_:)), name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("test3VC: viewWillDisappear")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func onPrevNextPressed(_ notification:Notification) {
        // Do something now
        print("test3VC: PrevNext pressed! Reloading tableView!!")
        tableView.reloadData()
        updateLeftLabel()
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
    private func updateLeftLabel() {
        if let questions = Test3ViewController.questions, !questions.isEmpty {
                leftLabel.text = "\(Test3ViewController.curQuestionNumber) of \(questions.count)"
        }
    }

    
    @IBAction func beginAction(_ sender: UIBarButtonItem) {
        switch sender.title {
        case Constants.testBeginButtonText:
            BeginBArItem.title = Constants.testStopButtonText
            updateQuestions()
            tableView.reloadData()
            updateLeftLabel()
            initializeTime()
        case Constants.testStopButtonText:
            presentStopAlert()
        case Constants.testContinueButtonText:
            BeginBArItem.title = Constants.testStopButtonText
            initializeTime()
            disableText = .None
        default:
            BeginBArItem.title = Constants.testContinueButtonText
        }
    }
    private func presentStopAlert() {
        let alert = UIAlertController(title: "Finish Testing?", message: "You may want to double-check your answers before submitting.", preferredStyle: .alert)
        let doubleCheckAction = UIAlertAction(title: "Double-check", style: .default) { (_) in
            if self.timerIsStopped {
                Test.status = .Stopped
                self.test.gradeTest()
            }
        }
        let pauseAction = UIAlertAction(title: "Pause Test", style: .default) { (_) in
            if self.timerIsStopped {
                self.disableText = .None
                Test.status = .Stopped
                self.test.gradeTest()
            }
            else {
                self.stopTime()
                Test.status = .Paused
                self.BeginBArItem.title = Constants.testContinueButtonText
                self.disableText = .All
            }
        }
        let finishCheckAction = UIAlertAction(title: "Finish!", style: .destructive) { (_) in
            self.stopTime()
            self.disableText = .None
            self.test.gradeTest()
            self.BeginBArItem.title = Constants.testBeginButtonText
            self.BeginBArItem.isEnabled = false
        }
        
        alert.addAction(doubleCheckAction)
        alert.addAction(pauseAction)
        alert.addAction(finishCheckAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Timer
    private var timer:Timer?
    private var mins = 40 {
        didSet {
            if mins < 0 {
                BeginBArItem.isEnabled = false
            }
        }
    }
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
        Test.status = .Stopped
    }
    private var timerIsStopped: Bool {
        return mins < 0
    }
    
    private func initializeTime() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        Test.status = .Started
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
    // MARK: - Navigation

    
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
            let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestNextQuestion.rawValue, for: indexPath) as! Test3PrevNextTableViewCell
            cell.prevButton.titleLabel?.text = Constants.testPrevButtonText
            cell.nextButton.titleLabel?.text = Constants.testNextButtonText
            if let questions = Test3ViewController.questions, !questions.isEmpty {
                cell.prevButton.isEnabled = true; cell.nextButton.isEnabled = true
            } else { cell.prevButton.isEnabled = false; cell.nextButton.isEnabled = false }
            
            switch disableText {
            case .All:
                cell.prevButton.isEnabled = false; cell.nextButton.isEnabled = false
            case .Prev:
                cell.prevButton.isEnabled = false; cell.nextButton.isEnabled = true
            case .Next:
                cell.prevButton.isEnabled = true; cell.nextButton.isEnabled = false
            case .None:
                cell.prevButton.isEnabled = true; cell.nextButton.isEnabled = true

            }
            return cell
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
// test
