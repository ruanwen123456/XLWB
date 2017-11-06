//
//  titleBtn.swift
//  sina
//
//  Created by 阮浩 on 17/10/18.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class titleBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        sizeToFit()
    }
    //通过xib/SB调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重写btn布局的方法
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)!
    }

}
