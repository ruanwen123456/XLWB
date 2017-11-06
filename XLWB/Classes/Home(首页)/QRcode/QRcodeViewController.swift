//
//  QRcodeViewController.swift
//  sina
//
//  Created by 阮浩 on 17/10/18.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeViewController: UIViewController {
    //结果文本
    @IBOutlet weak var contantLabel: UILabel!
    //容器视图高度约束

    @IBOutlet weak var contentHeightCons: NSLayoutConstraint!
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    //底部工具条

    @IBOutlet weak var customTabbar: UITabBar!
    //冲击波顶部约束
    @IBOutlet weak var ScanLineCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置默认选中第一个
      
        customTabbar.selectedItem = customTabbar.items?.first
        
        //添加监听底部工具条的点击
        customTabbar.delegate = self
        
        
        //开始扫描二维码
        startScanQrcode()
    }
    
    func startScanQrcode() -> Void {
        //判断输入是否添加到回话中
        if !session.canAddInput(input) {
            return
        }
        //判断输出能否添加到回话中
        if !session.canAddOutput(output) {
            return
        }
        //添加输出输入到会话中
        session.addInput(input)
        session.addOutput(output)
        //设置解析的类型 一定要在输出对象添加后设置否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //设置监听数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //添加预览图层
        view.layer.insertSublayer(preViewLayer, at: 0)
        preViewLayer.frame = view.bounds
        
        //添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        //开始扫描
        session.startRunning()
    }
    

    override func viewDidAppear(_ animated: Bool) {
       setAnimate()
    }
    
    func setAnimate() -> Void {
        //设置冲击波底部和容器顶部视图对齐
        ScanLineCons.constant = -contentHeightCons.constant
        view.layoutIfNeeded()
        //执行扫描动画
        //区分两个变量或者闭包访问外界的属性才需要self
        UIView.animate(withDuration: 2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.ScanLineCons.constant = self.contentHeightCons.constant
            self.view.layoutIfNeeded()
        }
    }
    //关闭按钮实现
    @IBAction func qrcodeClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //相册按钮实现
    @IBAction func photoBtn(_ sender: Any) {
        //打开相册
        //判断是否能打开相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            return
        }
        //创建相册控制器
        let imagePicker = UIImagePickerController()
        
        //设置代理
        imagePicker.delegate = self
        //弹出相册控制器
        present(imagePicker, animated: true, completion: nil)
    }
    
    ///MARK:----------懒加载-------
    //输入对象
    lazy var input: AVCaptureDeviceInput = {
        let  device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try! AVCaptureDeviceInput(device:device)
    }()
    //回话对象联系输出输入
    lazy var session: AVCaptureSession = AVCaptureSession()
    //输出对象
    lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        //设置输出对象范围 默认值CGRect.init(x: 0, y: 0, width: 1, height: 1) 传入的是比例
        //坐标系以横屏的左上角为原点
        out.rectOfInterest = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        return out
        }()
    
    //预览图层
    lazy var preViewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    //用于保存描边图层
    lazy var containerLayer : CALayer = CALayer()
}

///相册代理实现
extension QRcodeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //取出选中的图片
        guard  let image:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        guard let ciImage = CIImage(image:image) else {
            return
        }
        //2 从选中图片中读取二维码
        //2.1创建探测器
        let detector =  CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        //2.2 利用探测器探测数据
        let results = detector?.features(in: ciImage)
        //2.3 取出探测器探测到的数据
        for result in results! {
           RHPrint(message: (result as! CIQRCodeFeature).messageString)
        }
        //实现该方法系统不会主动关闭相册
        picker.dismiss(animated: true, completion: nil)
    }
}
//底部按钮代理实现
extension QRcodeViewController:UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //根据当前的菜单选中重新设置容器高度
        contentHeightCons.constant = (item.tag == 0) ? 240 : 120
        //移除动画
        scanLineView.layer.removeAllAnimations()
        //重新开启动画
        setAnimate()
    }
}

extension QRcodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    //只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        //显示扫描的结果
        contantLabel.text = (metadataObjects.last as AnyObject).stringValue
        
        clearLayers()
        
        // 拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        //通过预览图层将值转换成可识别的类型
        let objc = preViewLayer.transformedMetadataObject(for: metadata)

        
        //对二维码进行描边
        drawLine(objc: objc as! AVMetadataMachineReadableCodeObject)
    }
    
    ///绘制描边
    func drawLine(objc:AVMetadataMachineReadableCodeObject){
        
       //先清除描边
         clearLayers()
        
        //安全校验
        guard let arr = objc.corners else {
            return
        }
        
        //创建图片,用于保存绘制的图形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        //线段的颜色
        layer.strokeColor = UIColor.cyan.cgColor
        //填充色
        layer.fillColor = UIColor.clear.cgColor
        //创建贝瑟儿路径,绘制矩形
        let path = UIBezierPath()
        var index = 0
//        var point = CGPoint.zero
        var addPoint = CGPoint.init(dictionaryRepresentation: arr[index] as! CFDictionary)!
        index += 1
        //贝瑟儿路径,绘制矩形
        //将起点移到某个点
        path.move(to: addPoint)
        //链接其它点
        while index < arr.count {
            addPoint =  CGPoint.init(dictionaryRepresentation: arr[index] as! CFDictionary)!
            index += 1
            path.addLine(to: addPoint)
        }
        //关闭路径
        path.close()
        
        layer.path = path.cgPath
        //将保存的矩形添加到界面上
        containerLayer.addSublayer(layer)
    }
    //清空描边
    func clearLayers() {
        guard let subLayers = containerLayer.sublayers else {
            return
        }
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}
