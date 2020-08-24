//
//  TestViewController.swift
//  Pasco
//
//  Created by denis on 8/12/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    var test = Test()

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var beginBarItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private enum PrevNextDisableText: String { case None, All, Prev, Next }
    private var disableText = PrevNextDisableText.None { didSet { tableView.reloadData() } }
    private var numOfCells = 6
    private static var questions: [Question]?
    static var curQuestionNumber = 1 { didSet { print(curQuestionNumber) } }
    private static var curQuestion: Question? {
        if questions?.isEmpty ?? true { return nil }
        return questions![ curQuestionNumber - 1 ]
    }
    var examSubjectYear: (exam: String, subject: String, year: Int)? {
        didSet {
            updateUI()
            updateQuestions()
        }
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        TestViewController.questions = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        TestViewController.curQuestionNumber = 1
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("testVC: viewWillDisappear")
    }
    
    // MARK: - IBActions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        switch Test.status {
        case .Started, .Paused:
            presentStartedAlert()
        case .NotStarted, .Stopped:
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func beginAction(_ sender: UIBarButtonItem) {
        switch sender.title {
        case Constants.testBeginButtonText:
            beginBarItem.title = Constants.testStopButtonText
            updateQuestions()
            tableView.reloadData()
            updateLeftLabel()
            initializeTime()
        case Constants.testStopButtonText:
            presentStopAlert()
        case Constants.testContinueButtonText:
            beginBarItem.title = Constants.testStopButtonText
            initializeTime()
            disableText = .None
        default:
            beginBarItem.title = Constants.testContinueButtonText
        }
    }
    
    @IBAction func prevNextAction(_ sender: UIButton) {
        if sender.titleLabel?.text == Constants.testPrevButtonText {
            if TestViewController.curQuestionNumber > 1 {
                TestViewController.curQuestionNumber -= 1
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil)
            }
        }
        if sender.titleLabel?.text == Constants.testNextButtonText {
            if TestViewController.curQuestionNumber < 40 {
                TestViewController.curQuestionNumber += 1
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prevNextPressed"), object: nil)
            }
        }
        tableView.reloadData()
        updateLeftLabel()
    }
    
    
    
    // MARK: - My Fuctions
    private func updateQuestions() {
        if let exam = examSubjectYear?.exam, let subject = examSubjectYear?.subject, let year = examSubjectYear?.year {
            TestViewController.questions = Utilities.alreadyLoadedQuestionSets[subject + "_" + String(year)]
        }
    }
    private func updateUI() {
        print("testVC: examSubjectYear: \(examSubjectYear!)")
            if let selection = examSubjectYear {
                title = "\(selection.exam) | \(selection.subject) | \(selection.year)"
                if leftLabel != nil { leftLabel.text = "Ready" }
                beginBarItem.isEnabled = true
            } else {
                beginBarItem.isEnabled = false
                title = "Exam/Year not selected"
                if leftLabel != nil { leftLabel.text = "" }
            }
        }
    private func updateLeftLabel() {
        if let questions = TestViewController.questions, !questions.isEmpty {
                leftLabel.text = "\(TestViewController.curQuestionNumber) of \(questions.count)"
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
                self.beginBarItem.title = Constants.testContinueButtonText
                self.disableText = .All
            }
        }
        let finishCheckAction = UIAlertAction(title: "Finish!", style: .destructive) { (_) in
            self.stopTime()
            self.disableText = .None
            self.test.gradeTest()
            self.beginBarItem.title = Constants.testBeginButtonText
            self.beginBarItem.isEnabled = false
        }
        
        alert.addAction(doubleCheckAction)
        alert.addAction(pauseAction)
        alert.addAction(finishCheckAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentStartedAlert() {
        let alert = UIAlertController(title: "Exam in Progress", message: "Are you sure you want to discard this exam?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default) { (_) in
            if self.timerIsStopped {
                Test.status = .Stopped
                self.test.gradeTest()
            }
        }
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.stopTime()
            self.disableText = .None
            self.test.gradeTest()
            self.beginBarItem.title = Constants.testBeginButtonText
            self.beginBarItem.isEnabled = false
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Timer
    private var timer:Timer?
    private var mins = 40 {
        didSet {
            if mins < 0 {
                beginBarItem.isEnabled = false
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
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("testVC: prepare")
     }
}

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TestViewController.curQuestion != nil && TestViewController.curQuestion?.optionE != "" { numOfCells = 7 }
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestQuestion.rawValue, for: indexPath)
            cell.textLabel?.text = TestViewController.curQuestion?.question
            return cell
        case numOfCells - 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestNextQuestion.rawValue, for: indexPath) as! TestPrevNextTableViewCell
            cell.prevButton.titleLabel?.text = Constants.testPrevButtonText
            cell.nextButton.titleLabel?.text = Constants.testNextButtonText
            if let questions = TestViewController.questions, !questions.isEmpty {
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
            let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestOption.rawValue, for: indexPath) as! TestOptionTableViewCell
            switch indexPath.row {
            case 1:
                cell.checkBoxImage.image = UIImage(systemName: "a.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionA
            case 2:
                cell.checkBoxImage.image = UIImage(systemName: "b.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionB
            case 3:
                cell.checkBoxImage.image = UIImage(systemName: "c.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionC
            case 4:
                cell.checkBoxImage.image = UIImage(systemName: "d.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionD
            case 5:
                cell.checkBoxImage.image = UIImage(systemName: "e.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionE
            default:cell.checkBoxImage.image = UIImage(systemName: "square")}
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

