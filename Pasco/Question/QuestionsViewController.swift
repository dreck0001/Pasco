//
//  QuestionsViewController.swift
//  Pasco
//
//  Created by denis on 4/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var questions = [Question]() {
        didSet {
            // sort by number, add to alreadyLoadedQuestionSets, reload
            questions.sort(by: { (q1, q2) -> Bool in
                return q1.number < q2.number
            }, stable: true)
            alreadyLoadedQuestionSets[QuestionsViewController.incomingName] = questions
            tableView.reloadData()
            displayData()
        }
    }
//    var questions = [Question]()
    @IBOutlet weak var bannerView: GADBannerView!
    private var selectionCellExpanded = false
    var alreadyLoadedQuestionSets = [String: [Question]]()
    static private var selectedSubject_YearHasChanged = true
    static var selectedSubject_Year: (sub: String, yr: Int)? {
        didSet { print("selectedSubject_Year = \(selectedSubject_Year!)")
            if oldValue?.sub == selectedSubject_Year?.sub && oldValue?.yr == selectedSubject_Year?.yr {
                selectedSubject_YearHasChanged = false
            } else { selectedSubject_YearHasChanged = true }
            
            
        }
    }
    static var incomingName: String { return "\(QuestionsViewController.selectedSubject_Year!.sub)_\(QuestionsViewController.selectedSubject_Year!.yr)" }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //use flexible cell heights
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        //        adMod stuff
        bannerView.delegate = self
        bannerView.adUnitID = Constants.admob.bannerViewAdUnitID_test
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //load quesstions
        QuestionsViewController.selectedSubject_Year = ("English", 1990) //initial load
        loadQuestionSet(sub: QuestionsViewController.selectedSubject_Year!.sub, yr: QuestionsViewController.selectedSubject_Year!.yr)
        // Do any additional setup after loading the view.
    }
    
    private func loadQuestionSet(sub: String, yr: Int) {
//        if alreadyLoadedQuestionSets is empty, lead questions from firebase
        if alreadyLoadedQuestionSets.isEmpty {
            loadQuestionSetFromFirebase(sub: sub, yr: yr)
            return
        } else {  //else if alreadyLoadedQuestionSets contains the questions, display them
            let incomingName = sub + "_" + String(yr)
            let loadedNames = Array(alreadyLoadedQuestionSets.keys)
            for name in loadedNames {
                print("name: \(incomingName), alreadyLoadedQuestionSets: \(alreadyLoadedQuestionSets)")
                if String(name) == incomingName { // it already exists so just display it
                    print("\(name) is found in alreadyLoadedQuestionSets")
                    questions = alreadyLoadedQuestionSets[incomingName]!
                    return
                }
            }
        }
        
        //else, it doesn't exist so load, display and store it
        loadQuestionSetFromFirebase(sub: sub, yr: yr)
//        alreadyLoadedQuestionSets[incomingName] = questions
    }
    
    private func loadQuestionSetFromFirebase(sub: String, yr: Int) {
        let db = Firestore.firestore()
        db.collection("BECE/" + sub + "/" + String(yr)).getDocuments { (querySnapshot, error) in
            if let error = error { print("error getting data: " + error.localizedDescription) }
            else {
                if let snapshot = querySnapshot {
                    let questions = snapshot.documents.compactMap({ (document) in
                        return Question(data: document.data())
                    })
                    self.questions = questions
                }
            }
        }
    }
        
    private func displayData() {
        
    }

//     MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}

extension QuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Selection"
        case 1: return "SECTION A - OBJECTIVE TEST"
        default: return "Questions"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 0
        default: return questions.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
            let subjectRow = cell.selectionPicker.selectedRow(inComponent: 0)
            let yearRow    = cell.selectionPicker.selectedRow(inComponent: 1)
            cell.selectionSubjectLabel.text = "\(Constants.Subject.allValues[subjectRow]!.rawValue)    -"
            cell.selectionYearLabel.text    = "    \(Constants.subject_years[subjectRow]![yearRow])"
            if selectionCellExpanded {
                cell.selectionSubjectLabel.textColor = .red
                cell.selectionYearLabel.textColor = .red
                cell.expansionIndicatorLabel.textColor = .red
                cell.expansionIndicatorLabel.text = "-"
            } else {
                cell.selectionSubjectLabel.textColor = .black
                cell.selectionYearLabel.textColor = .black
                cell.expansionIndicatorLabel.textColor = .black
                cell.expansionIndicatorLabel.text = "+"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
            print("okokokok: \(indexPath.row)")
            let theQuestion = questions[indexPath.row]
//            print("slslss: \(questions.count)")
            cell.questionNumberLabel.text = "\(theQuestion.number). "
            cell.questionLabel.text = theQuestion.question
            cell.optionALabel.text = theQuestion.optionA
            cell.optionBLabel.text = theQuestion.optionB
            cell.optionCLabel.text = theQuestion.optionC
            cell.optionDLabel.text = theQuestion.optionD
            if theQuestion.optionE == "" {
                cell.optionELetter.isHidden = true
                cell.optionELabel.isHidden = true
            } else { cell.optionELabel.text = theQuestion.optionE }
            return cell
        }
    }    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0,  indexPath.row == 0 {
            if selectionCellExpanded {
//                chceck and refresh data
                if QuestionsViewController.selectedSubject_YearHasChanged {
                    loadQuestionSet(sub: QuestionsViewController.selectedSubject_Year!.sub, yr: QuestionsViewController.selectedSubject_Year!.yr)
                } else { } //do nothing
                selectionCellExpanded = false
            }
            else { selectionCellExpanded = true }
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { // selection height
            if selectionCellExpanded { return 200 }
            else                     { return 50 }
        } else {
//            return 220
//            return tableView.estimatedRowHeight
//            return tableView.rowHeight
//            return UITableView.automaticDimension
            tableView.estimatedRowHeight = tableView.rowHeight
            return UITableView.automaticDimension
        } //question height
    }
}
extension QuestionsViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("QuestionsViewController: adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("QuestionsViewController: adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("QuestionsViewController: adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("QuestionsViewController: adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("QuestionsViewController: adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("QuestionsViewController: adViewWillLeaveApplication")
    }

}
