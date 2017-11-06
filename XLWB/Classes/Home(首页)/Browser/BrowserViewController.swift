
//
//  BrowserViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/29.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SnapKit
class BrowserViewController: UIViewController {
    //保存大图URL
    var bmiddle_pic:[NSURL]?
    //当前点击的索引
    var indexPath:NSIndexPath?
    init(bmiddle_pic:[NSURL],indexPath:NSIndexPath){
        //自定义构造方法时不一定是调用super.init(),需要调用当前设计类的构造函数
        super.init(nibName: nil, bundle: nil)
        self.bmiddle_pic = bmiddle_pic
        self.indexPath = indexPath
        
        //初始化UI
        setUI()
//        self.view.layoutIfNeeded()
    }
    ///MARK---------内部控制方法
    private func setUI(){
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
  
        
        //布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["closeButton": closeButton, "saveButton": saveButton]
        
        let closeHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeButton(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let closeVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(closeHCons)
        view.addConstraints(closeVCons)
        
        let saveHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let saveVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["saveButton":saveButton])
        view.addConstraints(saveHCons)
        view.addConstraints(saveVCons)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.scrollToItem(at: indexPath as! IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    ///MARK:--------------懒加载---------------
   private lazy var collectionView: UICollectionView = {
    let clv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: XLWBLayout())
        clv.dataSource = self
    clv.register(XLWBcell.self, forCellWithReuseIdentifier: "browsweCell")
        return clv
    }()
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.gray
        btn.setTitle("关闭", for: UIControlState.normal)
//        btn.sizeToFit()
        btn.addTarget(self, action: #selector(closeBtn), for: UIControlEvents.touchUpInside)
        return btn
    }()
    private lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.gray
        btn.setTitle("保存", for: UIControlState.normal)
//        btn.sizeToFit()
        btn.addTarget(self, action: #selector(saveBtn), for: UIControlEvents.touchUpInside)
        return btn
    }()
    //关闭按钮实现
    func closeBtn() -> Void {
        dismiss(animated: true, completion: nil)
    }
    //保存按钮实现
    func saveBtn() -> Void {
        //获取当前显示图片的索引
        let index = collectionView.indexPathsForVisibleItems.last
        //获取当前显示的cell
        let cell = collectionView.cellForItem(at: index!) as! XLWBcell
        //获取当前显示的图片
        let img = cell.imageView.image!
        //保存图片
        // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//            UIImageWriteToSavedPhotosAlbum(img!, self, Selector(("image:didFinishSavingWithError:contextInfo:")), nil)
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(save(image:didFinishSavingWithError:contextInfo:)), nil)

        RHlog(message: "保存按钮")
    }
    func save(image:UIImage, didFinishSavingWithError:NSError?,contextInfo:AnyObject) {
        
        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: "保存失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        } else {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
}

extension BrowserViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (bmiddle_pic?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browsweCell", for: indexPath) as! XLWBcell
        cell.imageUrl = bmiddle_pic?[indexPath.item]
        return cell
    }
}
///MARK:-------自定义cell
class XLWBcell :UICollectionViewCell,UIScrollViewDelegate{
    var imageUrl:NSURL?
        {
        didSet{
            //显示菊花
            IndicatorView.startAnimating()
            //重置约束
            resetView()
            RHlog(message: "--------")
            imageView.sd_setImage(with: imageUrl as URL!, placeholderImage: nil, options: SDWebImageOptions(rawValue:0)) { (image, error, _, _) in
                //关闭菊花
                self.IndicatorView.stopAnimating()
    
                let scrale = (image?.size.height)! / (image?.size.width)!
                let screenW = UIScreen.main.bounds.size.width
                let ScreenH = UIScreen.main.bounds.size.height
                let ImageH = screenW * scrale
                self.imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: screenW, height: ImageH))
                
                if ImageH < ScreenH{ //短图
                    
                    let offsetY = (ScreenH - ImageH) * 0.5
                    self.scrollerview.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
                }else{
                    self.scrollerview.contentSize = CGSize.init(width: screenW, height: ImageH)
//                    self.scrollerview.frame = CGRect.init(x: 0, y: 0, width: screenW, height: (image?.size.height)!)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    ///添加scrollerview子控件
    func setUI(){
        contentView.addSubview(scrollerview)
        scrollerview.addSubview(imageView)
        contentView.addSubview(IndicatorView)
        //布局子控件
        scrollerview.frame = UIScreen.main.bounds
        IndicatorView.center = contentView.center
    }
    ///MARK:---------------懒加载------------
    ///创建scrollerView 设置缩放倍数
    lazy var scrollerview: UIScrollView = {
        let scr =  UIScrollView()
        scr.minimumZoomScale = 0.5
        scr.maximumZoomScale = 2.0
        scr.delegate = self
        return scr
    }()
    lazy var imageView:UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///懒加载菊花
    lazy var IndicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    ///MARK:-------------UIScrollViewDelegate-------------
    func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        // 1.计算上下内边距
        var offsetY = (height - imageView.frame.height) * 0.5
        // 2.计算左右内边距
        var offsetX = (width - imageView.frame.width) * 0.5
        
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    // MARK: - 内部控制方法重置尺寸
    private func resetView()
    {
        scrollerview.contentSize = CGSize.zero
        scrollerview.contentInset = UIEdgeInsets.zero
        scrollerview.contentOffset = CGPoint.zero
        
        imageView.transform = CGAffineTransform.identity
    }
}

class XLWBLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.bounces = false //关闭回弹
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
