//
//  Extensions.swift
//  Pasco
//
//  Created by denis on 9/3/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    var contentViewController: UIViewController?{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else {return self }
    }
}
extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
//        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
    }
}
extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
