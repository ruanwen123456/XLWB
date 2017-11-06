
//
//  RefreashView.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/28.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SnapKit
//重写刷新控件
class WBRefreshControl: UIRefreshControl {
    override init() {
        super.init()
        //添加子控件
        addSubview(refreshView)
        //布局子控件
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
        //监听UIRefreshControl的frame改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重写结束刷新
    override func endRefreshing(){
        super.endRefreshing()
//        loadingFlag = false
        refreshView.StopLoadingView()
    }
    //懒加载刷新视图
    lazy var refreshView : RefreashView = RefreashView.refreshView()
    //记录是否需要旋转
    var rotationFlag = false
//    var loadingFlag = false
    //监听frame的改变 会调用的方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //越往下拉Y越小 往上变大
        if (frame.origin.y == 0) || (frame.origin.y == -64) {
            return
        }
        //判断是否触发下拉刷新事件
        if isRefreshing {
//            loadingFlag = true
            //隐藏提示视图 显示加载视图
            refreshView.startLoadingView()
            return
        }
  
        if frame.origin.y < -50 && !rotationFlag{
            rotationFlag = true
            RHlog(message: "往上旋转")
            //旋转
            refreshView.rotationArrow(flag: rotationFlag)
        }else if frame.origin.y > -50 && rotationFlag{
            rotationFlag = false
            RHlog(message: "往下旋转")
            //旋转
            refreshView.rotationArrow(flag:rotationFlag)
        }
        
    }
    
}
class RefreashView: UIView {

    //菊花视图
    @IBOutlet weak var LoadingImageView: UIImageView!
    //下拉刷新视图
    @IBOutlet weak var tipView: UIView!
    //下拉刷新箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    //下拉刷新label
    @IBOutlet weak var refreshLabel: UILabel!
    
    class func refreshView() -> RefreashView {
        return Bundle.main.loadNibNamed("RefreashView", owner: nil, options: nil)?.last as! RefreashView
    }
    ///MARK:外部控制方法
    func rotationArrow(flag:Bool){
        
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        /*
         transform旋转动画默认是按照顺时针旋转的
         但是旋转时还有一个原则, 就近原则
         */
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: angle)
        }
//         arrowImageView.transform =  CGAffineTransformRotate(self.arrowImageView.transform, angle)
    }
    //显示提示视图
    func startLoadingView(){
        if let _ = LoadingImageView.layer.animation(forKey: "animation") {
            //添加过就直接返回1334670892 zxc666
            return
        }
        //隐藏提示视图
        tipView.isHidden = true
        //创建动画 旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        animation.duration = 1.0
        //将动画添加到图层
        LoadingImageView.layer.add(animation, forKey: "animation")
    }
    
    //隐藏正在加载
    func StopLoadingView(){
        //显示提示视图
        tipView.isHidden = false
        //移除动画
        LoadingImageView.layer.removeAllAnimations()
    }
}
