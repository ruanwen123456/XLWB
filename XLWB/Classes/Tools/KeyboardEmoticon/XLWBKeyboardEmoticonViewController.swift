//
//  XLWBKeyboardEmoticonViewController.swift
//  表情键盘
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class XLWBKeyboardEmoticonViewController: UIViewController {

    /// 保存所有组数据
    var packages: [XLWBKeyboardPackage] = XLWBKeyboardPackage.loadEmotionPackages()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        // 2.布局子控件
        let dict = ["collectionView": collectionView, "toolbar": toolbar] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolbar(49)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(cons)
    }
    
    // MARK: - 内部控制方法
    @objc private func itemClick(item: UIBarButtonItem)
    {
        // 1.创建indexPath
//        let indexPath = NSIndexPath(item: 0, section: item.tag)

        let indexPath = NSIndexPath(item: 0, section: item.tag)
//          let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        // 2.滚动到指定的indexPath
        collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.left,animated: false)
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
       let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: XLWBKeyboardEmoticonLayout())
        clv.backgroundColor = UIColor.green
        clv.dataSource = self
        clv.delegate = self
        clv.register(XLWBKeyboardEmoticonCell.self, forCellWithReuseIdentifier: "keyboardCell")
       return clv
    }()
    
    private lazy var toolbar: UIToolbar = {
       let tb = UIToolbar()
        tb.tintColor = UIColor.lightGray
        
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近", "默认", "Emoji", "浪小花"]
        {
            // 1.创建item
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClick))
            item.tag = index
            index = index + 1
            items.append(item)
            // 2.创建间隙
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
             items.append(flexibleItem)
        }
        items.removeLast()
        // 2.将item添加到toolbar上
        tb.items = items
        return tb
    }()
}

extension XLWBKeyboardEmoticonViewController: UICollectionViewDataSource
{
    // 告诉系统有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    // 告诉系统每组多少个
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyboardCell", for: indexPath) as! XLWBKeyboardEmoticonCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red: UIColor.purple
        // 2.设置数据
//        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        let package = packages[indexPath.section]
        cell.emoticon = package.emoticons![indexPath.item]
        
        // 3.返回cell
        return cell
    }
}

extension XLWBKeyboardEmoticonViewController: UICollectionViewDelegate
{
    /// 监听表情点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        print(emoticon.chs)
        
        // 每使用一次就+1
        emoticon.count += 1
        
        // 判断是否是删除按钮
        if !emoticon.isRemoveButton
        {
            // 将当前点击的表情添加到最近组中
            packages[0].addFavoriteEmoticon(emoticon: emoticon)
        }
    }
}


class XLWBKeyboardEmoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.计算cell宽度
        let width = UIScreen.main.bounds.width / 7
        let height = collectionView!.bounds.height / 3
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        // 2.设置collectionView
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
