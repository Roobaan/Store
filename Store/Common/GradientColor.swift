//
//  GradientColor.swift
//  Store
//
//  Created by SCT on 27/05/24.
//

import UIKit


func gradientColor (_ bounds: CGRect, color: [CGColor]) -> UIColor {
    
    // It draws a color gradient over its background color
    lazy var gradient = CAGradientLayer()
    
    guard bounds.width != 0 || bounds.height != 0 else {return UIColor.blue}
    
    gradient.frame = bounds
    
    // colors includes in the gradient color
    gradient.colors = color
    
    // It alligns the gradient color to vertical
    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    
    UIGraphicsBeginImageContext(gradient.bounds.size)
    
    gradient.render(in: (UIGraphicsGetCurrentContext()!))
    
    // Returns image from the contents of the bitmap-based graphics context.
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    // To create color object
    return UIColor(patternImage: image ?? UIImage())
}
