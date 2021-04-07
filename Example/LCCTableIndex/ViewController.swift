//
//  ViewController.swift
//  LCCTableIndex
//
//  Created by lu63chuan@163.com on 04/07/2021.
//  Copyright (c) 2021 lu63chuan@163.com. All rights reserved.
//

import UIKit
import LCCTableIndex
class ViewController: UIViewController {
    let kCellId : String = "testCellId"
    let dataSource : Array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    let indexArr : [Any] = [UIImage.init(named: "icon_chats_search") as Any,"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        p_initView()
    }
    
    // MARK: - event response
    
    // MARK: - private methods
    func p_initView() {
        self.view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.addCustomIndex()
        tableView.indexArr = indexArr
        
    }
    // MARK: - public methods
    
    // MARK: - setter
    
    // MARK: - getter
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellId)
        tableView.contentInsetAdjustmentBehavior = .never
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        headerView.backgroundColor = .blue
        return tableView
    }()
}
// MARK: - delegate
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    
    
    // MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = dataSource[indexPath.section] + "\(row)"
        return cell
    }
    
    // MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        title.text = dataSource[section]
        title.textColor = .red
        title.backgroundColor = .green
        
        
        return title
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
}
