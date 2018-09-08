//
//  SubVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class AdapcellVC:BaseToolVC{
    var tableV = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp(centerVals: "自适应", rightVals: "")
        self.view.backgroundColor = UIColor.white
        tableV = UITableView()
        tableV=UITableView.init(frame: CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - StatusBarAndNavigationBarH - TabbarSafeBotM), style:.plain)
        tableV.delegate = self
        tableV.dataSource = self
        //注册cell
        tableV.register(AdapCell.self, forCellReuseIdentifier: "cell")
//        if #available(iOS 11, *) {
//            tableV.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -AllTabBarH, 0)
//            tableV.contentInset = UIEdgeInsetsMake(0, 0, -AllTabBarH, 0)
//        }

        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableV.estimatedRowHeight = 100
        // 设置 tabelView 行高,自动计算行高
        tableV.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableV)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CustomTabBarVC.hideBar(animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension AdapcellVC{
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
}
//数据源方法
extension AdapcellVC:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV =  UIView()
        return footerV
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AdapCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! AdapCell
        if indexPath.row%2==0 {
            cell.contentLable.text = "我是假数据我是假数据我是假数据"
        }
        else
        {
            if indexPath.row%3 == 0{
                cell.contentLable.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
            else{
                cell.contentLable.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
        }
        return cell
    }

}
