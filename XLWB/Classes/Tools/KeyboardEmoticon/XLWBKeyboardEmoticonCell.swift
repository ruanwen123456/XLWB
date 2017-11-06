//
//  XLWBKeyboardEmoticonCell.swift
//  表情键盘
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit


class XLWBKeyboardEmoticonCell: UICollectionViewCell {
    
    /// 当前行对应的表情模型
    var emoticon: XLWBKeyboardEmoticon?
        {
        didSet{
            // 1.显示emoji表情
            iconButton.setTitle(emoticon?.emoticonStr ?? "", for: UIControlState.normal)
            
            // 2.设置图片表情
             iconButton.setImage(nil, for: UIControlState.normal)
            if emoticon?.chs != nil
            {
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), for: UIControlState.normal)
            }
            // 3.设置删除按钮
            if emoticon!.isRemoveButton
            {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.white

        // 2.布局子控件
        iconButton.frame = bounds.insetBy(dx: 4, dy: 4)
    }
    
    // MARK: - 懒加载
    private lazy var iconButton: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return btn
    }()
}
