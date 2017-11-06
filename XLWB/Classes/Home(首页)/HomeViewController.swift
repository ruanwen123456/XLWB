//
//  HomeViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class HomeViewController: BaseViewController{
    //定义数组保存模型数据
    var ListModel : ListzViewModel = ListzViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断用户是否登录
        if  !isLogin {  //没有登录
            //设置访客视图
            visitorview?.setVisitorInfo(imageName: nil, textTitle: "关注一些人，回这里看看有什么惊喜")
            return
        }
        //关闭分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        //设置导航条
             setNav()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(titleChange), name: NSNotification.Name(PresentationDidDismiss), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(titleChange), name: NSNotification.Name(PresentationDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(showBrow), name: NSNotification.Name(rawValue: "XLWBSHOW"), object: nil)
        //获取微博数据
        loadData()

        //设置预估高度
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //自动调整高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        ///MARK:下拉刷新控件
        refreshControl = WBRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        //刚进时显示菊花
        refreshControl?.beginRefreshing()
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
    }
    /*
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     微博ID越大发布时间越晚
     */

    func titleChange() -> Void {
        titleButton.isSelected = !titleButton.isSelected
    }
    
    func loadData(){
        
        ListModel.loadData(lastWb: lastWb) { (models, error) in
            // 1.安全校验
            if error != nil
            {
                SVProgressHUD.showError(withStatus: "获取微博数据失败", maskType: SVProgressHUDMaskType.black)
                return
        }
        //关闭菊花
        self.refreshControl?.endRefreshing()
        
        //显示刷新提醒 刷新几条数据
        self.showRefreshStatus(count: (models?.count)!)
            
            // 刷新表格
            self.tableView.reloadData()
        }
    }
    
    //显示刷新提醒
    func showRefreshStatus(count:Int){
        //设置提醒文本
        if count == 0 {
            tipLabel.text = "没有更多数据"
        }else{
            tipLabel.text = "刷新了\(count)条数据"
        }
        tipLabel.isHidden = false
        //执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: 44)
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: UIViewAnimationOptions(rawValue:0), animations: { 
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
    }
}
 
    
    //初始化导航条
    func setNav() -> Void {
        //添加导航条的按钮
        navigationItem.leftBarButtonItem =  UIBarButtonItem(imageName: "navigationbar_friendattention", action: #selector(leftBtnClick), target: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", action: #selector(rightBtnClick), target: self)
        
        navigationItem.titleView = titleButton
    }
    //监听图片点击的通知
    func showBrow(notice:NSNotification) {
        //网络或者通知得到的数据必须安全校验
        guard let pictures = notice.userInfo?["bmiddle_pic"] else {
            SVProgressHUD.showError(withStatus: "没有图片", maskType: SVProgressHUDMaskType.black)
            return
        }
        guard let index = notice.userInfo?["indexPath"] else {
            SVProgressHUD.showError(withStatus: "没有索引", maskType: SVProgressHUDMaskType.black)
            return
        }
        
        //弹出图片浏览器将所有图片和当前点击的索引给浏览器
        let vc = BrowserViewController(bmiddle_pic: pictures as! [NSURL], indexPath: index as! NSIndexPath)
        present(vc, animated: true, completion: nil)
        RHPrint(message: notice.userInfo)
    }
    ///懒加载按钮
    lazy var titleButton: titleBtn = {
        //设置中间视图
        let btn = titleBtn()
        let title = UserAcount.loadAcount()?.screen_name
        btn.setTitle(title, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(HotBtn), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    //热点按钮实现
    func HotBtn(btn:titleBtn) -> Void {
        RHlog(message: "hah")
        //显示菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        let menuView = sb.instantiateInitialViewController()
        
        //自定义转场动画
        //设置代理
        menuView?.transitioningDelegate = animatorManager
        menuView?.modalPresentationStyle = UIModalPresentationStyle.custom
        present(menuView!, animated: true, completion: nil)
    }
    //销毁通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //左边按钮实现
    @objc private func leftBtnClick()  {
      
    }
    lazy var animatorManager = { () -> WB_PresentationManager in
        let manager = WB_PresentationManager()
        manager.pressentFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 150)
        return manager
    }()
    
    var tipLabel:UILabel = {
        
        let lb = UILabel()
        lb.backgroundColor = UIColor.orange
        lb.text = "没有更多数据"
        lb.textColor = UIColor.white
        lb.textAlignment = NSTextAlignment.center
        let width = UIScreen.main.bounds.size.width
        lb.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        lb.isHidden = true
        return lb
    }()
    
    //最后一条微博的标记
    var lastWb = false
    
    //右边按钮实现 二维码实现
    @objc private func rightBtnClick() {
        //创建二维码控制器
        let sb = UIStoryboard(name: "QRcodeViewController", bundle: nil)
        //弹出二维码控制器
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListModel.statues?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //先取出模型
        let model = ListModel.statues?[indexPath.row]
        let identifier = (model?.status.retweeted_status != nil) ? "forwardCell" : "HomeViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HomeViewCell
        cell.viewModel =  ListModel.statues![indexPath.row]
        //判断是否是最后一条微博
        if indexPath.row == ( ListModel.statues?.count)! - 1{
            RHlog(message: (model?.status.user?.screen_name)!)
            lastWb = true
            loadData()
        }
        return cell
    }
    //计算行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model =  ListModel.statues?[indexPath.row]
        let identifier = (model?.status.retweeted_status != nil) ? "forwardCell" : "HomeViewCell"
        //获取当前的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HomeViewCell
//        //给当前行设置数据
        let Model =  ListModel.statues![indexPath.row]
//        //返回cell的高度
        return cell.calculateRowHeight(viewModel: Model)
    }

}
