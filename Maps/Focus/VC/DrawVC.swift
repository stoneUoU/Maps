//
//  DrawVC.swift
//  Maps
//
//  Created by test on 2017/11/10.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SnapKit
//添加约束
class DrawVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var strIndex:String!
    var navigationBar:UINavigationBar?
    override func viewDidLoad() {
        print(strIndex,"strIndex")
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false

        let model = BaseModel()
        model.avatar = "/static_file/uploads/10006/5d362cdec45e11e7a1076c0b849ba396.png"
        model.sex = "0"
        model.tel = "15717914505"
        model.nick_name = "不屑的小坦克"
        model.rest_day = "365"
        model.full_day = "0"
        model.user_integral = "0"

        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        path = path! + "/Model"
        let data = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(model, forKey: "model")
        archiver.finishEncoding()
        data.write(toFile: path!, atomically: true)

        let data1 = NSData(contentsOfFile: path!)
        let una = NSKeyedUnarchiver.init(forReadingWith: data1! as Data)
        let m = una.decodeObject(forKey: "model") as! BaseModel
        una.finishDecoding()
        print("-----------runtime-----")
        print(m.nick_name)
        print(m.tel)

        self.jkPro = "通过类别拓展的属性"
        //print(self.jkPro!)
        print("标记")

        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension DrawVC{
    func setUpUI(){
        //self.buildNavigationItem()
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:StatusBarH, width:ScreenInfo.width, height:NavigationBarH))
        navigationBar?.barTintColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
        self.view.addSubview(navigationBar!)

        let cgView = CGView()
        self.view.addSubview(cgView)
        cgView.snp.makeConstraints{ (make) in
            make.top.equalTo(120)
            make.left.equalTo(60)
            make.width.equalTo(160)
            make.height.equalTo(160)
        }

        let btnTest = UIButton()
        btnTest.setTitle("测试runTime", for: .normal)
        btnTest.setTitleColor(.red, for: .normal)
        //btnTest.cs_accpetEventInterval = 0.0
        //btnTest.cs_sendAction(action: #selector(self.toSetting(_:)), to: self, for: nil)
        self.view.addSubview(btnTest)
        btnTest.snp.makeConstraints{ (make) in
            make.top.equalTo(cgView.snp.bottom).offset(20)
            make.left.equalTo(60)
            make.width.equalTo(160)
            make.height.equalTo(160)
        }

//        let test1V = UIView()
//        test1V.backgroundColor = .cyan
//        self.view.addSubview(test1V)
//        test1V.snp.makeConstraints{ (make) in
//            make.top.equalTo(cgView.snp.bottom).offset(36)
//            make.left.equalTo(88)
//            make.width.equalTo(120)
//            make.height.equalTo(120)
//        }
//
//        let test2V = UIView()
//        test2V.backgroundColor = .red
//        self.view.addSubview(test2V)
//        test2V.snp.makeConstraints{ (make) in
//            make.top.equalTo(cgView.snp.bottom).offset(36)
//            make.left.equalTo(60)
//            make.width.equalTo(120)
//            make.height.equalTo(120)
//        }
        //self.view.bringSubview(toFront: test1V)

    }
    @objc func toSetting(_ tapGes :UITapGestureRecognizer){
        print("999999")
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //设置导航栏标题
        navigationItem.title = "画图画图"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(DrawVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}

extension DrawVC {
    // 平常写法[不推荐]
    var jkPro: String? {
        set {
            objc_setAssociatedObject(self, "key", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self, "key") as? String
        }
    }
}
class CGView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        //创建一个矩形，它的所有边都内缩3点
        let drawingRect = self.bounds.insetBy(dx: 3, dy: 3)

        //创建并设置路径
        let path = CGMutablePath()
        //绘制矩形
        //path.addRect(drawingRect)
        //path.addRoundedRect(in: drawingRect, cornerWidth: 10, cornerHeight: 10)
        //绘制正圆
        let minWidth = min(self.bounds.width, self.bounds.height)
        path.addEllipse(in: CGRect(x: 3, y: 3, width: minWidth-6, height: minWidth-6))
        //添加路径到图形上下文
        context.addPath(path)

        //设置笔触颜色
        context.setStrokeColor(UIColor.orange.cgColor)
        //设置笔触宽度
        context.setLineWidth(6)
        //设置填充颜色
        context.setFillColor(UIColor.cyan.cgColor)

        //绘制路径并填充
        context.drawPath(using: .fillStroke)


        //创建一个矩形，它的所有边都内缩3
//        let drawingRect = self.bounds.insetBy(dx: 3, dy: 3)
//        //创建并设置路径
//        let path = CGMutablePath()
//        //圆弧半径
//        let radius = min(drawingRect.width, drawingRect.height)/2
//        //圆弧中点
//        let center = CGPoint(x:drawingRect.midX, y:drawingRect.midY)
//        //绘制圆弧
//        path.addArc(center: center, radius: radius, startAngle: 0,
//                    endAngle: CGFloat.pi * 2, clockwise: false)
//
//        //添加路径到图形上下文
//        context.addPath(path)
//        //设置笔触颜色
//        context.setStrokeColor(UIColor.orange.cgColor)
//        //设置笔触宽度
//        context.setLineWidth(6)
//        //绘制路径
//        context.strokePath()
    }
}


