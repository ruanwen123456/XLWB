//
//  HomeViewCell.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/27.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SDWebImage
class HomeViewCell: UITableViewCell {
    @IBOutlet weak var footerView: UIView!


//集合视图
    @IBOutlet weak var pictureCollectionView: XLWBPictureView!
//头像
    @IBOutlet weak var IconImageView: UIImageView!
    //昵称
    @IBOutlet weak var nameLabel: UILabel!
    //vip头像
    @IBOutlet weak var vipIconImageView: UIImageView!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //微博来源
    @IBOutlet weak var sourceLabel: UILabel!
    //微博正文
    @IBOutlet weak var contentLabel: UILabel!
    //认证类型
    @IBOutlet weak var bigVimageView: UIImageView!
    //转发正文
    @IBOutlet weak var ForwardLabel: UILabel!
    ///模型数据
    var viewModel:StatusViewModel?
        {
        didSet{
            // 1.设置头像
            IconImageView.sd_setImage(with:viewModel?.icon_URL as URL?)
            
            // 2.设置认证图标
            bigVimageView.image = viewModel!.verified_image
            // 3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 4.设置会员图标
            vipIconImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage
            {
                vipIconImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            // 5.设置时间
            timeLabel.text = viewModel?.created_Time
            // 6.设置来源
            sourceLabel.text = viewModel?.source_Text
            // 7.设置正文
            contentLabel.text = viewModel?.status.text
           //设置配图
            pictureCollectionView.viewModel = viewModel
            //转发微博
//            ForwardLabel.text = viewModel?.forwardText
            if let text = viewModel?.forwardText{
                ForwardLabel.text = text
                //约束最大宽度
                ForwardLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2*10
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置正文最大的宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2*10    }
    
    ///MARK---------外部控制
    func calculateRowHeight(viewModel:StatusViewModel) -> CGFloat {
        //设置数据
        self.viewModel = viewModel
        //更新UI
        self.layoutIfNeeded()
        //返回底部最大的Y
        return footerView.frame.maxY
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

