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
 
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myNavBar: UINavigationBar!
    let usersRef = Firestore.firestore().collection("users")
    var user: Pasco.User? {
        didSet {
//            print("---AccountVC: \(user!)")
            getGrades()
            tableView.reloadData()
        }
    }
    private var grades: [Grade]? {
        didSet { tableView.reloadData() }
    }
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
//        getUser()

        setupNavigationBar()
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
       // adMod stuff
       bannerView.delegate = self
       bannerView.adUnitID = Constants.admob.bannerViewAdUnitID_test
       bannerView.rootViewController = self
       bannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUser()
    }
    
    // MARK: - My functions
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
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            self.user = Pasco.User(data: data)
                        }
                    }
                }
            }
        }
    }
    private func getGrades() {
        let ref = Firestore.firestore().collection("users").document((user?.username)!).collection("grades")
        ref.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("AccountVC: Error getting grades: \(err)")
            } else {
                var theGrades = [Grade]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let grade = Grade(data: data)
//                    print("grade => \(grade)")
                    theGrades.append(grade)
//                    print("\(document.documentID) => \(document.data())")
                }
                self.grades = theGrades.reversed()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.accountToGrades.rawValue {
            if let gradesVC = segue.destination.contentViewController as? GradesViewController {
                gradesVC.grades = grades
            }
        }
    }
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            cell.textLabel?.text = Constants.accountGradesTitle
            cell.detailTextLabel?.text = grades == nil ? "0" : "\(grades!.count)"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountQuestionRatings.rawValue, for: indexPath)
            cell.textLabel?.text = Constants.accountRatingsTitle
            cell.detailTextLabel?.text = "3"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountDeveloperCell.rawValue, for: indexPath)
            cell.textLabel?.text = "Developer"
            cell.detailTextLabel?.text = "GhanaWare"
            return cell
        }
        
        
    }
}

extension AccountViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("AccountViewController: adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewWillLeaveApplication")
    }

}

