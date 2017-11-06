
//
//  XLWBTitleView.swift
//  XLWB
//
//  Created by 阮浩 on 17/11/1.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SnapKit
class XLWBTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    ///MARK:-------内部控制方法--------
    private func setUI(){
        addSubview(titleLabel)
        addSubview(subLabel)
        //布局
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        subLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    ///MARK:---------懒加载-------
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "发送微博"
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    lazy var subLabel:UILabel = {
        let lb = UILabel()
        lb.text = "XLWB"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor.gray
        return lb
    }()
    
}
