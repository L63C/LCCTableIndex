//
//  IndexIndicatorView.swift
//  TableIndex
//
//  Created by L63 on 2021/3/19.
//

import UIKit
import LCCTools

class LCIndexIndicatorView: UIView {
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
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#ADAFB3")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        performOnce(aselector: #selector(p_initView))
    }
    
    // MARK: - delegate
    
    // MARK: - event response
    
    // MARK: - private methods
    @objc func p_initView(){
        let layer = CAShapeLayer.init()
        layer.path = p_drawIndicatorPath(size: self.frame.size).cgPath
        self.layer.mask = layer;
        
        self.addSubview(self.nameLab)
        self.addSubview(self.imageV)
        
        self.imageV.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()
            make?.bottom.mas_equalTo()
            make?.left.mas_equalTo()
            make?.width.mas_equalTo()(self.imageV.mas_height)
        }
        self.nameLab.mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(self.imageV)
        }
        
    }
    
    
    func p_drawIndicatorPath(size:CGSize) -> UIBezierPath {
        guard size.width > size.height else {
            assert(false,"need width > height")
            return UIBezierPath.init()
        }
        let indicatorRadius = size.height / 2
        
        let sinPI_4_Radius = sin(.pi / 4) * indicatorRadius
//        let margin = (size.width - size.height) * 0.5 //圆在控件中心
        let margin : CGFloat = 0.0// 圆靠控件的左侧
        // 开始点逆时针 45度，计算坐标
        let startPoint = CGPoint.init(x: margin + indicatorRadius + sinPI_4_Radius, y: indicatorRadius - sinPI_4_Radius)
        /// 尖尖在控件右边居中
        let trianglePoint = CGPoint.init(x: size.width, y: size.height * 0.5)
        let centerPoint = CGPoint.init(x: margin + indicatorRadius, y: indicatorRadius)
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to:startPoint)
        bezierPath.addArc(withCenter: centerPoint, radius: CGFloat(indicatorRadius), startAngle: -.pi / 4, endAngle: .pi / 4, clockwise: false)

        bezierPath.addLine(to: trianglePoint)
        bezierPath.addLine(to: startPoint)
        bezierPath.close()
        return bezierPath
    }
    // MARK: - public methods
    
    // MARK: - setter
    
    // MARK: - getter
    lazy var nameLab: UILabel = {
        let nameLab = UILabel.init()
        nameLab.textAlignment = .center
        nameLab.textColor = .white
        nameLab.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return nameLab
    }()
    lazy var imageV: UIImageView = {
        let imageV = UIImageView.init()
        imageV.isHidden = true
        imageV.contentMode = .center
        return imageV
    }()
}
