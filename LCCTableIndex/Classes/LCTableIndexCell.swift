//
//  TableIndexCell.swift
//  TableIndex
//
//  Created by L63 on 2021/3/15.
//

import UIKit
import Masonry
import LCCTools

class LCTableIndexCell: UITableViewCell {
    public var content :AnyObject?{
        didSet{
            if content is String{
                imageV.isHidden = true
                nameLab.isHidden = false
                nameLab.text = content as? String
            }else if content is NSString{
                imageV.isHidden = true
                nameLab.isHidden = false
                nameLab.text = content as? String
            }else if content is UIImage{
                imageV.isHidden = false
                nameLab.isHidden = true
                imageV.image = content as? UIImage
            }else{
                imageV.isHidden = true
                nameLab.isHidden = false
                nameLab.text = "#"
            }
        }
    }
    public var mark = false{
        didSet{
            selectBgView.isHidden = !mark
            if content is UIImage {
                selectBgView.isHidden = true
            }
        }
    }
    
    
    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.p_initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - event response
    
    // MARK: - private methods
    
    // MARK: - public methods
    func p_initView() {
        self.backgroundColor = .clear
        addSubview(selectBgView)
        addSubview(nameLab)
        addSubview(imageV)
        
        selectBgView.mas_makeConstraints { (make) in
            make?.center.mas_equalTo()
            make?.height.mas_equalTo()(self.mas_height)?.offset()(-2)
            make?.width.mas_equalTo()(selectBgView.mas_height)
        }
        nameLab.mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(UIEdgeInsets.zero)
        }
        imageV.mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(UIEdgeInsets.zero)
        }
        
        DispatchQueue.main.async {
            self.selectBgView.layer.cornerRadius = self.selectBgView.frame.size.width*0.5
        }
    }
    // MARK: - setter
    
    // MARK: - getter
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init()
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.init(hexString: "#484A4D")
        nameLab.font = UIFont.systemFont(ofSize: 10,weight: .medium)
        return nameLab
    }()
    lazy var imageV: UIImageView = {
        let imageV = UIImageView.init()
        imageV.isHidden = true
        imageV.contentMode = .center
        return imageV
    }()
    lazy var selectBgView: UIView = {
        let selectBgView = UIView.init()
        selectBgView.backgroundColor = UIColor.init(hexString: "#29C449")
        selectBgView.isHidden = true
        return selectBgView
    }()
    
}
