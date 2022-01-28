//
//  TestMenuViewController.swift
//  Pasco
//
//  Created by denis on 8/7/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class TestMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectTestButton: UIButton!
    static var selection = (exam: "BECE", subject: "RME", year: 1990) {
        didSet { print("TestMenuVC: \(TestMenuViewController.selection)")}
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }

    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("testMenuVC: selection: \(TestMenuViewController.selection)")
        if segue.identifier == Constants.segues.TestMenuSelect.rawValue {
            Utilities.vibrate()
            if let testVC = segue.destination.contentViewController as? TestViewController {
                Utilities.loadQuestionSet(sub: TestMenuViewController.selection.subject, yr: TestMenuViewController.selection.year)
                testVC.examSubjectYear = TestMenuViewController.selection
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("testMenuVC: shouldPerformSegue")
        return true
    }
    
    
    // MARK: - Functions
    private func updateUI() {
        if Utilities.userEmailIsVerified() {
            navigationItem.title = "Take an Exam"
            selectTestButton.isEnabled = true
            selectTestButton.alpha = 1
        } else {
            navigationItem.title = "Sign in to Continue"
            selectTestButton.isEnabled = false
            selectTestButton.alpha = 0.2
        }
    }
}

extension TestMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as! TestExamTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! TestSubjectTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath)
            return cell
        
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        NotificationCenter.default.removeObserver(cell)
    }
}
