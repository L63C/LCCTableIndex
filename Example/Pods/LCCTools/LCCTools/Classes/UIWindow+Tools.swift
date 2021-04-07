//
//  UIWindow+Tools.swift
//  CustomSearchBar
//
//  Created by L63 on 2021/3/1.
//

import Foundation
import UIKit

extension UIWindow{
    /// 获取状态栏高度
   @objc public static func statusBarHeight() -> CGFloat {
        var height:CGFloat
        if #available(iOS 13.0,*){
            height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        }else{
            height = UIApplication.shared.statusBarFrame.height
        }
       return height
    }
    @objc public static func currentViewController() -> UIViewController{
        let vc = UIApplication.shared.keyWindow?.rootViewController;
        if let presentedVC = vc?.presentedViewController {
            if presentedVC is UINavigationController{
                return (presentedVC as! UINavigationController).visibleViewController!
            }else if presentedVC is UITabBarController{
                let tabVC = presentedVC as! UITabBarController
                if tabVC.selectedViewController is UINavigationController{
                    return (tabVC.selectedViewController as! UINavigationController).visibleViewController!
                }else{
                    return tabVC.selectedViewController!
                }
            }else{
                return presentedVC
            }
        }else{
            if vc is UINavigationController{
                return (vc as! UINavigationController).visibleViewController!
            }else if vc is UITabBarController{
                let tabVC = vc as! UITabBarController
                if tabVC.selectedViewController is UINavigationController{
                    return (tabVC.selectedViewController as! UINavigationController).visibleViewController!
                }else{
                    return tabVC.selectedViewController!
                }
            }else{
                return vc!
            }
        }
    }
    
}
