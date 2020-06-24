//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    
    
    @IBInspectable public var viewCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        set{
            self.layer.borderWidth = newValue
        }
        get{
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor {
        set{
            self.layer.borderColor = newValue.cgColor
        }
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    public func addSubviewFullscreen(subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[subview]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[subview]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
    }
}
