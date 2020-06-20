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
    struct admob {
        static let appId = "ca-app-pub-7701962660538609~4342523085"
        static let bannerViewAdUnitID       = "ca-app-pub-7701962660538609/6756739913"
        static let bannerViewAdUnitID_test  = "ca-app-pub-3940256099942544/2934735716"
//        If your app is published to Google Play or the App Store, remember to come back to link your app.
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
