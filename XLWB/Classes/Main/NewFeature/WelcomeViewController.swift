//
//  WelcomeViewController.swift
//  sina
//
//  Created by 阮浩 on 17/10/21.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
//头像距离底部的距离
    @IBOutlet weak var iconButtomCons: NSLayoutConstraint!
    //头像图片
    @IBOutlet weak var iconImageView: UIImageView!
    //昵称
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置头像圆角
        iconImageView.layer.cornerRadius = 45
        //超出部分减掉
        iconImageView.layer.masksToBounds = true
//        assert(UserAcount.loadAcount() != nil,"必须先进行授权")
        //设置头像
//        guard let url = NSURL(string: UserAcount.loadAcount()!.avatar_large!) else{
//            return
//        }
//        iconImageView.sd_setImage(with: url as URL, completed: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        //让头像执行动画
        iconButtomCons.constant = (self.view.bounds.size.height - iconButtomCons.constant)
        
        UIView.animate(withDuration: 2.0, animations: { 
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 2.0, animations: {
                self.titleLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                //跳转到首页
//                let sb = UIStoryboard(name: "NewFeatureViewController", bundle: nil).instantiateInitialViewController()
                let sb = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = sb
            })
        }
    }
}
