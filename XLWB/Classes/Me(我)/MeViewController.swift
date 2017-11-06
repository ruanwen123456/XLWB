//
//  MeViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户是否登录
        if  !isLogin {  //没有登录
            //设置访客视图
            visitorview?.setVisitorInfo(imageName: "visitordiscover_image_profile", textTitle: "登陆后,你的微博,相册,个人资料会在这里显示")
            return
        }
    }
}
