//
//  Utilities.swift
//  Pasco
//
//  Created by denis on 6/24/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import UIKit


class Utilities {
    static func validate(withType type: Constants.RegEx, andInput input: String) -> (result: Bool, msg: String?) {
        let stringTest = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        let alertMessage: String
        switch type {
            case .email:                        alertMessage = Constants.AlertMessages.email.rawValue
            case .username:                     alertMessage = Constants.AlertMessages.username.rawValue
            case .alphaStringFirstLetterCaps:   alertMessage = Constants.AlertMessages.alphaStringFirstLetterCaps.rawValue
            case .alphaStringWithSpace1:        alertMessage = Constants.AlertMessages.alphaStringWithSpace1.rawValue
            case .alphaStringWithSpace2:        alertMessage = Constants.AlertMessages.alphaStringWithSpace2.rawValue
            case .phoneNo:                      alertMessage = Constants.AlertMessages.phoneNo.rawValue
            case .password:                     alertMessage = Constants.AlertMessages.password.rawValue
        }
        return (stringTest.evaluate(with: input)) ? (true, nil) : (false, alertMessage)
    }
    
    static func validateFields(strings : [Constants.RegEx : String]) -> String? {
        let values = Array(strings.values)
        if let error = checkStringsForBlank(strings: values) { return error }
        for type_string in strings {
            let result = validate(withType: type_string.key, andInput: type_string.value)
            if let errorMsg = result.msg { return errorMsg }
        }
        return nil
    }
    
    static func checkStringsForBlank(strings : [String]) -> String? {
        for string in strings {
            if string == "" { return Constants.fillAllFieldsError }
        }
        return nil
    }

}
