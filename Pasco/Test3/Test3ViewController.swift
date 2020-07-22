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
    
    var subjectYear: (sub: Int, yr: Int)? {
        didSet {
            updateUI()
            
        }
    }
    private var questions = [Question]() {
        didSet {
            questions.sort(by: { (q1, q2) -> Bool in return q1.number < q2.number }, stable: true)
//            QuestionsViewController.alreadyLoadedQuestionSets[subjectYear.sub] = questions
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        print("---Test3VC: viewDidLoad")

    }
    override func viewWillAppear(_ animated: Bool) {
        print("---Test3VC: viewWillAppear")
        updateUI()    }
    
    private func updateUI() {
        if userIsSignedIn() {
            if let subYr = subjectYear {
                if let subject = Constants.Subject.allValues[subYr.sub],
                    let year = Constants.subject_years[subYr.sub]?[subYr.yr] {
                    print("\(subject) - \(year)")
                    title = "\(subject) - \(year)"
                    if leftLabel != nil { leftLabel.text = "Ready" }
                    BeginBArItem.isEnabled = true
                    loadQuestionSet(sub: subject.rawValue, yr: year)
                }
            } else {
                BeginBArItem.isEnabled = false
                title = "Select a test"
                if leftLabel != nil { leftLabel.text = "" }
            }
        } else {
            print("---Test3VC: NOT signed in")
            BeginBArItem.isEnabled = false
            title = "Sign in to take a test"
            if leftLabel != nil { leftLabel.text = "" }
        }
    }
    private func userIsSignedIn() -> Bool {
        if Auth.auth().currentUser != nil { return true }
        else { return false }
    }
    private func loadQuestionSet(sub: String, yr: Int) {
        
    }

}

extension Test3ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestQuestion.rawValue, for: indexPath)
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestNextQuestion.rawValue, for: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.TestOption.rawValue, for: indexPath)
        }
    }
    

}
