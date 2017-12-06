//
//  seg1VC.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class Seg1VC: UIViewController {
    let V1 = UIView()
    let V2 = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //渲染View
        self.setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension Seg1VC{
    func setUpUI(){
        V1.backgroundColor = UIColor.red
        self.view.addSubview(V1)
        V1.snp.makeConstraints{
            (make) in
            make.width.height.equalTo(160)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.centerX.equalTo(self.view)
        }
        V2.backgroundColor = UIColor.green
        self.view.addSubview(V2)
        V2.snp.makeConstraints{
            (make) in
            make.width.height.equalTo(160)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.centerX.equalTo(self.view)
        }
        self.view.bringSubview(toFront: V1)
    }
}
