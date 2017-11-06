
//
//  UIBarButtonItem+Extension.swift
//  sina
//
//  Created by 阮浩 on 17/10/17.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    convenience init (imageName:String, action: Selector, target: Any?) {
        self.init()
        //添加导航条的按钮
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "\(imageName)_highlighted"), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.customView = btn
    }
}
