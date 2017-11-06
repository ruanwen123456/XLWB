//
//  UserAcount.swift
//  sina
//
//  Created by 阮浩 on 17/10/20.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class UserAcount: NSObject,NSCoding {
    var access_token : String?
    //从授权之后的多少秒过期
    var expires_in : Int = 0
        {
        didSet{
            // 生成正在过期时间
            expires_Date = NSDate(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    //真正过期时间
    var expires_Date : NSDate?
    var uid : String?
    //头像 用户头像地址（大图），180×180像素
    var avatar_large : String?
    var screen_name : String?
    init(dict:[String:AnyObject]) {
        //基本数据类型可选时super方法不会分配内存 会报方法找不到
        super.init()
        self.setValuesForKeys(dict)
        
    }
    // 当KVC发现没有对应的key时就会调用
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid","expires_Date"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    //定义属性保存模型
    static var account : UserAcount?
    
   static let filePath:String = "account.plist".cachesDir()
    //解归档
    class func loadAcount() -> UserAcount? {

        //判断如果已经存在直接返回
        if UserAcount.account != nil {
            RHlog(message: "已经加载过")
            return UserAcount.account
        }
//        RHPrint(message: "++++++++"+filePath.cachesDir())
        
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAcount.filePath) as? UserAcount else {
            return UserAcount.account
        }

        guard let date = account.expires_Date, date.compare(NSDate() as Date) != ComparisonResult.orderedAscending  else
        {
            RHlog(message: "过期了")
            return nil
        }
        UserAcount.account = account

    return UserAcount.account
    }
    //获取用户信息
    func loadUserInfo() -> Void {
        //准备请求路径
        let path = "2/users/show.json"
        //准备请求参数
        let parameters = ["access_token": access_token, "uid": uid]
        //发送get请求
        NetWorkTool.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, dict:Any?) in
            let dic = dict as! [String : AnyObject]
            self.avatar_large = dic["avatar_large"] as! String?
            self.screen_name = dic["screen_name"] as! String?
            
            //保存授权信息
            self.saveValue()
            RHPrint(message: dict)
        }) {  (task:URLSessionDataTask?, error:Error) in
            RHPrint(message: error)
        }
    }
    //保存模型
    func saveValue() -> Bool {
        //归档
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAcount.filePath)
    }
    //判断用户是否登录
    class func islogin() -> Bool {
        return UserAcount.loadAcount() != nil
    }
    
    ///NSCoding协议实现
    func encode(with aCoder: NSCoder){
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
     required init?(coder aDecoder: NSCoder){
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as! String?
        self.expires_in = Int(aDecoder.decodeCInt(forKey: "expires_in"))
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as! NSDate?
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as! String?
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as! String?
    }
}
