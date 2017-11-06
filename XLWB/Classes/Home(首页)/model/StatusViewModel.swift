//
//  StatusViewModel.swift
//  sina
//
//  Created by 阮浩 on 17/10/24.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    var status: Statue
    
    init(status: Statue)
    {
        self.status = status
        // 1.设置头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        // 2.设置认证图标
        // 处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        if let type = status.user?.verified_type
        {
            var name = ""
            switch type
            {
            case 0:
                name = "avatar_vip"
            case 2, 3, 5:
                name = "avatar_enterprise_vip"
            case 220:
                name = "avatar_grassroot"
            default:
                name = ""
            }
            verified_image = UIImage(named: name)
        }
        //来源处理
        if let sourceStr: NSString = status.source as NSString?, sourceStr != ""
        {
            // 6.1获取从什么地方开始截取
            let startIndex = sourceStr.range(of: ">").location + 1
            // 6.2获取截取多长的长度
            let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            
            // 6.3截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            
            source_Text = "来自: " + rest
        }
        //时间处理
        if let timeStr = status.created_at
        {
            //                timeStr = "Sun Dec 05 12:10:41 +0800 2014"
            
            // 1.将服务器返回的时间格式化为NSDate
            let formatter = DateFormatter()
            formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
            // 如果不指定以下代码, 在真机中可能无法转换
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
            let createDate = formatter.date(from: timeStr)!
            
            // 创建一个日历类
            let calendar = NSCalendar.current
            /*
             // 该方法可以获取指定时间的组成成分 |
             let comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: createDate)
             NJLog(comps.year)
             NJLog(comps.month)
             NJLog(comps.day)
             */
            
            var result = ""
            var formatterStr = "HH:mm"
            if calendar.isDateInToday(createDate)
            {
                // 今天
                // 3.比较两个时间之间的差值
                let interval = Int(NSDate().timeIntervalSince(createDate))
                
                if interval < 60
                {
                    result = "刚刚"
                }else if interval < 60 * 60
                {
                    result = "\(interval / 60)分钟前"
                }else if interval < 60 * 60 * 24
                {
                    result = "\(interval / (60 * 60))小时前"
                }
            }else if calendar.isDateInYesterday(createDate)
            {
                // 昨天
                formatterStr = "昨天 " + formatterStr
                formatter.dateFormat = formatterStr
                result = formatter.string(from: createDate)
            }else
            {
                // 该方法可以获取两个时间之间的差值
                
                let comps = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: createDate, to: NSDate() as Date)
                //                    let coms = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]
                if comps.year! >= 1
                {
                    // 更早时间
                    formatterStr = "yyyy-MM-dd " + formatterStr
                }else
                {
                    // 一年以内
                    formatterStr = "MM-dd " + formatterStr
                }
                formatter.dateFormat = formatterStr
                result = formatter.string(from: createDate)
            }
            
            created_Time = result
        }
        // 处理配图URL
        // 1.从模型中取出配图数组
//        if let picurls = status.pic_urls
        //如果有转发取转发的数据 没有就返回正常的数据
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls
        {
             thumbnail_pic = [NSURL]()
            bmiddle_pic = [NSURL]()
            // 2.遍历配图数组下载图片
            for dict in picurls
            {
                
                // 2.1取出图片的URL字符串
                guard var urlStr = dict["thumbnail_pic"] as? String else
                {
                    continue
                }
                // 2.2根据字符串创建URL
                let url = NSURL(string: urlStr)!
                thumbnail_pic?.append(url)
                
                urlStr = urlStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
                bmiddle_pic?.append(NSURL(string: urlStr)!)
            }
        }
        //处理转发
        if let text = status.retweeted_status?.text {
            let name = (status.retweeted_status?.user?.screen_name) ?? ""
            forwardText = "@"+name + ":" + text
        }
    }
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图URL
    var thumbnail_pic : [NSURL]?
    
    //微博格式化之后的来源
    var soutce_Text :String = ""
    
    //微博格式化之后的内容
    var forwardText : String?
    
    //保存大图URL
    var bmiddle_pic:[NSURL]?
    
}
