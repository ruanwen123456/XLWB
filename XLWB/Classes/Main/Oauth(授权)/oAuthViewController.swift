//
//  oAuthViewController.swift
//  sina
//
//  Created by 阮浩 on 17/10/20.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
import SVProgressHUD
class oAuthViewController: UIViewController {
    //授权网页
    @IBOutlet weak var authWebview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Appkey)&redirect_uri=\(WB_Redirect_uri)"
        let url = NSURL.init(string: str)
        let request = URLRequest.init(url: url as! URL)
        authWebview.loadRequest(request)
        }
   }
extension oAuthViewController : UIWebViewDelegate{
    //开始加载调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        //显示提醒
//        SVProgressHUD.show(withStatus: "正在加载........")
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        // 显示提醒
        SVProgressHUD.showInfo(withStatus: "正在加载中...", maskType: SVProgressHUDMaskType.black)
    }
    //结束加载调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 关闭提醒
        SVProgressHUD.dismiss()
    }
    //每次请求都会调用
    //如果返回false代表不允许 true表示允许
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        //登录界面 https://api.weibo.com/oauth2/authorize?client_id=3128685856&redirect_uri=http://www.baidu.com
        //判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_uri) {
            //授权回调页面
             RHlog(message: "不是授权回调页面")
            return true
        }
        //不是授权回调页面
        //判断回调地址是否包含code=
        let code = "code="
            guard let urlstr = request.url?.query else {
                return false
            }
            if urlstr.hasPrefix(code) {
                //截取code=后面的字符串
                let key = urlstr.substring(from: code.endIndex)
                loadAcessCode(codeStr: key)
                RHlog(message: "授权成功")
                return false
        }
        return false
    }
    ///利用RequestToken获取AcessToken
    func loadAcessCode(codeStr:String?){
        guard let code = codeStr else {
            return
        }
        //准备请求路径
        let path = "oauth2/access_token"
        //准备请求参数
        let parameters = ["client_id": WB_Appkey, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        //发送Post请求
        NetWorkTool.shareInstance.post(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, dict:Any?)  in
                        let account = UserAcount(dict: dict as! [String : AnyObject])
            
            //获取用户信息
            account.loadUserInfo()
            
            //跳转到欢迎界面
            let sb = UIStoryboard(name: "WelcomeViewController", bundle: nil).instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = sb
            
            RHPrint(message: dict)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            RHPrint(message: error)
        }
    }

}
