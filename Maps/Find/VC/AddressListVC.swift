//
//  AddressListVC.swift
//  Maps
//
//  Created by test on 2017/12/7.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import ContactsUI
//访问通讯录
class AddressListVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar = UIView()
    var centerT = UILabel()
    var backV = UIImageView()
    var spaceV = UIView()
    var btn1 = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUpUI()
        self.view.backgroundColor = .white
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // 5.设置导航栏阴影图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension AddressListVC:CNContactPickerDelegate{
//    func setUpUI(){
//        navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: StatusBarAndNavigationBarH)
//        navigationBar.backgroundColor = UIColor.white
//        self.view.addSubview(navigationBar)
//
//        backV.image = UIImage(named: "icon_return.png")
//        backV.isUserInteractionEnabled = true
//        let backVGes = UITapGestureRecognizer(target: self, action: #selector(self.gesBack(_:)))
//        backV.addGestureRecognizer(backVGes)
//        navigationBar.addSubview(backV)
//        backV.snp.makeConstraints { (make) in
//            make.top.equalTo(StatusBarH)
//            make.left.equalTo(16)
//        }
//
//        //创建中间标题
//        centerT.frame = CGRect(x:ScreenInfo.width/4, y:StatusBarH, width:ScreenInfo.width/2, height:CGFloat(44))
//        centerT.text = "通讯录"
//        centerT.textAlignment = .center
//        centerT.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
//        navigationBar.addSubview(centerT)
//
//        spaceV = UIView()
//        spaceV.backgroundColor = UIColor.colorWithCustom(199, g: 199, b: 204,alpha: 0.70)
//        navigationBar.addSubview(spaceV)
//        spaceV.snp.makeConstraints { (make) in
//            make.bottom.equalTo(navigationBar.snp.bottom).offset(0)
//            make.height.equalTo(CGFloat(0.7))
//            make.width.equalTo(ScreenInfo.width)
//        }
//
//        //创建按钮控件
//        btn1 = ViewFactory.createBtn(title: "获取通讯录",bgColor:UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0),titleColor:UIColor.white, action: .addressList, sender: self)
//        self.view.addSubview(btn1)
//        btn1.snp.makeConstraints{
//            (make) in
//            make.width.equalTo(ScreenInfo.width*2/3)
//            make.height.equalTo(36)
//            make.centerY.equalTo(self.view)
//            make.centerX.equalTo(self.view)
//        }
//    }
//    @objc func gesBack(_ tapGes :UITapGestureRecognizer){
//        DispatchQueue.main.async{
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//}
//extension AddressListVC{
//    //单选联系人
//    func contactPicker(_ picker: CNContactPickerViewController,
//                       didSelect contact: CNContact) {
//        //获取联系人的姓名
//        let lastName = contact.familyName
//        let firstName = contact.givenName
//        print("选中人的姓：\(lastName)")
//        print("选中人的名：\(firstName)")
//
//        //获取联系人电话号码
//        print("选中人电话：")
//        let phones = contact.phoneNumbers
//        for phone in phones {
//            //获得标签名（转为能看得懂的本地标签名，比如work、home）
//            let phoneLabel = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
//            //获取号码
//            let phoneValue = phone.value.stringValue
//            print("\(phoneLabel):\(phoneValue)")
//        }
//    }
//}
//extension AddressListVC{
//    func authorize(){
//        let status = CNContactStore.authorizationStatus(for: .contacts)
//        switch status {
//        case .authorized:
//            let contactPicker = CNContactPickerViewController()
//            //设置代理
//            contactPicker.delegate = self
//            //弹出控制器
//            self.present(contactPicker, animated: true, completion: nil)
//        case .notDetermined:
//            //创建通讯录对象
//            let store = CNContactStore()
//            //请求授权
//            store.requestAccess(for: .contacts, completionHandler: { (isRight : Bool,error : Error?) in
//
//                if isRight {
//                    let contactPicker = CNContactPickerViewController()
//                    //设置代理
//                    contactPicker.delegate = self
//                    //弹出控制器
//                    self.present(contactPicker, animated: true, completion: nil)
//                } else {
//                    print("授权失败")
//                }
//            })
//        default:
//        DispatchQueue.main.async(execute: { () -> Void in
//            let alertController = UIAlertController(title: "通讯录访问受限",
//                                                    message: "点击“设置”，允许访问您的通讯录",
//                                                    preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
//            let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
//                (action) -> Void in
//                let url = URL(string: UIApplicationOpenSettingsURLString)
//                if let url = url, UIApplication.shared.canOpenURL(url) {
//                    if #available(iOS 10, *) {
//                        UIApplication.shared.open(url, options: [:],
//                                                  completionHandler: {
//                                                    (success) in
//                        })
//                    } else {
//                        UIApplication.shared.openURL(url)
//                    }
//                }
//            })
//            alertController.addAction(cancelAction)
//            alertController.addAction(settingsAction)
//            self.present(alertController, animated: true, completion: nil)
//            })
//        }
//    }
//    @objc func toConfirm(sender:UIButton){
//        //1.获取授权状态
//        //CNContactStore 通讯录对象
//        authorize()
//    }
//}
//public extension Selector {
//    static let addressList = #selector(AddressListVC.toConfirm(sender:))
//}

