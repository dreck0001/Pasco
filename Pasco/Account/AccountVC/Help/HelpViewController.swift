//
//  HelpViewController.swift
//  Pasco
//
//  Created by Denis on 9/8/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func presentMailVCWith(text: String) {
        let subject = "Pasco: User Question"
        let body = text
        let coded = "mailto:mydatamala@gmail.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HelpViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.helpCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.helpCells[indexPath.row]!, for: indexPath)
        if indexPath.row == 0 { cell.accessoryType = .disclosureIndicator }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 { presentMailVCWith(text: "")}
        
    }
}
