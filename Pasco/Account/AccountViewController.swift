//
//  AccountViewController.swift
//  Pasco
//
//  Created by denis on 4/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myNavBar: UINavigationBar!
    let usersRef = Firestore.firestore().collection("users")
    var user: Pasco.User? {
        didSet {
            print("---AccountVC: \(user!)")
            tableView.reloadData()
        }
    }

    //    @IBAction func dismissAction(_ sender: UIButton) {
////        presentingViewController?.dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()

        setupNavigationBar()
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        myNavBar.isTranslucent = false
        //        navigationBar.barTintColor = UIColor.black
                
        //        view.addSubview(navigationBar)
        myNavBar.translatesAutoresizingMaskIntoConstraints = false
        myNavBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myNavBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        myNavBar.prefersLargeTitles = true
    }
    
    private func getUser(){
        if let user = Auth.auth().currentUser {
            usersRef.whereField("email", isEqualTo: user.email!).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("---AccountVC: Eror Could not find the userinfo using the email: \(err)")
                } else {
                    if querySnapshot!.count > 1 {
                        print("---AccountVC: email returned more than 1 user. Investigate why!: \(querySnapshot!.documents)")
                    } else {
    //                    DispatchQueue.main.async {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                self.user = Pasco.User(data: data)
                            }
    //                    }
                    }
                }
            }
        }
        
    }
}



extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountDetailsCell.rawValue, for: indexPath)
            if let user = user {
                cell.textLabel?.text = user.username
                cell.detailTextLabel?.text = user.email
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountTestResultsCell.rawValue, for: indexPath)
            cell.textLabel?.text = "My Test Results"
            cell.detailTextLabel?.text = "5"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountQuestionRatings.rawValue, for: indexPath)
            cell.textLabel?.text = "My Question Ratings"
            cell.detailTextLabel?.text = "3"
            return cell
        }
        
        
    }
}

