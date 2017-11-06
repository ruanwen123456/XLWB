//
//  XLWBPictureView.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/29.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SDWebImage
class XLWBPictureView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate{
    //宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    //高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    //布局
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    ///模型数据
    var viewModel:StatusViewModel?
        {
        didSet{
            // 更新配图
            self.reloadData()
            
            // 9.跟新配图尺寸
            let (itemSize, clvSize) = calculateSize()
            // 9.1更新cell的尺寸
            if itemSize != CGSize.zero
            {
                flowLayout.itemSize = itemSize
            }
            // 9.2跟新collectionView尺寸
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        RHPrint(message: viewModel?.thumbnail_pic?.count)
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! HomePictureCell
        cell.backgroundColor = UIColor.cyan
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
        return cell
    }
    ///MARK:-----UICollectionViewDelegate---
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       let url = viewModel?.bmiddle_pic![indexPath.item]
        //弹出控制器 告诉控制器展示那些
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XLWBSHOW"), object: self, userInfo: ["bmiddle_pic":viewModel!.bmiddle_pic!,"indexPath":indexPath])
//        RHPrint(message: url)
    }
    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        let count = viewModel?.thumbnail_pic?.count ?? 0
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = viewModel!.thumbnail_pic!.last?.absoluteString
            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
            let imag = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
            return ((imag?.size)!,(imag?.size)!)
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        // 四张配图
        if count == 4
        {
            let col = 2
            let row = col
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        
    }
}
class HomePictureCell: UICollectionViewCell {
    
    
    var url: NSURL?
        {
        didSet
        {
            //设置图片
            customIconImageView.sd_setImage(with: url as URL!)
            //控制gif图标显示隐藏
            if let flag = url?.absoluteString?.lowercased().hasSuffix("gif"){
                gifLabel.isHidden = !flag
            }
        }
    }
    @IBOutlet weak var customIconImageView: UIImageView!
    //gif图标
    @IBOutlet weak var gifLabel: UILabel!
}
