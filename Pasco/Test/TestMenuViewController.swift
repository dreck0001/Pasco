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
    @IBOutlet weak var startTestButton: UIButton!
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Functions
    private func updateUI() {
        if Utilities.userIsSignedIn() {
            navigationItem.title = "Select a Test"
            startTestButton.isEnabled = true
            startTestButton.alpha = 1
        } else {
            navigationItem.title = "Sign in to Continue"
            startTestButton.isEnabled = false
            startTestButton.alpha = 0.5
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        NotificationCenter.default.removeObserver(cell)
    }
}
