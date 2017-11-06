//
//  Statue.swift
//  sina
//
//  Created by 阮浩 on 17/10/22.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class Statue: NSObject {
    //创建时间
    var created_at:String?
    //微博ID
    var idstr:String?
    //微博信息内容
    var text:String?
    //微博来源
    var source:String?
    //作者信息
    var user:User?
    
    var pic_urls:[[String:AnyObject]]?
    
    /// 保存所有配图URL
    var thumbnail_pic: [NSURL]?
    
    /// 转发微博
    var retweeted_status: Statue?
    
    init(dict:[String:AnyObject]) {
        //基本数据类型可选时super方法不会分配内存 会报方法找不到
        super.init()
        self.setValuesForKeys(dict)
    }
    //setValuesForKeys方法内会调用setValue(_ value: Any?, forKey key: String) 方法
    override func setValue(_ value: Any?, forKey key: String) {
        //拦截user 将内部转成模型
        if key == "user" {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        if key == "retweeted_status" {
            retweeted_status = Statue(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    // 当KVC发现没有对应的key时就会调用
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        // 将模型转换为字典
        let property = ["created_at", "idstr", "text","source"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }

}
