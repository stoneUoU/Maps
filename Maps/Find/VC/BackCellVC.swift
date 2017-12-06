//
//  BackCellVC.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class BackCellVC: UIViewController,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar:UINavigationBar?
    var tableV : UITableView?
    var muarr : NSMutableArray? = []
    var arr : NSArray? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white

        arr = [ ["name":"名", "titleView":"哈哈哈哈哈哈"],
                ["name":"名称2名称2名称2名称2", "titleView":"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"],
                ["name":"名称3", "titleView":"哈"],
                ["name":"66666666666666666", "titleView":"我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据我是测试数据"],
                ["name":"0000", "titleView":"我是测"]
        ];

        for dic in arr! {
            //创建模型类
            muarr?.add(StModel.init(dict: dic as! NSDictionary))
        }

        //创建tableview
        tableV=UITableView.init(frame: CGRect(x:0,y:CGFloat(StatusBarAndNavigationBarH),width:ScreenInfo.width,height:ScreenInfo.height - CGFloat(StatusBarAndNavigationBarH) - CGFloat(TabbarSafeBotM)), style:.plain)
        tableV?.delegate = self;
        tableV?.dataSource = self;
        tableV?.tableFooterView = UIView.init();
        tableV?.separatorStyle = .none;
        self.view.addSubview(tableV!);

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
extension BackCellVC{
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
        navigationItem.title = "下拉列表"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(BackCellVC.goBack))
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
extension BackCellVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (muarr?.count)!;
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableV?.register(BackCell.classForCoder(), forCellReuseIdentifier: "cell");
        let cell : BackCell = BackCell.init(style: .default, reuseIdentifier: "cell");
        cell.selectionStyle = .none;
        cell.tableview = tableV;
        cell.loadData(data: muarr?[indexPath.row] as! StModel);
        return cell;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let models = muarr?[indexPath.row] as! StModel!;
        return (models?.height)!;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }

}
