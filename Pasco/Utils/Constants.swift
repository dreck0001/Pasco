//
//  Constants.swift
//  Pasco
//
//  Created by denis on 4/10/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let appColor: UIColor = #colorLiteral(red: 0.9474228024, green: 0.5469378233, blue: 0.0007671079366, alpha: 1)
    
    static let fillAllFieldsError = "Please fill all fields"
    static let creatingUserError = "An unknown error occurred. Please try again"

    static let registerButtonText = "SIGN UP"
    static let signInButtonText = "SIGN IN"
    
    static let usernamePlaceholder = "Username"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    struct admob {
                          static let appId = "ca-app-pub-7701962660538609~4342523085"
             static let bannerViewAdUnitID = "ca-app-pub-7701962660538609/6756739913"
        static let bannerViewAdUnitID_test = "ca-app-pub-3940256099942544/2934735716"
//        If your app is published to Google Play or the App Store, remember to come back to link your app.
    }
    
    enum segues: String {
        case AccountCheckToAccount = "toAccountVC"
       case AccountCheckToRegister = "toRegister"
         case AccountCheckToSignIn = "toSignIn"
    }
    enum cellIdentifiers: String {
            case AccountDetailsCell = "accountDetails"
         case QuestionSelectionCell = "selectionCell"
                  case QuestionCell = "questionCell"
        case AccountTestResultsCell = "testResults"
        case AccountQuestionRatings = "questionRatings"
        case TestSubject = "testSubject"
        case TestYear = "testYear"
        case TestSubmitSelection = "testSubmit"
    }
    
    enum AlertMessages: String {
                             case email = "Invalid Email"
                          case username = "Invalid Username"
             case username_alreadyTaken = "Username is already taken"
        case alphaStringFirstLetterCaps = "First letter should be capital"
             case alphaStringWithSpace1 = "Invalid first name"
             case alphaStringWithSpace2 = "Invalid last name"
                           case phoneNo = "Invalid Phone"
                          case password = "Password must be between 4 to 16 characters"
                  case passwordMismatch = "Mismatch in password and confirmation"
    }
    
    enum RegEx: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
        case username = "\\w{3,18}"                                     // 3-18 alphanumeric and _
        case alphaStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$"           // SandsHell voi
        case alphaStringWithSpace1 = "^[a-zA-Z ]*$"                      // e.g. hello denis
        case alphaStringWithSpace2 = "^[A-Za-z ]*$"                      // e.g. hello denis
        case phoneNo = "[0-9]{10,14}"                                   // PhoneNo 10-14 Digits
        case password = "^.{4,15}$"                                     // Password length 4-15
    }
    
    enum Subject: String {
        case RME
        case French
        case HomeEconomics
        case ICT
        case Math
        case PreTech
        case English
        case Science
        case SocialStudies
        case VisualArts
        static let allValues = [0: RME, 1: French, 2: HomeEconomics, 3: ICT, 4: Math, 5: PreTech, 6: English, 7: Science, 8: SocialStudies, 9: VisualArts]
//        static let allValues = [0: English, 1: French, 2: HomeEconomics]

    }
    
    static let subject_years = [
        0: [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999],
        1:  [1990, 1992, 1994],
        2:  [1995],
        3: [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000],
        4:  [1990, 1992, 1994],
        5:  [1995],
        6: [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000],
        7:  [1990, 1992, 1994],
        8:  [1995],
        9: [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000],

    ]

    struct meta {
        enum style { case Bold, Italicized }
        
        static func getMeta(sub: String, yr: Int) -> [Int: (String, String)] {
            switch sub {
            case "English":
                switch yr {
                case 2013: return Constants.meta.English_2013
                case 2014: return Constants.meta.English_2014
                default  : return Constants.meta.English_2015
                }
            default : return Constants.meta.English_2015
            }
        }
        
        static let English_2013 = [
            0 : ("Part A", "LEXIS AND STRUCTURE"),
            1 : ("SECTION A", "From the alternatives lettered A to D, choose the one which most suitably completes each sentence"),
            2 : ("SECTION A", "From the alternatives lettered A to D, choose the one which most suitably completes each sentence"),
            7 : ("SECTION A", "From the alternatives lettered A to D, choose the one which most suitably completes each sentence"),
//            4 : ("SECTION A", "From the alternatives lettered A to D, choose the one which most suitably completes each sentence")
        ]
        static let English_2014 = [
            0 : ("Part A", "LEXIS AND STRUCTURE"),
            1 : ("SECTION A", "From the alternatives lettered A to D, choose the one which most suitably completes each sentence")
        ]
        static let English_2015 = [
            0 : ("Error", "Data does not exist")
        ]
    }

}
