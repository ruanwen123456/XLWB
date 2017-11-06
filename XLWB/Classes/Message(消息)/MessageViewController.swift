//
//  MessageViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        //判断用户是否登录
        if  !isLogin {  //没有登录
            //设置访客视图
            visitorview?.setVisitorInfo(imageName: "visitordiscover_image_message", textTitle: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
    }
}
