//
//  WB_PresentationController.swift
//  sina
//
//  Created by 阮浩 on 17/10/18.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
//自定义转场动画不会移除原有的控制器
class WB_PresentationController: UIPresentationController {
    
    //保存菜单的尺寸
    var pressentFrame = CGRect.zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    //布局转场控件
    override func containerViewWillLayoutSubviews() {
        //containerView: 容器视图
        //presentedView 通过此方法拿到弹出的视图
        presentedView?.frame = pressentFrame
        
        //添加蒙版 将蒙版插入到底层
        containerView?.insertSubview(coverButton, at: 0)
        
        coverButton.addTarget(self, action: #selector(coverBtnClick), for: UIControlEvents.touchUpInside)
    }
    
    //蒙版点击
    @objc func coverBtnClick() -> Void {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK：-----懒加载-------
    private lazy var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        btn.backgroundColor = UIColor.clear
        return btn
    }()
 
}
