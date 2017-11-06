//
//  MainViewController.swift
//  XLWB
//
//  Created by 阮浩 on 17/10/26.
//  Copyright © 2017年 ruanhao.test. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
        //添加加号按钮
        tabBar.addSubview(PlusButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
        //保存按钮frame
        let rect = PlusButton.frame.size
        //计算按钮宽度
        let BtnWidth = tabBar.bounds.size.width / CGFloat(childViewControllers.count)
        PlusButton.frame = CGRect(x: 2*BtnWidth, y: 0, width: BtnWidth, height: rect.height)
    }
    lazy var PlusButton: UIButton = {
        //创建按钮
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        //调整按钮尺寸
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(MainViewController.PlusBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    @objc func PlusBtnClick(){
        
        RHlog(message: "PlusBtnClick--------")
        let vc = UIStoryboard(name: "Composes", bundle: nil)
        let sb = vc.instantiateInitialViewController()!
        present(sb, animated: true, completion: nil)
}
    
    
    
    
    
    
    
    ///MARK----------手动添加子控制器
    //添加所有子控制器
    func addChildViewControllers() -> Void {
        //根据json数据创建控制器
        //获取文件路径
        let filePath:String? =  Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
        RHlog(message: filePath!)
        guard  let data = NSData(contentsOfFile: filePath!) else {
            RHlog(message: "二进制文件加载失败")
            return
        }
        do {
            //swift中使用的是异常处理机制 只要有throw就必须进行try catch处理
            //try : 正常处理异常 就是通过do catch 处理
            //try! :告诉系统一定不会出现异常 如果异常程序会崩溃
            //try? :告诉系统可能有错 没错会将结果包装返回 有错返回nil
            //优先使用服务器的图片没有在使用默认图片
            let objc = try
                JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String:AnyObject]]
            //            RHPrint(message: objc)
            for dict in objc {
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(childControllerName: vcName, imageName: imageName, title: title)
                //                RHPrint(message: dict)
            }
        }catch{ //只要上面的代码异常就会执行这里的方法 只会执行一种
            
            //1.创建子控制器
            addChildViewController(childControllerName: "HomeViewController", imageName: "tabbar_home", title: "微博")
            addChildViewController(childControllerName: "MessageViewController", imageName: "tabbar_message_center", title: "消息")
            addChildViewController(childControllerName: "NullViewController", imageName: "", title: "")
            addChildViewController(childControllerName: "DiscoverViewController", imageName: "tabbar_discover", title: "发现")
            addChildViewController(childControllerName: "MeViewController", imageName: "tabbar_profile", title: "我")
            
        }
    }
    //方法重载 设置子控制器
    func addChildViewController(childControllerName: String?,imageName:String?,title:String?) {
        //swift中有命名空间 来避免重复默认情况下命名空间的名称就是项目名
        
        
        //动态获取命名空间
        //字典数组只能存储对象所以通过key取出来的值是一个AnyObject对象可能有值或没值
        //guard条件判断语句条件为假时才会执行 解决可选绑定容易形成{}嵌套问题优化阅读体验
        guard let name =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else{
            RHlog(message: "获取命名空间失败") //name为命名空间
            return
        }
        //        RHlog(message: name)
        //swift通过类名来创建一个类前面必须加上命名空间 .不能少
        
        //通过class创建类
        var cls : AnyClass? = nil
        if let vcName = childControllerName {
            cls = NSClassFromString(name+"."+vcName)
        }
        //        RHlog(message: NSStringFromClass(cls!))
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else
        {
            RHlog(message: "cls不能当做UITableViewController")
            return
        }
        // 通过Class创建对象
        let childController = typeCls.init()
        
        childController.tabBarItem.title  = title
        //设置导航栏标题
        childController.navigationItem.title = title
        //判断 图片有值的时候才执行语句
        if let imagename = imageName {
            
            childController.tabBarItem.image = UIImage(named: imagename)
            childController.tabBarItem.selectedImage = UIImage(named: "\(imagename)_highlighted")
        }
        //设置导航控制器 根控制器为视图
        let Nav : UINavigationController = UINavigationController(rootViewController: childController)
        addChildViewController(Nav)
        
    }
}
