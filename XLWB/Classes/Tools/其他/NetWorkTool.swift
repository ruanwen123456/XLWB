//
//  NetWorkTool.swift
//  sina
//
//  Created by 阮浩 on 17/10/20.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
import AFNetworking
class NetWorkTool: AFHTTPSessionManager {
    //单例
    static let shareInstance:NetWorkTool = {
        let url = NSURL.init(string: "https://api.weibo.com/") //后面一点要写/
        let instance = NetWorkTool.init(baseURL: url as URL?, sessionConfiguration: URLSessionConfiguration.default)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain","application/json","text/json", "text/javascript") as? Set<String>
        return instance
    }()
    ///MARK-------外部方法
    func loadStatue(since_id:String?,max_id:String,finished:@escaping (_ arr:[[String :AnyObject]]?,_ error:Error?)->()){
        //准备路径
        let path = "2/statuses/home_timeline.json"
        assert(UserAcount.account?.access_token != nil, "必须授权才能强制解包")
        let temp  = (max_id != "0") ? "\(Int(max_id)!  - 1)" : max_id
        //准备参数
          let parameters = ["access_token": UserAcount.loadAcount()!.access_token!, "since_id": since_id, "max_id": temp]
        //请求数据
        get(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, dict:Any?) in
            //返回数据
            guard let arr = (dict as! [String : AnyObject])["statuses"] as? [[String : AnyObject]] else{
                finished(nil, NSError(domain: "weibo", code: 1000, userInfo: ["message":"没有得到数据"]))
                return
            }
            finished(arr, nil)
        }) { (task:URLSessionDataTask?, error:Error) in
           finished(nil, error)
        }
    }
    /// 发送微博
    func sendStatus(status: String, finished: @escaping (_ objc: AnyObject?, _ error: NSError?)->())
    {
        // 1.准备路径
        let path = "2/statuses/update.json"
        // 2.准备参数
        let parameters = ["access_token": UserAcount.loadAcount()!.access_token!, "status": status]
        // 3.发送POST请求
        post(path, parameters: parameters, success: { (task:URLSessionDataTask, dict:Any?) in
            RHPrint(message: dict)
            finished(dict as AnyObject?, nil)
        }) { (task:URLSessionDataTask?, error:Error) in
            RHPrint(message: error)
            finished(nil, error as NSError?)
        }
    }
    
}
