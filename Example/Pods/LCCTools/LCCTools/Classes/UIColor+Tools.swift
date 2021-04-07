//
//  UIColor+Tools.swift
//  CustomSearchBar
//
//  Created by L63 on 2021/2/26.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hexString: String,alpha:Float) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    // Hex String -> UIColor
    public convenience init(hexString: String) {
        self.init(hexString: hexString,alpha: 1)
    }
    
    // UIColor -> Hex String
    public var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /// 设置随机颜色
    public class func randomColor() -> UIColor {
        let color: UIColor = UIColor(red: (CGFloat)(arc4random() % 256) / 255.0, green: (CGFloat)(arc4random() % 256) / 255.0, blue: (CGFloat)(arc4random() % 256) / 255.0, alpha: 1.0)
        return color
    }
}
