//
//  UIView+Tools.swift
//  CustomSearchBar
//
//  Created by L63 on 2021/2/26.
//

import Foundation
import UIKit
extension UIView{
  @objc public func addSubviewsRandomColors() {
        self.backgroundColor = randomColor()
        if self.subviews.count > 0{
            for subview in self.subviews {
                subview.backgroundColor = randomColor()
                subview.addSubviewsRandomColors()
            }
        }
    }
    @objc func randomColor() -> UIColor {
        UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1);
    }
}
