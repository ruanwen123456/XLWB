
//
//  ComposeViewController.swift
//  XLWB
//

//  Created by 阮浩 on 17/11/1.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {
    //表情按钮
    @IBOutlet weak var emotionBtn: UIBarButtonItem!
    //图片选择按钮 
    @IBOutlet weak var picChoseBtn: UIBarButtonItem!
    //发送按钮
    @IBOutlet weak var sendBtnClick: UIBarButtonItem!
    //文本输入框
    @IBOutlet weak var ComposeTextView: XLTextView!
    //toolBar底部约束
    @IBOutlet weak var toolBottomCos: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置默认不可发送
        sendBtnClick.isEnabled = false
        //监听键盘的改变
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //添加自定义键盘
        addChildViewController(ketBoardEmojiVC)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ComposeTextView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //关闭键盘
        ComposeTextView.resignFirstResponder()
    }
    
    ///MARK:------内部控制方法---------
    
    func KeyboardChangeFrame(notice:NSNotification){
        RHPrint(message: notice.userInfo)
        //获取键盘的尺寸
        let rect = notice.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        //获取屏幕高度
        let height = UIScreen.main.bounds.size.height
        let offsetY = height - rect.origin.y
        self.toolBottomCos.constant = offsetY
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
//关闭按钮实现

    @IBAction func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //发送按钮实现

    @IBAction func sendBtnClick(_ sender: Any) {
        //获取用户输入内容
        let text = ComposeTextView.text
        //发送微博
        NetWorkTool.shareInstance.sendStatus(status: text!) { (objc, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: "发送失败", maskType: SVProgressHUDMaskType.black)
            }else{
                self.closeBtnClick()
            }
        }
    }
    
    //图片选择按钮实现
    @IBAction func picChoseBtn(_ sender: Any) {
        
    }
    
    //表情键盘
    @IBAction func emotionBtn(_ sender: Any) {
        //要想切换键盘需要先将原来的关闭 在重新打开键盘
        ComposeTextView.resignFirstResponder()
        
        if ComposeTextView.inputView != nil{
            //切换系统键盘
            ComposeTextView.inputView = nil
        }else{
            //切换自定义键盘
            ComposeTextView.inputView = ketBoardEmojiVC.view
        }
        //重新打开键盘
        ComposeTextView.becomeFirstResponder()
    }
    
    //懒加载表情键盘控制器
    lazy var ketBoardEmojiVC:XLWBKeyboardEmoticonViewController = XLWBKeyboardEmoticonViewController()
}

extension ComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView){
        //控制发送按钮是否可以使用
        sendBtnClick.isEnabled = textView.hasText
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        ComposeTextView.resignFirstResponder()
    }
}
