//
//  UIColor+Extension.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 15.9.22..
//

import UIKit

extension UIColor {
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
 
    func lighterColor(with step: CGFloat) -> UIColor {
        var red = components.red
        var green = components.green
        var blue = components.blue
        let alpha = components.alpha
        
        red = red + (1.0 - red) / step
        green = green + (1.0 - green) / step
        blue = blue + (1.0 - blue) / step
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func colorPalette(for numberOfColors: Int) -> [UIColor] {
        let step = CGFloat(numberOfColors)
        var colors: [UIColor] = [self]
        
        for _ in 0..<numberOfColors - 1 {
            guard let lastColor = colors.last else {
                return colors
            }
            
            let color = lastColor.lighterColor(with: step)
            colors.append(color)
        }
        
        return colors
    }
    
}
