//
//  User.swift
//  sina
//
//  Created by 阮浩 on 17/10/23.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class User: NSObject {
    //用户标识
    var idstr:String?
    //用户昵称
    var screen_name:String?
    //用户头像
    var profile_image_url:String?
    //微博认证-1:没有认证 0:认证用户 ，2，3，5企业认证 220:微博达人
    var verified_type:Int = 0
    //vip等级 默认-1
    var mbrank:Int = -1
    
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
        let property = ["idstr", "screen_name", "profile_image_url","verified_type"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }

}
