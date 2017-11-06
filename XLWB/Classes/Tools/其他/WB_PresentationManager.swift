//
//  WB_PresentationManager.swift
//  sina
//
//  Created by 阮浩 on 17/10/18.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
//自定义转场通知
let PresentationDidPresented = "PresentationDidPresented"
let PresentationDidDismiss = "PresentationDidDismiss"



class WB_PresentationManager: NSObject ,
UIViewControllerTransitioningDelegate,
    UIViewControllerAnimatedTransitioning
{
    //保存菜单的尺寸
    var pressentFrame = CGRect.zero
    //记录是否显示
    var isPresent = false
    //负责返回转场动画对象
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let zc = WB_PresentationController(presentedViewController: presented, presenting: presenting)
        zc.pressentFrame = pressentFrame
        return zc
    }
    //负责转场动画怎么出现
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        //发送通知告诉调用者状态改变
   
        NotificationCenter.default.post(name: NSNotification.Name(PresentationDidPresented), object: self)
        
        return self
    }
    //负责转场动画怎么消失
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        NotificationCenter.default.post(name: NSNotification.Name(PresentationDidDismiss), object: self)
        return self
    }
    //展现消失动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 999
    }
    //用于管理model如何展现和消失 无论展现还是消失都会调用
    //只要实现代理方法就不会有默认动画 动画要自己实现
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresent {
            //获取需要弹出的视图
            guard let toVc  = transitionContext.view(forKey: UITransitionContextViewKey(rawValue: UITransitionContextViewKey.to.rawValue)) else{
                return
            }
            //将动画添加上去
            transitionContext.containerView.addSubview(toVc)
            
            //制作动画
            toVc.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
            //设置锚点
            toVc.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: 0.5, animations: {
                toVc.transform = CGAffineTransform.identity
            }) { (_) in //下划线表示忽略这个值
                //转场动画在执行完毕之后后要告诉系统
                transitionContext.completeTransition(true)
            }
        }else{
            //消失
            guard let formVc  = transitionContext.view(forKey: UITransitionContextViewKey(rawValue: UITransitionContextViewKey.from.rawValue)) else{
                return
            }
            
            
            //执行动画
            UIView.animate(withDuration: 0.5, animations: {
                formVc.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.00001)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
    }

}
