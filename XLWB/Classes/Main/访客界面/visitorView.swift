//
//  visitorView.swift
//  sina
//
//  Created by 阮浩 on 17/10/17.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class  visitorView : UIView {
    //转盘
    @IBOutlet weak var turntable: UIImageView!
    //中间视图
    @IBOutlet weak var iconView: UIImageView!
    //文本框
    @IBOutlet weak var textlabel: UILabel!
    //登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    //注册按钮
    @IBOutlet weak var registerBtn: UIButton!

    
    /// 设置访客视图数据
    
    
    ///
    /// - Parameters:
    ///   - imageName: 需要显示的图标 默认是房子首页不需要设置
    ///   - textTitle: 要显示的文本内容
    func setVisitorInfo(imageName:String? , textTitle:String){
        
        textlabel.text = textTitle
        guard let name = imageName else {
            //没有设置图标判断是首页 开启动画转盘转动
            setAnimation()
            return
        }
        //不是首页 设置图标 隐藏转盘
        turntable.isHidden = true
        iconView.image = UIImage(named: name)
        return
    }

    ///设置动画
    func setAnimation() -> Void {
        //创建动画 旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        animation.duration = 8.0
        //视图只要消失系统就会自动移除动画 需要手动关闭移除
        //只要设置为false就不会移除 除非控件被销毁掉
        animation.isRemovedOnCompletion = false
        //将动画添加到图层
        turntable.layer.add(animation, forKey: nil)
    }
    
    //func 相当于OC的减号方法
    //class func相当于OC的加号方法
    //创建view的类方法
    class func visitorView()->visitorView{
        //加载xib
        return Bundle.main.loadNibNamed("visitorView", owner: nil, options: nil)?.last as! visitorView
    }
}
