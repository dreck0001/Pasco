//
//  Test.swift
//  Pasco
//
//  Created by Denis on 8/14/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation

class Test {
    enum Status { case NotStarted, Started, Paused, Stopped }
    var status: Status = .NotStarted { didSet { print(status)}}
    var answers = [Int : String]()
    var chosen = [Int : String]()
    var results = [Int : Bool]()
    var totalTime = (min: 0, sec: 0)
    var completionTime = Date()
    func gradeTest() {
        print("Test: gradeTest called")
        for num in 1...answers.count {
            print("\(num): \(chosen[num]!) --- \(answers[num]!) = \(results[num]!)")
        }
//        print("answers: \(answers)")
//        print("chosen: \(chosen)")
//        for number in answers.keys {
//            let num = Int(number)
//            print(answers[num]!)
//            print(chosen[num]!)
//        }
    }
}
