//
//  TableIndexView.swift
//  TableIndex
//
//  Created by L63 on 2021/3/15.
//

import UIKit

protocol TableIndexViewDelegate: NSObjectProtocol {
    func indexView(indexView: LCTableIndexView, didSelectAt row: NSInteger)
    func indexView(bindTableViewToindexView: LCTableIndexView) -> UITableView
}

class LCTableIndexView: UIView {
    let kTableIndexCellId = "kTableIndexCellId"
    let rowHeight: CGFloat = 14.0
    var gesturing = false
    var didSelectCell = false
    weak var sourceTable: UITableView?
    var delegate: TableIndexViewDelegate?
    var selectRow = -1
    var indexArr: [Any]? {
        didSet {
            let height = CGFloat(indexArr?.count ?? 0) * rowHeight
            tableView.mas_updateConstraints { make in
                make?.height.mas_equalTo()(height)
            }
            tableView.reloadData()
        }
    }

    // MARK: - life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        p_initView()
    }

    override func layoutSubviews() {
        superview?.layoutSubviews()
        performOnce(aselector: #selector(p_addObserver))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        sourceTable?.removeObserver(self, forKeyPath: "contentOffset")
    }

    // MARK: - delegate

    // MARK: - event response

    @objc func longGestureAction(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: tableView)
        var x = point.x, y = point.y
        if point.x <= 0 || point.x >= tableView.frame.size.width {
            x = 1
        }
        if point.y <= 0 {
            y = 1
        } else if point.y >= tableView.frame.size.height {
            y = tableView.frame.size.height - 1
        }
        let newPoint = CGPoint(x: x, y: y)
        let indexPath = tableView.indexPathForRow(at: newPoint)

        switch gesture.state {
        case .began:
            gesturing = true
            print("began")
            break
        case .changed:
            tableView(tableView, didSelectRowAt: indexPath!)
            let cell = tableView.cellForRow(at: indexPath ?? IndexPath())
            if let _ = cell {
                p_updateIndicator(cell: cell!)
            }
            if (cell as? LCTableIndexCell)?.content is UIImage {
                indicatorView.isHidden = true
            } else {
                indicatorView.isHidden = false
            }

            break
        case .ended:
            print("end")
            tableView(tableView, didSelectRowAt: indexPath!)
            gesturing = false
            indicatorView.isHidden = true
            break
        default:
            print("other")
            gesturing = false
            indicatorView.isHidden = true
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = sourceTable else {
            return
        }
        let old = change?[NSKeyValueChangeKey.oldKey] as! CGPoint
        var new = change?[NSKeyValueChangeKey.newKey] as! CGPoint
        guard old != new else {
            return
        }
        guard gesturing == false else {
            return
        }
        guard didSelectCell == false else {
            didSelectCell = false
            return
        }
        // 对坐标进行矫正
        if sourceTable!.adjustedContentInset.top > 0 {
            new = CGPoint(x: new.x, y: new.y + sourceTable!.adjustedContentInset.top)
        }
        var section = -1
        // 如果滑动到了顶部，就直接设置为0
        if(new.y <= 0){
            section = 0
        }else{
            let numberSeciont = sourceTable!.numberOfSections
            for s in 0 ..< numberSeciont {
                let rect = sourceTable!.rect(forSection: s)
                if rect.contains(new) {
                    section = s
                    break
                }
            }
            /// 如果有搜索图片，进行矫正
            if sourceTable!.numberOfSections != indexArr?.count {
                section += 1
            }
        }
        p_selectOneRow(row: section)
    }

    // MARK: - private methods

    func p_initView() {
        backgroundColor = .clear
        addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.right.mas_equalTo()
            make?.left.mas_equalTo()
            make?.centerY.mas_equalTo()
            make?.height.mas_equalTo()(0)
        }
        addSubview(indicatorView)
        indicatorView.mas_makeConstraints { make in
            make?.right.mas_equalTo()(tableView.mas_left)?.offset()(-10)
            make?.centerY.mas_equalTo()(self.mas_top)?.offset()(0)
            make?.size.mas_equalTo()(CGSize(width: 59, height: 46))
        }
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(longGestureAction(gesture:)))
        tableView.addGestureRecognizer(gesture)
    }

    func p_selectOneRow(row: NSInteger) {
        guard selectRow != row else {
            return
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: selectRow, section: 0)) as? LCTableIndexCell {
            cell.mark = false
        }

        selectRow = row

        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? LCTableIndexCell {
            cell.mark = true
        }
    }

    @objc func p_addObserver() {
        sourceTable = delegate?.indexView(bindTableViewToindexView: self)
        sourceTable?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }

    func p_updateIndicator(cell: UITableViewCell) {
        let cellCenter = cell.center
        let position = tableView.convert(cellCenter, to: self)
        indicatorView.mas_updateConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_top)?.offset()(position.y)
        }
        if cell is LCTableIndexCell {
            let content = (cell as! LCTableIndexCell).content
            indicatorView.content = content
        }
    }

    // MARK: - public methods

    // MARK: - setter

    // MARK: - getter

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LCTableIndexCell.self, forCellReuseIdentifier: kTableIndexCellId)
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    lazy var indicatorView: LCIndexIndicatorView = {
        let indicatorView = LCIndexIndicatorView()
        indicatorView.isHidden = true
        return indicatorView
    }()
}

// MARK: UITableViewDataSource

extension LCTableIndexView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCell = true
        p_selectOneRow(row: indexPath.row)
        delegate?.indexView(indexView: self, didSelectAt: indexPath.row)
    }
}

// MARK: UITableViewDelegate

extension LCTableIndexView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        indexArr?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableIndexCellId) as! LCTableIndexCell
        cell.content = indexArr?[indexPath.row] as AnyObject?
        return cell
    }
}
