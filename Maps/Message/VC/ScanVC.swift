//
//  QRCodeViewController.swift
//  hunbian
//
//  Created by haohao on 16/8/11.
//  Copyright © 2016年 haohao. All rights reserved.
//

import UIKit
import AVFoundation
//播放声音需要的框架
import AudioToolbox

class ScanVC: UIViewController , UIAlertViewDelegate, HandleTheResultDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate{

    var readView : QRCodeReaderView?
    var alertView : UIAlertController?
    //声明导航条
    var navigationBar = UIView()
    var centerT = UILabel()
    var backV = UIImageView()
    var photoT = UILabel()
    var spaceV = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加相册识别二维码的功能
        self.initScan()
        self.view.backgroundColor = .white
        
        //设置状态栏颜色
        if UIDevice.isX() == true{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 88)
        }else{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 64)
        }

        navigationBar.backgroundColor = UIColor.gray
        self.view.addSubview(navigationBar)

        backV.image = UIImage(named: "icon_return.png")
        backV.isUserInteractionEnabled = true
        let backVGes = UITapGestureRecognizer(target: self, action: #selector(self.gesBack(_:)))
        backV.addGestureRecognizer(backVGes)
        navigationBar.addSubview(backV)
        backV.snp.makeConstraints { (make) in
            make.top.equalTo(UIDevice.isX() == true ? CGFloat(44) : CGFloat(20))
            make.left.equalTo(16)
        }

        //创建中间标题
        centerT.frame = CGRect(x:ScreenInfo.width/4, y:UIDevice.isX() == true ? CGFloat(44) : CGFloat(20), width:ScreenInfo.width/2, height:CGFloat(44))
        centerT.text = "发现"
        centerT.textAlignment = .center
        centerT.textColor = .white
        navigationBar.addSubview(centerT)

        //创建相册
        photoT.text = "相册"
        photoT.textAlignment = .center
        photoT.textColor = .white
        photoT.isUserInteractionEnabled = true
        let photoTGes = UITapGestureRecognizer(target: self, action: #selector(self.gesPhoto(_:)))
        photoT.addGestureRecognizer(photoTGes)
        navigationBar.addSubview(photoT)
        photoT.snp.makeConstraints { (make) in
            make.top.equalTo(UIDevice.isX() == true ? CGFloat(44) : CGFloat(20))
            make.height.equalTo(CGFloat(44))
            make.right.equalTo(-16)
        }

        spaceV = UIView()
        spaceV.backgroundColor = .white
        navigationBar.addSubview(spaceV)
        spaceV.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigationBar.snp.bottom).offset(-1)
            make.height.equalTo(CGFloat(1))
            make.width.equalTo(ScreenInfo.width)
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        //识别二维码
        if image != nil {
            let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let img = CIImage(cgImage: (image?.cgImage)!)
            let features : [CIFeature]? = detector.features(in: img, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            if features != nil && (features?.count)! > 0 {
                let feature = features![0]
                if feature.isKind(of: CIQRCodeFeature.self)
                {
                    let featureTmp:CIQRCodeFeature = feature as! CIQRCodeFeature

                    let scanResult = featureTmp.messageString
                    self.handleResult(scanResult!)
                }
            }

        }
        picker.dismiss(animated: true, completion: nil)
    }

    //加载扫描框
    func initScan() {
        let authorStaus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if [authorStaus == .restricted, authorStaus == .denied].contains(true){
            if self.alertView != nil {
                self.alertView = nil
            }
            self.alertView = UIAlertController.init(title: "温馨提示", message: "相机权限受限，请在设置->隐私->相机 中进行设置！", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: { (cancelaction) in

            })
            let setAction = UIAlertAction.init(title: "去设置", style: .default, handler: { (setaction) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if UIApplication.shared.canOpenURL(url as! URL) {
                    UIApplication.shared.openURL(url as! URL)
                }
            })
            self.alertView?.addAction(cancelAction)
            self.alertView?.addAction(setAction)
            self.present(self.alertView!, animated: true, completion: nil)
            return
        }

        if self.readView != nil{
            self.readView?.removeFromSuperview()
            self.readView = nil
        }
        self.readView = QRCodeReaderView.init(frame: UIScreen.main.bounds)
        self.readView?.delegate = self
        self.readView?.puinMyCodeController = {() in
            //进入我的二维码界面
//            let  storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "MineQRCodeViewController")
//            self.navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.async{
                let qrcodeV = QrCodeVC()
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(qrcodeV , animated: true)
                //self.hidesBottomBarWhenPushed = false
            }
        }
        self.readView?.backgroundColor = UIColor.white
        self.view.addSubview(self.readView!)
    }

    //重新扫描的方法
    func reStartScan() {
        if self.readView?.scanType != .barCode {
            self.readView?.creatDrawLine()
            self.readView?.startLineAnimation()
        }
        self.readView?.start()
    }

    //View将要出现的时候重新扫描
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        if self.readView != nil {
            self.reStartScan()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.readView != nil {
            self.readView?.stop()
        }
    }

    //处理扫描结果
    func handleResult(_ result: String) {
        print("处理扫描结果\(result)")
    }

    //MARK: ---UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            print("去设置")
        }
    }

    //MARK:----HandleTheResultDelegate
    func handelTheResult(_ metadataObjectString: String) {
        //停止扫描
        self.readView?.stop()
        //播放扫描二维码的声音
        //这个只能播放不超过30秒的声音，它支持的文件格式有限，具体的说只有CAF、AIF和使用PCM或IMA/ADPCM数据的WAV文件
        //声音地址
        let path = Bundle.main.path(forResource: "noticeMusic", ofType: "wav")
        //建立的systemSoundID对象
        var soundID : SystemSoundID = 0
        let baseURL = URL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL as CFURL, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)

        //如果是提醒的话

        //处理扫描结果
        self.handleResult(metadataObjectString)

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

extension ScanVC{
    @objc func gesBack(_ tapGes :UITapGestureRecognizer){
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func gesPhoto(_ tapGes :UITapGestureRecognizer){
        //进入相册
        DispatchQueue.main.async{
            let picker = UIImagePickerController()

            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

            picker.delegate = self;

            picker.allowsEditing = true

            self.present(picker, animated: true, completion: nil)
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

