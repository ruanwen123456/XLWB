//
//  ListzViewModel.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/29.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SDWebImage
class ListzViewModel: UIView {
    //定义数组保存模型数据
    var statues:[StatusViewModel]?
    func loadData(lastWb:Bool,finished: @escaping (_ models:[StatusViewModel]? ,_ error:NSError?)->( )){
        //准备id
        var sinde_id = statues?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastWb{
            sinde_id = "0"
            max_id = statues?.last?.status.idstr ?? "0"
        }
        NetWorkTool.shareInstance.loadStatue(since_id: sinde_id,max_id:max_id) { (arr, error) in
            if error != nil{
                finished(nil, error as NSError?)
                return
            }
            //将字典转成模型数组
            var modes = [StatusViewModel]()
            
            for dict in arr!{
                let statues = Statue(dict: dict)
                let viewModel = StatusViewModel(status: statues)
                modes.append(viewModel)
            }
            // 3.处理微博数据
            if sinde_id != "0"
            {
                self.statues = modes + self.statues!
            }else if max_id != "0"{
                self.statues = self.statues! + modes
            }else{
                self.statues = modes
            }
            
            //缓存微博的配图
            self.cachesImages(models: modes, finished: finished)
        }
    }
    ///缓存配图实现 pic_urls
    func cachesImages(models:[StatusViewModel],finished:@escaping (_ models:[StatusViewModel]? ,_ error:NSError?)->( )) -> Void {
        
        let group = DispatchGroup.init()
        
        for mode in models {
            guard let picurls = mode.thumbnail_pic else{
                //微博没配图跳过
                continue
            }
            for url in picurls {
                //开线程
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    RHlog(message: "图片下载完成")
                    group.leave()
                })
            }
        }
        // 监听下载完成的操作
        group.notify(queue: DispatchQueue.main) {
            RHlog(message: "图片全部下载完成")
            finished(models, nil)
        }
    }
}
