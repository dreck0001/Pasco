//
//  QuestionsMenuViewController.swift
//  Pasco
//
//  Created by denis on 9/8/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class QuestionsMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectTestButton: UIButton!
    static var selection = (exam: "BECE", subject: "RME", year: 1990) {
        didSet { print("QuestionsMenuVC: \(QuestionsMenuViewController.selection)")}
    }
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    

    

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("questionsMenuVC: selection: \(QuestionsMenuViewController.selection)")
         if segue.identifier == Constants.segues.QuestionsMenuSelect.rawValue {
             Utilities.vibrate()
             if let questionsVC = segue.destination.contentViewController as? Questions1ViewController {
                 Utilities.loadQuestionSet(sub: QuestionsMenuViewController.selection.subject, yr: QuestionsMenuViewController.selection.year)
                 questionsVC.examSubjectYear = QuestionsMenuViewController.selection
             }
         }
     }
     override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
         print("questionsMenuVC: shouldPerformSegue")
         return true
     }
    
    // MARK: - Functions
    private func updateUI() {
        if Utilities.userEmailIsVerified() {
            navigationItem.title = "View Questions"
            selectTestButton.isEnabled = true
            selectTestButton.alpha = 1
        } else {
            navigationItem.title = "Sign in to Continue"
            selectTestButton.isEnabled = false
            selectTestButton.alpha = 0.2
        }
    }

}

extension QuestionsMenuViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "examCell1", for: indexPath) as! QuestionsExamTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell1", for: indexPath) as! QuestionsSubjectTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell1", for: indexPath)
            return cell
        
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        NotificationCenter.default.removeObserver(cell)
    }
}
