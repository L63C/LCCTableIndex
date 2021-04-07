//
//  TableView+index.swift
//  TableIndex
//
//  Created by L63 on 2021/3/16.
//

import Foundation
import UIKit
private var kIndexArrKey: Void?
private var kIndexViewKey: Void?
extension UITableView{
   public var indexArr : [Any]?{
        get {
            return objc_getAssociatedObject(self, &kIndexArrKey) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &kIndexArrKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            tableIndexView?.indexArr = newValue
        }
    }
    
    var tableIndexView : LCTableIndexView?{
        get{
            objc_getAssociatedObject(self, &kIndexViewKey) as? LCTableIndexView
        }
        set{
            objc_setAssociatedObject(self, &kIndexViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
   public func addCustomIndex() {
        guard let _ = self.superview else {
            assert(false, "请先 addSubview")
            return
        }
        if let _ = tableIndexView{
            tableIndexView!.removeFromSuperview()
        }
        tableIndexView = LCTableIndexView.init()
        tableIndexView?.delegate = self
        let superView = self.superview
        
        superView!.addSubview(tableIndexView!)
        tableIndexView!.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(self.mas_top)
            make?.bottom.mas_equalTo()(self.mas_bottom)
            make?.right.mas_equalTo()(self.mas_right)
            make?.width.mas_equalTo()(20)
        }
    }
}
extension UITableView : TableIndexViewDelegate{
    
    
    func indexView(indexView: LCTableIndexView, didSelectAt row: NSInteger) {
        if self.numberOfSections == indexArr?.count{// 带有头部
            self.scrollToRow(at: IndexPath.init(row: 0, section: row), at: .top, animated: false)
        }else{
            if(row == 0){
                self.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            }else{
                self.scrollToRow(at: IndexPath.init(row: 0, section: row-1), at: .top, animated: false)
            }
        }
    }
    func indexView(bindTableViewToindexView: LCTableIndexView) -> UITableView {
        return self
    }
}

