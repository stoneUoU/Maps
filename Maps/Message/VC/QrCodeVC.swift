//
//  QrCodeVC.swift
//  Maps
//
//  Created by test on 2017/11/3.
//  Copyright © 2017年 com.youlu. All rights reserved.
//


import UIKit
import SnapKit
class QrCodeVC: UIViewController,UIGestureRecognizerDelegate {
    var qrCodeV = UIImageView()
    var barCodeV = UIImageView()
    //声明导航条
    var navigationBar:UINavigationBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar!)
        onAdd()
        //带图片的二维码图片
        qrCodeV.image = createQRForString(qrString: "http://www.irockes.cn/Gfoods.html",
                                          qrImageName: "icon.png")
        //条形码：
        barCodeV.image = createBarForString(messgae:"888888888888", width: 240,height:72)
        self.view.addSubview(qrCodeV)
        qrCodeV.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.width.equalTo(240)
            make.height.equalTo(240)
        }

        self.view.addSubview(barCodeV)
        barCodeV.snp_makeConstraints { (make) in
            make.top.equalTo(qrCodeV.snp.bottom).offset(24)
            make.centerX.equalTo(self.view)
            make.width.equalTo(240)
            make.height.equalTo(72)
        }


        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    func createBarForString(messgae:NSString,width:CGFloat,height:CGFloat) -> UIImage {
        var returnImage:UIImage?
        if (messgae.length > 0 && width > 0 && height > 0){
            let inputData:NSData? = messgae.data(using: String.Encoding.utf8.rawValue)! as NSData
            // CICode128BarcodeGenerator
            let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
            filter.setValue(inputData, forKey: "inputMessage")
            var ciImage = filter.outputImage!
            let scaleX = width/ciImage.extent.size.width
            let scaleY = height/ciImage.extent.size.height
            ciImage = ciImage.applying(CGAffineTransform.init(scaleX: scaleX, y: scaleY))
            returnImage = UIImage.init(ciImage: ciImage)
        }else {
            returnImage = nil;
        }
        return returnImage!
    }
    //创建二维码图片
    func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8,
                                               allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage

            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")

            // 返回二维码image
            let codeImage = UIImage(ciImage: colorFilter.outputImage!
                .applying(CGAffineTransform(scaleX: 5, y: 5)))

            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x:0, y:0, width:codeImage.size.width,
                                  height:codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)

                codeImage.draw(in: rect)
                let avatarSize = CGSize(width:rect.size.width * 0.25,
                                        height:rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x:x, y:y, width:avatarSize.width,
                                          height:avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()

                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
extension QrCodeVC{
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:100, height:30)
        //button.backgroundColor = UIColor.cyan
        button.setImage(UIImage(named:"icon_fanhui_default"), for: .normal)
        button.imageView?.contentMode = .left
        button.addTarget(self, action: #selector(QrCodeVC.goBack), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem(customView: button)
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -48;
        //设置导航栏标题
        navigationItem.title = "我的二维码"
        navigationItem.leftBarButtonItems = [spacer,leftBarBtn]
        //取消iOS11返回按钮的bug
        if #available(iOS 11.0, *) {
            button.setTitle("\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp我我我我", for: .normal)
        }
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}
