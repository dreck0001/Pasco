//
//  DesignableButton.swift
//  GhVotes2020
//
//  Created by denis on 5/5/19.
//  Copyright © 2019 Berima Denis. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet { self.layer.borderColor = borderColor.cgColor }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }

}
