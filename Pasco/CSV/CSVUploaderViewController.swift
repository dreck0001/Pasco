//
//  CSVUploaderViewController.swift
//  Pasco
//
//  Created by Denis on 4/11/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit
import CSVImporter
import Firebase
import FirebaseCore
import FirebaseFirestore

class CSVUploaderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        readData()
    }
    
    @IBAction func loadPressed(_ sender: UIButton) {
        for record in data { uploadToFirebase(record: record)}
            tableView.reloadData()
    }
    
    func readData() {
//        let path = "/Users/denis/Dropbox/Developer/Pasco/Pasco/CSV/english.csv"
        let path = "/Users/denis/Dropbox/Developer/PascoFiles/english/english.csv"
//        var contentOfCSV = ""
//        var csvString = ""
//        let file_Read  = "/Users/denis/Dropbox/Developer/Pasco/Pasco/CSV/english.csv"
//        let file_Write = "/Users/denis/Dropbox/Developer/Pasco/Pasco/CSV/english_clean.csv"
//        //Read the csv and replace dots
//        do {
//            let contentOfCSV = try String(contentsOfFile: file_Read, encoding: .utf8)
//            let arrayOfStrings = contentOfCSV.split(separator: "\n")
//            for line in arrayOfStrings {
//                csvString.append(contentsOf: String(line).dotsToUnderscores)
//            }
//        }
//        catch { print("errorrrrr reading CSV: \(error)") }
//        print(csvString)
//        //write to csv
//        do {
//            try csvString.write(to: URL(fileURLWithPath: file_Write), atomically: true, encoding: .utf8)
//        }
//        catch { print("errorrrrr writing CSV: \(error)") }

 
        let importer = CSVImporter<[String: String]>(path: path)
        importer.startImportingRecords(structure: { (headerValues) -> Void in
        }) { $0 }.onFinish { importedRecords in
            print("bbbbbbbb: \(importedRecords)")
            for record in importedRecords {
                self.data.append(record)
            }
        }
    }
    
    func uploadToFirebase(record: [String : Any]) {
        let questionRecord = [
            "Number": record["Number"],
            "Question": record["Question"],
            "OptionA": record["OptionA"],
            "OptionB": record["OptionB"],
            "OptionC": record["OptionC"],
            "OptionD": record["OptionD"],
            "Answer": record["Answer"]
        ]
        let db = Firestore.firestore()
        db.collection("BECE")
            .document(record["Subject"]! as! String)
            .collection(record["Year"]! as! String)
            .document(record["Part"]! as! String)
            .collection(record["Section"]! as! String)
            .document(record["Number"]! as! String)
            .setData(questionRecord as [String : Any], merge: true)
    }
}

extension CSVUploaderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cellData = data[indexPath.row]
        cell.textLabel?.text = cellData["Question"] as? String
        cell.detailTextLabel?.text = cellData["Number"] as? String
        return cell
    }
}
extension String {
    var dotsToUnderscores: String { return convertDotsToUnderscores(input: self) }
    private func convertDotsToUnderscores(input: String) -> String {
        var output = ""
        let dash = "___"
        let dots = [".........",
                    "........",
                    ".......",
                    "......",
                    ".....",
                    "....",
                    "...",
                    "..",
        ]
        output = input.replacingOccurrences(of: "..........", with: dash)
        for dot in dots { output = output.replacingOccurrences(of: dot, with: dash) }
        return output
    }
}
