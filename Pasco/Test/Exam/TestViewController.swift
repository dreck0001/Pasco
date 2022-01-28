//
//  TestViewController.swift
//  Pasco
//
//  Created by denis on 8/12/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {
    var test = Test() {
        didSet {
            
        }
    }

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
    private var shouldDisplayAnswers = false { didSet { print("shouldDisplayAnswers: \(shouldDisplayAnswers)"); tableView.reloadData() } }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        test.getUser()
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
        switch test.status {
        case .Started, .Paused:
            presentStartedAlert()
        case .NotStarted, .Stopped:
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func beginAction(_ sender: UIBarButtonItem) {
        Utilities.vibrate()
        switch sender.title {
        case Constants.testBeginButtonText:
            beginBarItem.title = Constants.testStopButtonText
            updateQuestions()
            tableView.reloadData()
            updateLeftLabel()
            initializeTime()
            initializeGradeBook()
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
        if test.status != .NotStarted {
            Utilities.vibrate()
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
    }
    
    // MARK: - My Fuctions
    private func uploadGrade() {
        var results = [Bool]()
        for num in 1...test.results.count { results.append(test.results[num] ?? false) }
        if let user = test.user {
            print("Uploading grade for user: \(user)")
            let gradeRef = Firestore.firestore().collection("users").document(user.username).collection("grades")
            gradeRef.document("\(Date())").setData(
                [
                          "exam" : examSubjectYear?.exam as Any,
                       "subject" : examSubjectYear?.subject as Any,
                          "year" : examSubjectYear?.year as Any,
                       "results" : results,
                       "percent" : test.percent,
                   "durationMin" : test.totalTime.min,
                   "durationSec" : test.totalTime.sec,
                "completionTime" : test.completionTime
                ]
            )
        }
    }
    
    private func showGrade() {
        
        func presentGradeAlert() {
            let grade = test.calcGrade()
            let alert = UIAlertController(title: "\(grade.percent)%", message: "\(grade.correct) correct out of \(grade.total) questions", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in

            }
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        presentGradeAlert()
    }

    private func initializeGradeBook() {
        if let questions = TestViewController.questions {
            for question in questions {
                test.answers[question.number] = question.answerLetter
                test.chosen[question.number] = Constants.testNoAnswerOption
                test.results[question.number] = false
            }
        }
    }

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

        }
        let pauseAction = UIAlertAction(title: "Pause Exam", style: .default) { (_) in
            self.stopTime()
            self.test.status = .Paused
            self.beginBarItem.title = Constants.testContinueButtonText
            self.disableText = .All
        }
        let finishCheckAction = UIAlertAction(title: "Finish!", style: .destructive) { (_) in
            self.stopTime()
            self.disableText = .None
            self.test.gradeTest()
            self.showGrade()
            self.uploadGrade()
            if self.shouldDisplayAnswers == false { self.shouldDisplayAnswers = true }
            self.beginBarItem.title = Constants.testBeginButtonText
            self.beginBarItem.isEnabled = false
        }
        
        alert.addAction(doubleCheckAction)
        alert.addAction(pauseAction)
        alert.addAction(finishCheckAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentStartedAlert() {
        let alert = UIAlertController(title: "Close Exam?", message: "All progress will be discarded", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default) { (_) in

        }
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.stopTime()
            self.disableText = .None
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Timer
    private var timer:Timer?
    private var mins = 40 {
//    private var mins = 1 {
        didSet {
            if mins < 0 {
                beginBarItem.isEnabled = false
                disableText = .None
                test.status = .Stopped
                test.gradeTest()
                showGrade()
                uploadGrade()
                if shouldDisplayAnswers == false { shouldDisplayAnswers = true }
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
        test.status = .Stopped
        test.totalTime = mins < 40 ? (39 - mins, 60 - secs) : (0, 0)
    }
    private var timerIsStopped: Bool {
        return mins < 0
    }
    
    private func initializeTime() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        test.status = .Started
        }
    
    @objc func onTimerFires()
    {
//            stop timer if mins is < 0
        if mins < 0 {
            stopTime()
        } else {
//                set the timeLeft string appropriately
            if secs < 10 { timeLeft = "\(mins):0\(secs)" }
            else { timeLeft = "\(mins):\(secs)" }
//                decrement min and reset secs when secs reaches 0
            if secs <= 0 {
                secs = 60
                mins -= 1
            }
//                vibrate each sec in the last 10 secs
            if mins < 1 && secs < 11 { Utilities.vibrate() }
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
            cell.optionLabel.backgroundColor = nil //reset color to avoid multiple colored cells
            switch indexPath.row {
            case 1:
                cell.checkBoxImage.image = UIImage(systemName: "a.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionA
                if test.chosen[TestViewController.curQuestionNumber] == "A" {
                    cell.checkOptionView.isHidden = false
                    if shouldDisplayAnswers {
                        cell.checkOptionView.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "A") ? Constants.correctColor : Constants.wrongColor
                        cell.optionLabel.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "A") ? Constants.correctColor : Constants.wrongColor
                    }
                } else {
                    cell.checkOptionView.isHidden = true
                    if shouldDisplayAnswers && test.answers[TestViewController.curQuestionNumber] == "A" {
                        cell.optionLabel.backgroundColor = Constants.correctColor
                    }
                }
            case 2:
                cell.checkBoxImage.image = UIImage(systemName: "b.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionB
                if test.chosen[TestViewController.curQuestionNumber] == "B" {
                    cell.checkOptionView.isHidden = false
                    if shouldDisplayAnswers {
                        cell.checkOptionView.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "B") ? Constants.correctColor : Constants.wrongColor
                        cell.optionLabel.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "B") ? Constants.correctColor : Constants.wrongColor
                    }
                } else {
                    cell.checkOptionView.isHidden = true
                    if shouldDisplayAnswers && test.answers[TestViewController.curQuestionNumber] == "B" {
                        cell.optionLabel.backgroundColor = Constants.correctColor
                    }
                }
            case 3:
                cell.checkBoxImage.image = UIImage(systemName: "c.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionC
                if test.chosen[TestViewController.curQuestionNumber] == "C" {
                    cell.checkOptionView.isHidden = false
                    if shouldDisplayAnswers {
                        cell.checkOptionView.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "C") ? Constants.correctColor : Constants.wrongColor
                        cell.optionLabel.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "C") ? Constants.correctColor : Constants.wrongColor
                    }
                } else {
                    cell.checkOptionView.isHidden = true
                    if shouldDisplayAnswers && test.answers[TestViewController.curQuestionNumber] == "C" {
                        cell.optionLabel.backgroundColor = Constants.correctColor
                    }
                }
            case 4:
                cell.checkBoxImage.image = UIImage(systemName: "d.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionD
                if test.chosen[TestViewController.curQuestionNumber] == "D" {
                    cell.checkOptionView.isHidden = false
                    if shouldDisplayAnswers {
                        cell.checkOptionView.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "D") ? Constants.correctColor : Constants.wrongColor
                        cell.optionLabel.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "D") ? Constants.correctColor : Constants.wrongColor
                    }
                } else {
                    cell.checkOptionView.isHidden = true
                    if shouldDisplayAnswers && test.answers[TestViewController.curQuestionNumber] == "D" {
                        cell.optionLabel.backgroundColor = Constants.correctColor
                    }
                }
            case 5:
                cell.checkBoxImage.image = UIImage(systemName: "e.square")
                cell.optionLabel.text = TestViewController.curQuestion?.optionE
                if test.chosen[TestViewController.curQuestionNumber] == "E" {
                    cell.checkOptionView.isHidden = false
                    if shouldDisplayAnswers {
                        cell.checkOptionView.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "E") ? Constants.correctColor : Constants.wrongColor
                        cell.optionLabel.backgroundColor = (test.answers[TestViewController.curQuestionNumber] == "E") ? Constants.correctColor : Constants.wrongColor
                    }
                } else {
                    cell.checkOptionView.isHidden = true
                    if shouldDisplayAnswers && test.answers[TestViewController.curQuestionNumber] == "E" {
                        cell.optionLabel.backgroundColor = Constants.correctColor
                    }
                }

            default:cell.checkBoxImage.image = UIImage(systemName: "square")}
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if test.status == .Started {
            let firstCell = 0
            let lastCell = tableView.numberOfRows(inSection: 0) - 1
            if indexPath.row > firstCell && indexPath.row < lastCell {
                var chosenAnswer: String
                switch indexPath.row {
                case 1: chosenAnswer = "A"
                case 2: chosenAnswer = "B"
                case 3: chosenAnswer = "C"
                case 4: chosenAnswer = "D"
                case 5: chosenAnswer = "E"
                default: chosenAnswer = "Error"
                }
                test.chosen[TestViewController.curQuestionNumber] = chosenAnswer
                test.results[TestViewController.curQuestionNumber] = (chosenAnswer == test.answers[TestViewController.curQuestionNumber]) ? true : false
                tableView.reloadData()
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

