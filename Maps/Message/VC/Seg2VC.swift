//
//  seg2VC.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class Seg2VC: UIViewController,UITextFieldDelegate {
    var btn1 = UIButton()
    var btn2 = UIButton()
    var label1 = UILabel()
    var label2 = UILabel()
    var imgV = UIImageView()
    var txtFiled = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:.handleTap))
        //self.view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension Seg2VC{
    func setUpUI(){
        //创建按钮控件
        btn1 = ViewFactory.createBtn(title: "点击函数",bgColor:UIColor.black,titleColor:UIColor.white, action: .btnConfirm, sender: self)
        self.view.addSubview(btn1)
        btn1.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.centerX.equalTo(self.view)
        }

        btn2 = ViewFactory.createBtn(title: "确定",bgColor:UIColor.black,titleColor:UIColor.white, action: .btnConfirm, sender: self,size:18)
        btn2.tag = 6
        self.view.addSubview(btn2)
        btn2.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(btn1.snp.bottom).offset(12)
            make.centerX.equalTo(self.view)
        }

        //创建文本标签
        label1 = ViewFactory.createLabel(title:"我是林磊,可以点击",bgColor:UIColor.cyan,titleColor:UIColor.red,pos:.center,size:16)
        label1.isUserInteractionEnabled = true
        label1.addGestureRecognizer(UITapGestureRecognizer(target:self,action:.labGestUre))
        self.view.addSubview(label1)
        label1.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(btn2.snp.bottom).offset(12)
            make.centerX.equalTo(self.view)
        }

        //创建文本标签
        label2 = ViewFactory.createLabel(title:"我是林磊,不可点击",bgColor:UIColor.cyan,titleColor:UIColor.red,pos:.center,size:10)
        self.view.addSubview(label2)
        label2.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(label1.snp.bottom).offset(12)
            make.centerX.equalTo(self.view)
        }

        //创建文本标签
        imgV = ViewFactory.createImage(imgName: "https://www.365greenlife.com//static_file/uploads/10006/5d362cdec45e11e7a1076c0b849ba396.png", bgColor: .white,ifCircle:true,circleTax: 36)
        self.view.addSubview(imgV)
        imgV.snp.makeConstraints{
            (make) in
            make.width.equalTo(72)
            make.height.equalTo(72)
            make.top.equalTo(label2.snp.bottom).offset(12)
            make.centerX.equalTo(self.view)
        }

        //创建文本输入框
        txtFiled = ViewFactory.createTextField(placeHolder: "工厂方法创建样式",sender: self)
        txtFiled.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(txtFiled)
        txtFiled.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(imgV.snp.bottom).offset(12)
            make.centerX.equalTo(self.view)
        }
    }
}
extension Seg2VC{
    @objc func toConfirm(sender:UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let sectorV = Seg2InnerVC()
            sectorV.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sectorV , animated: true)
        })
    }
    @objc func toGestUre(_ tapGes :UITapGestureRecognizer){
        print("label")
    }
    //对应方法
    @objc func toHandleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            txtFiled.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
}
public extension Selector {
    static let btnConfirm = #selector(Seg2VC.toConfirm(sender:))
    static let labGestUre = #selector(Seg2VC.toGestUre(_:))
    static let handleTap = #selector(Seg2VC.toHandleTap(sender:))
}
