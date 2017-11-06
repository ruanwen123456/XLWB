//
//  BaseViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    //定义是否登录的标识
    var isLogin = UserAcount.islogin()
    
    //访客视图
    var visitorview : visitorView?
    
    //重写父类的方法
    override func loadView() {
        //判断用户是否登录 没有显示访客界面
        //        isLogin ? super.loadView() : setUpVistitorView()
        if isLogin {
            super.loadView()
        }else{
            setUpVistitorView()
        }
    }
    //自定义访客view
    func setUpVistitorView() -> Void {
        
        visitorview = visitorView.visitorView()
        
        view = visitorview
        
        visitorview?.loginBtn.addTarget(self, action: #selector(LoginBtn), for: UIControlEvents.touchUpInside)
        visitorview?.registerBtn.addTarget(self, action: #selector(registBtn), for: UIControlEvents.touchUpInside)
        
        //添加导航条按钮内容
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registBtn))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginBtn))
    }
    //登录注册按钮实现
    func LoginBtn( btn:UIButton){
        
        let sb = UIStoryboard.init(name: "oAuthViewController", bundle: nil)
        //        let sb = R.storyboard.oAuthViewController()
        guard let vc = sb.instantiateInitialViewController() else
        {
            return
        }
        present(vc, animated: true, completion: nil)
        
        RHlog(message: "LoginBtn")
    }
    
    func registBtn( btn:UIButton){
        RHlog(message: "registBtn")
    }

}
