//
//  SettingVC.swift
//  Maps
//
//  Created by test on 2017/10/16.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class SettingVC: UIViewController,UIGestureRecognizerDelegate{
    var rightBtn:UIButton?
    //声明导航条
    var navigationBar:UINavigationBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        // Do any additional setup after loading the view.
        self.setQ()
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
        navigationBar?.barStyle  =  UIBarStyle.default
        navigationBar?.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        // 5.设置导航栏阴影图片
        //navigationBar?.shadowImage = UIImage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SettingVC{
    func setUpUI(){
        //self.buildNavigationItem()
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:20, width:ScreenInfo.width, height:44))
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
        //创建左边按钮
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:100, height:30)
        //button.backgroundColor = UIColor.cyan
        button.setImage(UIImage(named:"icon_fanhui_default"), for: .normal)
        button.imageView?.contentMode = .left
        button.addTarget(self, action: #selector(MineSubVC.goBack), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem(customView: button)
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -48;
        //设置导航栏标题
        navigationItem.title = "消息消息"
        navigationItem.leftBarButtonItems = [spacer,leftBarBtn]
        //取消iOS11返回按钮的bug
        if #available(iOS 11.0, *) {
            button.setTitle("\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp我我我我", for: .normal)
        }
        
        rightBtn = UIButton(frame: CGRect(x:0, y:0, width:36, height:24))
        rightBtn!.setTitle("消息", for: .normal)
        rightBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn!.setTitleColor(UIColor.colorWithCustom(242, g: 71, b: 30), for: .normal)
        //rightBtn!.addTarget(self, action: "toMessage", for: .touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem(customView: rightBtn!)
        self.navigationItem.rightBarButtonItem = rightItem
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //测试队列
    func setQ(){
//        let queue = Queue(queueName: "NetWorking", maxConcurrency: 1, maxRetries: 5, serializationProvider: NSUserDefaultsSerializer(), logProvider: ConsoleLogger(), completeClosure: taskComplete)
//        queue.addTaskCallback("Create") { (task) -> Void in
//            sleep(1)
//            print("finish create task")
//            task.complete(nil)
//        }
//        
//        queue.addTaskCallback("Delete") { (task) -> Void in
//            print("finish Delete task")
//            task.complete(NSError(domain: "dsfs", code: 22, userInfo: nil))
//        }
//        var taskNUmber = 0
//        if queue.hasUnfinishedTask() {
//            print("存在未完成任务")
//            queue.loadSerializeTaskToQueue()
//        } else {
//            print("不存在未完成任务")
//            taskNUmber = 100
//        }
//        
//        for _ in 0...taskNUmber {
//            let task = QueueTask(queue: queue, type: "Create", userInfo: nil, retries: 0)
//            let taskDelete = QueueTask(queue: queue, type: "Delete", userInfo: nil, retries: 0)
//            queue.addOperation(taskDelete)
//            queue.addOperation(task)
//        }
//        
//        queue.pause()
//        queue.start()
    }
//    func taskComplete(task: QueueTask, error: Error?) {
//        if let error = error {
//            print("failed \(error)")
//        } else {
//            print("successfully")
//        }
//    }
}
