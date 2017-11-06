//
//  XLTextView.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/31.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SnapKit
class XLTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
    }
    // MARK: - 内部控制方法
    private func setupUI()
    {
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(5)
        }
        
        //通知监听是否有输入
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textChange(){
        placeholderLabel.isHidden = hasText
    }
    // MARK: - 懒加载
    private lazy var placeholderLabel: UILabel =
        {
            let lb = UILabel()
            lb.textColor = UIColor.lightGray
            lb.text = "分享新鲜事..."
            lb.font = self.font
            return lb
    }()
}
