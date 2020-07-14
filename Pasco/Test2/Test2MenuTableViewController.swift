//
//  Test2MenuTableViewController.swift
//  Pasco
//
//  Created by denis on 7/9/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class Test2MenuTableViewController: UITableViewController {

//    private let menuItems: [String]
//    init(with menuItems: [String]) {
    init() {
//        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testSubject")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testYear")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testSubmit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "testSubject", for: indexPath)
            let picker = UIPickerView(frame: cell.contentView.bounds)
            
//            cell.textLabel?.text = "Subject"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "testYear", for: indexPath)
            cell.textLabel?.text = "Year"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "testSubmit", for: indexPath)
            cell.textLabel?.text = "Submit"
            return cell
        }
        

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        relay to delegate about menu selection
    }
}
