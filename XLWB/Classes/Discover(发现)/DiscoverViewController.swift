//
//  DiscoverViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户是否登录
        if  !isLogin {  //没有登录
            //设置访客视图
            visitorview?.setVisitorInfo(imageName: "visitordiscover_image_message", textTitle: "登陆后,最新,最热微博仍尽在掌握,不会再与实事潮流擦肩而过")
            return
        }
    }
}
