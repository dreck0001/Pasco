//
//  AccountViewController.swift
//  Pasco
//
//  Created by denis on 4/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class AccountViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myNavBar: UINavigationBar!
    let usersRef = Firestore.firestore().collection("users")
    var user: Pasco.User? {
        didSet {
            Log.i(msg: "\(user)")
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
        Log.i(msg: "")
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
        Log.i(msg: "")
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
                    Log.e(msg: "Could not find the userinfo using the email: \(err)")
                } else {
                    if querySnapshot!.count > 1 {
                        Log.e(msg: "Email returned more than 1 user. Investigate why!: \(querySnapshot!.documents)")
                    }
                    else if querySnapshot!.count < 1 {
                        Log.e(msg: "mail returned no user email. User must have been removed from users database?!: \(querySnapshot!.documents)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            self.user = Pasco.User(data: data)
                        }
                    }
                }
            }
        } else {Log.f(msg: "Could not find the user") }
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
    private func presentShareSheet(from cell: UITableViewCell) {
        let txt = "Hey, Download Pasco and start preparing for your exam today!\nUse the link below to download:\n<<Place link here>>"
        let alertController = UIAlertController()
        let mail = UIAlertAction(title: "Mail", style: .default) { (_) in self.presentMailVCWith(text: txt) }
        let message = UIAlertAction(title: "Message", style: .default) { (_) in self.presentMessageVCWith(text: txt) }
        let more = UIAlertAction(title: "More", style: .default) { (_) in self.presentMoreVCWith(text: txt) }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(mail)
        alertController.addAction(message)
        alertController.addAction(more)
        alertController.addAction(cancel)
        // For iPad: before presenting alertController, alertController's popoverPresentationController needs to be set to avoid ipad errors
        // https://medium.com/@nickmeehan/actionsheet-popover-on-ipad-in-swift-5768dfa82094
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = parent?.view
            popoverController.sourceRect = CGRect(x: cell.frame.midX, y: cell.frame.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    private func presentMailVCWith(text: String) {
        let subject = "Share Pasco"
        let body = text
        let coded = "mailto:?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL: NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(emailURL as URL)
                } else { UIApplication.shared.openURL(emailURL as URL) }
            } else {
                // send alert to tell user to enable email to procede
                let alertController = UIAlertController(title: "Cannot Send Message", message: "Please enable email in settings to allow this action", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    private func presentMessageVCWith(text: String) {
        let sms: String = "sms:&body=\(text)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    private func presentMoreVCWith(text: String) {
        let items = [text]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceView = parent?.view
//            popoverController.sourceRect = CGRect(x: cell.frame.midX, y: cell.frame.midY, width: 0, height: 0)
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(activityController, animated: true)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0: return 2
            case 1: return 2
            default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // ACCOUNT
            switch indexPath.row {
            case 0: //USERNAME
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountDetailsCell.rawValue, for: indexPath)
                if let user = user {
                    cell.textLabel?.text = user.username
                    cell.detailTextLabel?.text = user.email
                }
                return cell
            default: //GRADES
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountTestResultsCell.rawValue, for: indexPath)
                cell.textLabel?.text = Constants.accountGradesTitle
                cell.detailTextLabel?.text = grades == nil ? "0" : "\(grades!.count)"
                return cell
            }
        case 1: //HELP
            switch indexPath.row {
            case 0: //HELP
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountHelp.rawValue, for: indexPath)
                cell.textLabel?.text = Constants.accountHelp
                return cell
            default: //FRIEND
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountTellAFriend.rawValue, for: indexPath)
                cell.textLabel?.text = Constants.accountFriend
                cell.detailTextLabel?.text = Constants.accountFriendDetail
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.AccountDeveloperCell.rawValue, for: indexPath)
            cell.textLabel?.text = "Developer"
            cell.detailTextLabel?.text = "GhanaWare"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)  //deselect cell
        //present stylesheet
        if let cell = tableView.cellForRow(at: indexPath) {
            if indexPath.section == 1 && indexPath.row == 1 { presentShareSheet(from: cell)}
        }
        
    }
}

extension AccountViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("---AccountViewController: adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("---AccountViewController: adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("AccountViewController: adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("---AccountViewController: adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("---AccountViewController: adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("---AccountViewController: adViewWillLeaveApplication")
    }

}

//=afriye (retry)
//+mommy
//+selorm
//=uncle (voice mail)
//=prof (retry)
//-mark ()
