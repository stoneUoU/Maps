//
//  PresentV.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class PresentV: UIView {
    // MARK: 回调属性
    var cancelBlock: (() -> ())?
    // MARK: 回调属性
    var pushBlock: ((_ canPush:String,_ params:String) -> ())?
    // MARK: 二维码View
    var qrCodeV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PresentV:UITextFieldDelegate{
    func setupUI(){
        // 返回按钮
        let btnClose = UIButton(type: .custom)
        btnClose.setImage(UIImage(named:"btnClose.png"), for: .normal)
        btnClose.addTarget(self, action: #selector(self.smsClick(_:)), for: .touchUpInside)
        self.addSubview(btnClose);
        btnClose.snp_makeConstraints { (make) in
            make.top.equalTo(PublicFunc.setHeight(size: 27))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width/5)
            make.height.equalTo(30)
        }

        //短信验证码登录
        let titleTag = UILabel()
        titleTag.text = "短信验证码登录"
        titleTag.textColor = UIColor.colorWithCustom(242,g:72,b:28)
        titleTag.font=UIFont.UiBoldFontSize(size: 18)
        titleTag.textAlignment = .center
        self.addSubview(titleTag);
        titleTag.snp_makeConstraints { (make) in
            make.top.equalTo(PublicFunc.setHeight(size: 20))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(44)
        }

        let firstBtn = UIButton()
        firstBtn.backgroundColor = UIColor.red
        firstBtn.setTitle("点击测试", for: .normal)
        firstBtn.addTarget(self, action:#selector(toPush(btn:)),for: .touchUpInside)
        firstBtn.titleLabel?.textColor = UIColor.white
        self.addSubview(firstBtn)
        firstBtn.snp.makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(120)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(40)
        }
        //带图片的二维码图片
        qrCodeV.image = createQRForString(qrString: "http://www.irockes.cn/Gfoods.html",
                                          qrImageName: "icon.png")
        self.addSubview(qrCodeV)
        qrCodeV.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
            make.width.equalTo(240)
            make.height.equalTo(240)
        }
    }
}
extension PresentV{
    @objc func smsClick(_ :UIButton){
        if self.cancelBlock != nil {
            self.cancelBlock!()
        }
    }
    @objc func toPush(btn:UIButton) {
        if self.pushBlock != nil {
            self.pushBlock!("demo","Vals")
        }
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
}
