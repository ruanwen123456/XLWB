//
//  QrcodeCreatViewController.swift
//  sina
//
//  Created by 阮浩 on 17/10/20.
//  Copyright © 2017年 阮浩. All rights reserved.
//

import UIKit

class QrcodeCreatViewController: UIViewController {
    //二维码容器
    @IBOutlet weak var customView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //还原滤镜默认属性
        filter?.setDefaults()
        //设置二维码到滤镜
        filter?.setValue("醉挽清风".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        //取出滤镜的图片
        guard  let ciimage = filter?.outputImage else {
            return
        }
//        customView.image = UIImage(ciImage: ciimage)
        customView.image = createNonInterpolatedUIImageFormCIImage(image: ciimage, size: 500)
    }
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
//        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        bitmapRef.draw(bitmapImage, in: extent)
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
}
