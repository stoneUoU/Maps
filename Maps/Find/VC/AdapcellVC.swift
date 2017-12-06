//
//  SubVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
class AdapcellVC: UIViewController,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar:UINavigationBar?
    var tableV = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        tableV = UITableView()
        tableV=UITableView.init(frame: CGRect(x:0,y:CGFloat(StatusBarAndNavigationBarH),width:ScreenInfo.width,height:ScreenInfo.height - CGFloat(StatusBarAndNavigationBarH) - CGFloat(TabbarSafeBotM)), style:.plain)
        tableV.delegate = self
        tableV.dataSource = self
        //注册cell
        tableV.register(AdapCell.self, forCellReuseIdentifier: "cell")

        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableV.estimatedRowHeight = 100
        // 设置 tabelView 行高,自动计算行高
        tableV.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableV)

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
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
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
extension AdapcellVC{
    func setUpUI(){
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar!)
        onAdd()
    }
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //设置导航栏标题
        navigationItem.title = "Tableview自适应"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(AdapcellVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}
//数据源方法
extension AdapcellVC:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
