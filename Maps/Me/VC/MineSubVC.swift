//
//  MineSubVC.swift
//  Centers
//
//  Created by test on 2017/9/30.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import ActionButton
import SwiftyJSON
//利用代理传值
protocol PassValueDelegate:NSObjectProtocol {
    func passValue(passVals:String)
}
//类似于OC中的typedef
typealias sendValueClosure=(_ string:String)->Void
class MineSubVC: UIViewController,UIGestureRecognizerDelegate {
    var db:SQLiteDB!
    //声明一个闭包
    var testClosure:sendValueClosure?
    weak var delegate:PassValueDelegate?
    //声明导航条
    var navigationBar:UINavigationBar?
    //浮动按钮:
    var actionButton: ActionButton!
    var btnSub = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white

        //获取数据库实例
        db = SQLiteDB.shared
        //打开数据库
        _ = db.openDB()
        //如果表还不存在则创建表（其中uid为自增主键）
        let result = db.execute(sql: "create table if not exists t_user(uid integer primary key,uname varchar(20),mobile varchar(20))")

        initUser()
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
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
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
extension MineSubVC{
    //从SQLite加载数据
    func initUser() {
        let data = db.query(sql: "select * from t_user")
        for i in 0..<data.count {
            print(data[i]["uname"] as? String,"iiii")
            print(data[i]["mobile"] as? String,"0000")
        }
    }
    func setUpUI(){
        //self.buildNavigationItem()
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar!)
        onAdd()
        let firstBtn = UIButton()
        firstBtn.backgroundColor = UIColor.red
        firstBtn.setTitle("测试KeyChain", for: .normal)
        firstBtn.addTarget(self, action:#selector(toPush(btn:)),for: .touchUpInside)
        firstBtn.titleLabel?.textColor = UIColor.white
        self.view.addSubview(firstBtn)
        firstBtn.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(navigationBar!.snp.bottom).offset(50)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(40)
        }

        let refreshBtn = UIButton()
        refreshBtn.backgroundColor = UIColor.red
        refreshBtn.setTitle("更新数据库", for: .normal)
        refreshBtn.addTarget(self, action:#selector(toUpdate(btn:)),for: .touchUpInside)
        refreshBtn.titleLabel?.textColor = UIColor.white
        self.view.addSubview(refreshBtn)
        refreshBtn.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(firstBtn.snp.bottom).offset(24)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(40)
        }

        let delBtn = UIButton()
        delBtn.backgroundColor = UIColor.red
        delBtn.setTitle("删除数据库", for: .normal)
        delBtn.addTarget(self, action:#selector(toDel(btn:)),for: .touchUpInside)
        delBtn.titleLabel?.textColor = UIColor.white
        self.view.addSubview(delBtn)
        delBtn.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(refreshBtn.snp.bottom).offset(24)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(40)
        }

        btnSub = UILabel()
        btnSub.textColor = UIColor.colorWithCustom(242,g:72,b:28)
        btnSub.font=UIFont.UiBoldFontSize(size: 18)
        btnSub.textAlignment = .center
        self.view.addSubview(btnSub);
        btnSub.snp_makeConstraints { (make) in
            make.top.equalTo(firstBtn.snp.bottom).offset(36)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 30))
        }
        
        let twitterImage = UIImage(named: "pop_Message.png")!
        let plusImage = UIImage(named: "pop_Task.png")!
        let safeImage = UIImage(named: "pop_2FA.png")!
        let projectImage = UIImage(named: "pop_Project.png")!
        let tweetImage = UIImage(named: "pop_Tweet.png")!
        let userImage = UIImage(named: "pop_User.png")!

        let twitter = ActionButtonItem(title: "Twitter", image: twitterImage)
        twitter.action = { item in print("Twitter...") }

        let google = ActionButtonItem(title: "Google Plus", image: plusImage)
        google.action = { item in print("Google Plus...") }
        
        let faceBook = ActionButtonItem(title: "FaceBook", image: safeImage)
        faceBook.action = { item in print("faceBook...") }
        
        let wePhone = ActionButtonItem(title: "wePhone Plus", image: projectImage)
        wePhone.action = { item in print("wePhone Plus...") }
        
        let messager = ActionButtonItem(title: "Messager Plus", image: tweetImage)
        messager.action = { item in print("Messager Plus...") }
        
        let userBtn = ActionButtonItem(title: "UserBtn Plus", image: userImage)
        userBtn.action = { item in
            self.hidesBottomBarWhenPushed = true
            let sb = UIStoryboard(name: "Mine", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SbTest") as! SbTestVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

        actionButton = ActionButton(attachedToView: self.view, items: [twitter, google,faceBook, wePhone,messager, userBtn])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())

        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(MineSubVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            /**
             先判断闭包是否存在，然后再调用
             */
            if (self.testClosure != nil){
                self.testClosure!("回调传值")
            }
            //MARK: - 代理传值
            self.delegate?.passValue(passVals: "demoVals")
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func toPush(btn:UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            self.btnSub.text = "\(keychain.get("Developer")!)"
//            print(keychain.get("Developer"),"ooooooo")
//            print(JSON(data: keychain.getData("missNet")!),"ooooooo")
//            print(JSON(data: keychain.getData("missNet")!)["avatar"],"iiii")
//            if let jsonDatas = keychain.get("missNet")!.data(using: String.Encoding.utf8, allowLossyConversion: false){
//                let json = JSON(data: jsonDatas)
//                print(json,"ooooooo")
//            }
//            let pushV = PushVC()
//            self.hidesBottomBarWhenPushed = true
//            self.show(pushV as UIViewController, sender: pushV)
            //self.navigationController?.pushViewController(pushV , animated: true)
            //self.hidesBottomBarWhenPushed = false
            
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: PushVC())
            let sql = "insert into t_user(uname,mobile) values('stone','15717914505')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = self.db.execute(sql: sql)
            print(result)
        })
    }

    @objc func toUpdate(btn:UIButton) {

    }

    @objc func toDel(btn:UIButton) {
        let sql = "DELETE FROM t_user"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = self.db.execute(sql: sql)
        print(result)
    }
    
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    
}

