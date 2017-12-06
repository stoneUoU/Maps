//
//  AppStartCollectCell.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
//import RealmSwift
////realm数据库存是否是第一次进入App
//class IfFirst:Object{
//    //类型名
//    dynamic var ifIs = ""
//}
class AppStartCollectCell: UICollectionViewCell {
    
    
    fileprivate let newImageView = UIImageView(frame: ScreenBounds)
    fileprivate let nextBtn = UIButton(frame: CGRect(x: (ScreenWidth - 100)*0.5, y: ScreenHeight - 110, width: 100, height: 33))
    
    var newImage:UIImage? {
        didSet{
            newImageView.image = newImage
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        newImageView.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(newImageView)
        nextBtn.setBackgroundImage(UIImage(named: "btn_lijitiyan"), for: UIControlState())
        nextBtn.addTarget(self, action: #selector(AppStartCollectCell.nextBtnClick), for: .touchUpInside)
        nextBtn.isHidden = true
        contentView.addSubview(nextBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNextBtnHidden(_ hidden:Bool) {
        nextBtn.isHidden = hidden
    }
    
    @objc func nextBtnClick() {
//        UserDefaults.standard.set(true, forKey:"ifO")
//        UserDefaults .standard .synchronize()
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "AppStartCtrlDidFinish"), object: nil)
        keychain.set(true, forKey: "ifY")
        SnailNotice.post(notification: .startFinish,object: nil,passDicts:nil)
    }
    //移除通知
    deinit {
        SnailNotice.remove(observer: self, notification: .startFinish)
    }
    
}
