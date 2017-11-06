
//
//  UIButton+Extension.swift
//  sina
//
//  Created by 阮浩 on 17/10/16.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
//UIButton的类扩展
extension UIButton{
    //构造方法前面没有convenience，代表着是初始化构造方法(指定构造方法)，如果没有convenience代表着这是便利构造
    //指定构造方法必须对所有的属性进行初始化，遍历构造不需要初始化，因为遍历构造方法依赖于指定构造方法
    //一般如果想给系统的类提供快速构建的方法 就自定义一个便利构造方法 给系统扩充只能扩充便利的
    convenience init(imageName:String,backgroundImageName:String) {
        //Swift规定在构造方法中要进行初始化
        self.init()
        self.setImage(UIImage(named:imageName), for: UIControlState.normal)
    self.setImage(UIImage(named:"\(imageName)_highlighted"), for: UIControlState.highlighted)
        self.setBackgroundImage(UIImage.init(named: backgroundImageName), for: UIControlState.normal)
        self.setBackgroundImage(UIImage.init(named: "\(backgroundImageName)_highlighted"), for: UIControlState.highlighted)
    }
}
