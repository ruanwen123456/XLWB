
//
//  AppDelegate.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //1.设置全局外观 设置全局属性最好在这里设置保证都可以使用
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        // 2.注册监听
        NotificationCenter.default.addObserver(self, selector: Selector(("changeRootViewController:")), name: NSNotification.Name(rawValue: "hahaha"), object: nil)
        //1.创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //2.设置根控制器
        
        window?.rootViewController = DefaultViewController()
        
        //3.显示window
        window?.makeKeyAndVisible()
        return true
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}

func RHlog(message:String,fileName:String = #file,methodName:String = #function,lineNumber: Int = #line) -> Void {
    //如果调用者没传参数会使用默认参数
    print("\( (fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
}
func RHPrint<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        //    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}
extension AppDelegate{
    //用于返回默认的界面
    func DefaultViewController() -> UIViewController{
        //判断是否登录
        if UserAcount.islogin() {
            //判断是否有新版本
            // 2.判断是否有新版本
            if isNewVersion()
            {
                
                return  R.storyboard.newFeatureViewController.instantiateInitialViewController()!
            }else
            {
                return R.storyboard.welcomeViewController.instantiateInitialViewController()!
            }
        }
        //没有登录
        return R.storyboard.main.instantiateInitialViewController()!

    }
    
    //判断是否有新版本
    func isNewVersion() -> Bool {
        //加载infoPlist
        let dict = Bundle.main.infoDictionary
        //获取版本号
        let currntVersion = dict?["CFBundleShortVersionString"] as! String
        //获取以前的版本号进行比较 赋初值为 "1.0"
        let defaults = UserDefaults.standard
        let sanBoxVersion = defaults.object(forKey: "currntVersion") ?? "1.0"
        if currntVersion.compare(sanBoxVersion as! String) == ComparisonResult.orderedDescending{
            RHlog(message: "有新版本")
            //更新版本号
            defaults.set(currntVersion, forKey: "currntVersion")
            return true
        }
        
        RHlog(message: "没有新版本")
        
        return true
    }
}

