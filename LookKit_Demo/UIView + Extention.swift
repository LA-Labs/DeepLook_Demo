//
//  UIView + Extention.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 26/02/2021.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
