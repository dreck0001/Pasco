//
//  Question.swift
//  Pasco
//
//  Created by denis on 5/11/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation

class Question {
//    var subject: String
//    var year: Int
    var question: String
    var answer: String
    var number: Int
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
    var optionE: String
    var answerLetter: String

    init(data: [String: Any]) {
        self.number    = data["number"]   as? Int ?? 0
        self.question  = data["question"] as? String ?? ""
        self.optionA   = data["optionA"]  as? String ?? ""
        self.optionB   = data["optionB"]  as? String ?? ""
        self.optionC   = data["optionC"]  as? String ?? ""
        self.optionD   = data["optionD"]  as? String ?? ""
        self.optionE   = data["optionE"]  as? String ?? ""
        self.answer    = data["answer"]   as? String ?? ""
        self.answerLetter    = data["answerLetter"]   as? String ?? ""
    }
}
