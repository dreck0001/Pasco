//
//  Grade.swift
//  Pasco
//
//  Created by Denis on 9/3/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import Firebase

struct Grade {
    let exam: String!
    let subject: String!
    let year: Int!
    let results: [Bool]!
    let percent: Double!
    let durationMin: Int!
    let durationSec: Int!
    let completionTime: Timestamp!

    init(data: [String : Any]) {
        exam = data["exam"] as? String
        subject = data["subject"] as? String
        year = data["year"] as? Int
        results = data["results"] as? [Bool]
        percent = data["percent"] as? Double
        durationMin = data["durationMin"] as? Int
        durationSec = data["durationSec"] as? Int
        completionTime = data["completionTime"] as? Timestamp
    }
    
}
