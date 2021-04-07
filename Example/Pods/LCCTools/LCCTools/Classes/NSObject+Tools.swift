//
//  NSObject+Tools.swift
//  CustomSearchBar
//
//  Created by L63 on 2021/3/10.
//

import Foundation

private var kPerformOnceKey: Void?

extension NSObject{
    
    public var performOnceFlag:Bool{
        get{
            return objc_getAssociatedObject(self, &kPerformOnceKey) as? Bool ?? false
        }
        set{
            objc_setAssociatedObject(self, &kPerformOnceKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc public func performOnce(aselector :Selector){
        if performOnceFlag {
            return
        }
        performOnceFlag = true
        perform(aselector)
    }
    @objc public func performOnceBlock(aselector:() -> Void){
        if performOnceFlag {
            return
        }
        performOnceFlag = true
        aselector()
        
    }
}
