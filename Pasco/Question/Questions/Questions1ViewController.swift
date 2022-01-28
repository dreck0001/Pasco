//
//  Questions1ViewController.swift
//  Pasco
//
//  Created by Denis on 9/9/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class Questions1ViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showAnswersButton: UIBarButtonItem!
    private var showAnswers = false
    
    private var questions: [Question]? { didSet { tableView?.reloadData() } }
    var examSubjectYear: (exam: String, subject: String, year: Int)? {
        didSet {
            getQuestions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("questions1VC: viewDidLoad")
        //use flexible cell heights
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        //adMod stuff
        bannerView.delegate = self
        bannerView.adUnitID = Constants.admob.bannerViewAdUnitID_test
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("questions1VC: viewWillAppear")
        NotificationCenter.default.addObserver( self,
                                           selector: #selector(onDidReceiveData(_:)),
                                           name: NSNotification.Name(rawValue: "questionsLoaded"),
                                           object: nil
        )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        //hello
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("questions1VC: Notification recieved! Reloading tableView!!")
        getQuestions()
    }
    private func getQuestions() {
        if let exam = examSubjectYear?.exam, let subject = examSubjectYear?.subject, let year = examSubjectYear?.year {
            questions = Utilities.alreadyLoadedQuestionSets[subject + "_" + String(year)]
        }
    }
    
    // MARK: - IBActions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ShowAnswersAction(_ sender: UIBarButtonItem) {
        showAnswers = !showAnswers
        if showAnswers {
            showAnswersButton.image = UIImage(systemName: "eye.slash")
        } else {
            showAnswersButton.image = UIImage(systemName: "eye")
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Questions1ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("questions1VC: numberOfSections")
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let ESY = examSubjectYear {
            return "\(ESY.exam) | \(ESY.subject) | \(ESY.year)"
        }
        return "No Data"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "YourFontname", size: 14.0)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.QuestionCell.rawValue, for: indexPath) as! QuestionTableViewCell
        if let theQuestion = questions?[indexPath.row] {
//                let theQuestion = Utilities.questions[indexPath.row]
    //            print("slslss: \(questions.count)")
                cell.questionNumberLabel.text = "\(theQuestion.number). "
                cell.questionLabel.text = theQuestion.question
                cell.optionALabel.text = theQuestion.optionA
                cell.optionBLabel.text = theQuestion.optionB
                cell.optionCLabel.text = theQuestion.optionC
                cell.optionDLabel.text = theQuestion.optionD
//                handle possibility of having option E
                if theQuestion.optionE == "" {
                    cell.optionELetter.isHidden = true
                    cell.optionELabel.isHidden = true
                } else { cell.optionELabel.text = theQuestion.optionE }
//                Show or hide answers
                cell.optionALabel.backgroundColor = (showAnswers && theQuestion.answerLetter == "A") ? Constants.correctColor : .none
                cell.optionALetter.backgroundColor = (showAnswers && theQuestion.answerLetter == "A") ? Constants.correctColor : .none
                cell.optionBLabel.backgroundColor = (showAnswers && theQuestion.answerLetter == "B") ? Constants.correctColor : .none
                cell.optionBLetter.backgroundColor = (showAnswers && theQuestion.answerLetter == "B") ? Constants.correctColor : .none
                cell.optionCLabel.backgroundColor = (showAnswers && theQuestion.answerLetter == "C") ? Constants.correctColor : .none
                cell.optionCLetter.backgroundColor = (showAnswers && theQuestion.answerLetter == "C") ? Constants.correctColor : .none
                cell.optionDLabel.backgroundColor = (showAnswers && theQuestion.answerLetter == "D") ? Constants.correctColor : .none
                cell.optionDLetter.backgroundColor = (showAnswers && theQuestion.answerLetter == "D") ? Constants.correctColor : .none
                cell.optionELabel.backgroundColor = (showAnswers && theQuestion.answerLetter == "E") ? Constants.correctColor : .none
                cell.optionELetter.backgroundColor = (showAnswers && theQuestion.answerLetter == "E") ? Constants.correctColor : .none
                //hello
            }
//
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        tableView.estimatedRowHeight = tableView.rowHeight
        return UITableView.automaticDimension
    }
}
extension Questions1ViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Questions1ViewController: adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("Questions1ViewController: adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("Questions1ViewController: adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("Questions1ViewController: adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("Questions1ViewController: adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("Questions1ViewController: adViewWillLeaveApplication")
    }

}
