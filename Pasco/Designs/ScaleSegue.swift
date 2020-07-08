//
//  ScaleSegue.swift
//  Pasco
//
//  Created by denis on 6/22/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }

    func scale () {
        let originVC = self.source
        let destinationVC = self.destination
        
        let containerView = originVC.view.superview
        let originalCenter = originVC.view.center
        
        destinationVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        destinationVC.view.center = originalCenter
        
        containerView?.addSubview(destinationVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            destinationVC.view.transform = CGAffineTransform.identity
        }) { (success) in
            originVC.present(destinationVC, animated: false, completion: nil)
        }
    }
}
