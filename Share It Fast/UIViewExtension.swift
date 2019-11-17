//
//  UIViewExtension.swift
//  Share It Fast
//
//  Created by Neil Richter on 31/10/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func grid(child: UIView, x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat, grid: CGFloat = 12) {
        child.frame = CGRect(
            x: self.frame.width / grid * x,
            y: self.frame.height / grid * y,
            width: self.frame.width / grid * width,
            height: self.frame.height / grid * height
        )
        
        self.addSubview(child)
    }
}

var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
