//
//  DesignableView.swift
//  GhVotes2020
//
//  Created by denis on 5/4/19.
//  Copyright © 2019 Berima Denis. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }


}
