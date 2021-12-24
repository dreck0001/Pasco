//
//  GradesViewController.swift
//  Pasco
//
//  Created by denis on 9/4/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import GoogleMobileAds

class GradesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BannerView: GADBannerView!
    
    var grades: [Grade]? {
        didSet {
            print("GradesVC: grades: \(grades)")
            tableView?.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("GradesVC: viewDidLoad")
        tableView.delegate = self
        tableView.dataSource = self
        
        title = Constants.accountGradesTitle
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
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

extension GradesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("GradesVC: numberOfRowsInSection")
        return grades?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let grade = grades![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.GradesExamCell.rawValue, for: indexPath) as! ExamTableViewCell
        if let grade = grades?[indexPath.row] { //if the grade exists...
            //set the labels
            cell.examSubjectYearLabel.text = "\(grade.exam!) | \(grade.subject!) | \(grade.year!)"
            cell.percentLabel.text = "\(grade.percent!)%"
            cell.durationLabel.text = "Duration: \(grade.durationMin!) mins, \(grade.durationSec!) secs"
            cell.completionTimeLabel.text = grade.completionTime.dateValue().toRelative()
            let correct = grade.results.filter { (result) in return result } //get correct answers for ratio label
            cell.ratioLabel.text = "\(correct.count)/\(grade.results.count)"
            
            //set cell background color based on grade percentage
//            let perc = grade.percent! * 4
            let perc = grade.percent!
            if perc > 90      { cell.backgroundColor = #colorLiteral(red: 0.1845552325, green: 0.7995246053, blue: 0.4384316206, alpha: 1) }
            else if perc > 80 { cell.backgroundColor = #colorLiteral(red: 0.2051456571, green: 0.5948371291, blue: 0.8570869565, alpha: 1) }
            else if perc > 70 { cell.backgroundColor = #colorLiteral(red: 0.5107483864, green: 0.810282886, blue: 0.8842687011, alpha: 1) }
            else if perc > 60 { cell.backgroundColor = #colorLiteral(red: 0.956099093, green: 0.6123771071, blue: 0.07133921236, alpha: 1) }
            else if perc > 50 { cell.backgroundColor = #colorLiteral(red: 0.9132422805, green: 0.3014689684, blue: 0.2376917005, alpha: 1) }
            else              { cell.backgroundColor = #colorLiteral(red: 0.9082317948, green: 0.0411407724, blue: 0.3528423309, alpha: 1) }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
