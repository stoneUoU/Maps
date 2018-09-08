//
//  TestSDKVC.swift
//  Maps
//
//  Created by test on 2018/3/7.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
import MethodSDK
class TestSDKVC: BaseToolVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let  pngV = ViewFactorySDK.createView(bgColor: .red)
        self.view.addSubview(pngV)
        pngV.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(100)
        })


        let iconV = ViewFactory.createImage(imgName: "http://img.bizhi.sogou.com/images/2012/02/11/260497.jpg", bgColor: .clear)
        self.view.addSubview(iconV)
        iconV.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(pngV.snp.bottom).offset(24)

            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
