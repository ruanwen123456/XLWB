//
//  NewFeatureViewController.swift
//  sina
//
//  Created by 阮浩 on 17/10/21.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
import SnapKit
class NewFeatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
extension NewFeatureViewController : UICollectionViewDataSource{
    //返回分组数
    func numberOfSections(in collectionView: UICollectionView) -> Int{
    return 1
    }
    //返回行数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! NewFeatureCell
        //设置数据
        cell.index = indexPath.item
        return cell
    }
}

extension NewFeatureViewController : UICollectionViewDelegate{
    //cell完全显示的时候调用
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //传入的cell和indexPath都是上页的
        //手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last
        //根据指定的索引获取cell
        let currentCell = collectionView.cellForItem(at: index!) as! NewFeatureCell
        //判断当前是否是最后一页
        if index?.item == 3 {
            //做动画
            currentCell.startAnimation()
        }
    }
}


///MARK---------自定义cell
class NewFeatureCell : UICollectionViewCell{
    var index : Int = 0
        {
        didSet{
            let imageName : String = "new_feature_\(index+1)"
            iconView.image = UIImage(named: imageName)
            begainBtn.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
               //初始化UI
        setupUI()
    }
    
    //放大动画
    func startAnimation() -> Void {
          //每次判断前先隐藏按钮防止复用
        begainBtn.isHidden = false

        //设置初始形变
        begainBtn.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        //形变时关闭交互
//        begainBtn.isUserInteractionEnabled = false
        /*
         withDuration:动画时间
         delay：延迟时间
         usingSpringWithDamping:振幅 值越小震动越厉害
         usingSpringWithDamping:加速度 速度越大值越大
         options:动画附加属性
         animations：执行动画
         completion：执行完动画回调
         */
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {
            //清空动画
            self.begainBtn.transform = CGAffineTransform.identity
            //                    self.setNeedsDisplay()
        }, completion: { (_) in
            //形变完成开交互
//            self.begainBtn.isUserInteractionEnabled = true
            RHlog(message: "")
        })

    }
    
    //初始化UI方法
    func setupUI() -> Void {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        //添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(begainBtn)
        //布局子控件
        //关闭自动布局
        /*
         box.snp.makeConstraints { (make) -> Void in
         make.width.height.equalTo(50)
         make.center.equalTo(self.view)
         }
         */
        //使用自动布局框架SnapKit进行布局
        iconView.snp.makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.bottom.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(0)
            make.edges.equalTo(0)
        }
        begainBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
        /*
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["iconView" : iconView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["iconView" : iconView])
        contentView.addConstraints(cons)
          */
    }
    
    ///MARK--------懒加载
    lazy var iconView = UIImageView()
    
    //进入微博按钮实现
    func begainBtnClick() -> Void {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = sb
    }
    lazy var begainBtn : UIButton = {
        let btn = UIButton(imageName: "", backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(begainBtnClick), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
}

    ///MARK--------自定义布局
    class WBLayerout: UICollectionViewFlowLayout {
        override func prepare() {
            //设置尺寸
            itemSize = UIScreen.main.bounds.size
            //设置间隙 为0
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            //设置滚动方向
            scrollDirection = UICollectionViewScrollDirection.horizontal
            //设置分页
            collectionView?.isPagingEnabled = true
            //关闭回弹
            collectionView?.bounces = false
            //去除滚动条
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
}
