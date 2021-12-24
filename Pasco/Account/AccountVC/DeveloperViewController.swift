//
//  DeveloperViewController.swift
//  Pasco
//
//  Created by Denis on 9/12/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    // MARK: - IBActions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
//    func follow

    @IBAction func facebookPresed(_ sender: UIButton) {
        guard let facebookAppURL = URL(string: "fb://profile/105446761056284") else { return }
        guard let facebookWebURL = URL(string: "https://www.facebook.com/ghanaware") else { return }

        if UIApplication.shared.canOpenURL(facebookAppURL) {
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        }
        else { UIApplication.shared.open(facebookWebURL, options: [:], completionHandler: nil) }
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        let screenName =  "ghanaware"
        guard let instagramAppURL = URL(string: "instagram://user?username=\(screenName)") else { return }
        guard let instagramWebURL = URL(string:  "https://instagram.com/\(screenName)") else { return }

        if UIApplication.shared.canOpenURL(instagramAppURL) {
            UIApplication.shared.open(instagramAppURL, options: [:], completionHandler: nil)
        }
        else { UIApplication.shared.open(instagramWebURL, options: [:], completionHandler: nil) }
    }
    
    @IBAction func twitterPressed(_ sender: UIButton) {
        let screenName =  "ghanaware"
        guard let twitterAppURL = URL(string: "twitter://user?screen_name=\(screenName)") else { return }
        guard let twitterWebURL = URL(string:  "https://twitter.com/\(screenName)") else { return }

        if UIApplication.shared.canOpenURL(twitterAppURL) {
            UIApplication.shared.open(twitterAppURL, options: [:], completionHandler: nil)
        }
        else { UIApplication.shared.open(twitterWebURL, options: [:], completionHandler: nil) }
    }
    
    @IBAction func webPressed(_ sender: UIButton) {
        
    }
    
    
    
    
    
    
}

extension DeveloperViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "developerImage", for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "developerDescription", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "developerLinks", for: indexPath)
            return cell
        }
    }
    
    
}
