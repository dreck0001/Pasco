//
//  Test.swift
//  Pasco
//
//  Created by denis on 7/30/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation

class Test {
    enum Status { case NotStarted, Started, Paused, Stopped }
    static var status: Status = .NotStarted { didSet { print(status)}}
    var answers = [Int : (chosen: String, correct: String)]()
    var totalTime = (min: 0, sec: 0)
    var completionTime = Date()
    func gradeTest() {
        
    }
   
}
