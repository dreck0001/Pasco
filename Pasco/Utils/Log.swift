//
//  Log.swift
//  Pasco
//
//  Created by Denis on 1/3/22.
//  Copyright © 2022 GhanaWare. All rights reserved.
//

import Foundation

class Log {

    private static func logTag(level: String, message: String, filePath: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        let fileName = filePath.split(separator: "/").last?.split(separator: ".").first
        let function = functionName.split(separator: "(").first
        print("--\(Date().date)-\(fileName ?? "classNotFound")-\(function ?? "functionNotFound")-\(lineNumber)[\(columnNumber)]-\(level): \(message)")
    }
    
    static func i(msg: String, filePath: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        logTag(level: "I", message: msg, filePath: filePath, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber);
    }
    
    static func w(msg: String, filePath: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        logTag(level: "W", message: msg, filePath: filePath, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber);
    }
    
    static func e(msg: String, filePath: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        logTag(level: "E", message: msg, filePath: filePath, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber);
    }
    
    static func f(msg: String, filePath: String = #file, functionName: String = #function, lineNumber: Int = #line, columnNumber: Int = #column) {
        logTag(level: "F", message: msg, filePath: filePath, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber);
    }
}
