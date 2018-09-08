//
//  CellfolderVC.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class CellfolderVC: BaseToolVC{

    //分区数组:[标题]
    var sectionArray:NSMutableArray?
    //展开row的个数
    var rowCountArray:NSMutableArray?
    //保存section是否展开的标识符[0:表示收缩, 1:表示展开]
    var isOpenSectionArray:NSMutableArray?
    //创建tableView
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        //签订代理
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var fpCenterModels : [FpCenterModels]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp(centerVals: "cell折叠", rightVals: "")
        sectionArray = ["现场情况", "新加任务", "实际薪酬", "售后服务", "评价"]
        self.fpCenterModels = [Maps.FpCenterModels(person_address: "", company_num: "", tel: "", user_id: "10006", create_time: "2018-01-10 10:13:45", invoice_name: "O", type: "0", id: "123", email: ""), Maps.FpCenterModels(person_address: "", company_num: "Sad", tel: "", user_id: "10006", create_time: "2018-01-10 10:13:38", invoice_name: "Yuh", type: "1", id: "122", email: ""), Maps.FpCenterModels(person_address: "", company_num: "", tel: "", user_id: "10006", create_time: "2018-01-10 10:13:30", invoice_name: "Pour", type: "0", id: "121", email: ""), Maps.FpCenterModels(person_address: "", company_num: "", tel: "", user_id: "10006", create_time: "2018-01-10 10:13:24", invoice_name: "I", type: "0", id: "120", email: "")]
        //设置每个section下row的初始行数
        rowCountArray = ["3", "3", "3", "3", "1"]
        //设置每个section的初始状态 0为关闭状态, 1为展开状态
        isOpenSectionArray = ["0", "0", "0", "0", "0"]

        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FpCenterGRTableCells.self, forCellReuseIdentifier: "FpCenterGRCells")

        tableView.frame = CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - StatusBarAndNavigationBarH - TabbarSafeBotM)
        self.view.addSubview(tableView)
        tableView.reloadData()
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
//扩展 实现代理和数据源方法
extension CellfolderVC: UITableViewDelegate, UITableViewDataSource {

    // 分()个区
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray!.count
    }

    // 分()行/区
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //根据isOpenSectionArray的标识符 判断section是否是展开状态
        //true: 返回rowCountArray里存放的个数
        if (isOpenSectionArray!.object(at: section) as AnyObject).isEqual("1") {
            return (rowCountArray!.object(at: section) as AnyObject).integerValue
        }
        return 0
    }

    //设置每head的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    //设置每row的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 65
    }

    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        //cell.textLabel?.text = rowCountArray?.object(at: indexPath.section) as? String
        let datas: FpCenterModels = self.fpCenterModels![indexPath.row] as FpCenterModels
        let cell=tableView.dequeueReusableCell(withIdentifier: "FpCenterGRCells", for: indexPath as IndexPath) as! FpCenterGRTableCells
        //除去选中时的颜色
        cell.backgroundColor = UIColor.colorWithCustom(241, g: 243, b: 246,alpha: 1)
        cell.selectionStyle = .none
        cell.name.text = "\(datas.invoice_name)"
        cell.icon_img.image = UIImage(named: "img_fapiao_gongsi.png")
        cell.backgroundColor = UIColor.colorWithCustom(243, g: 245, b: 248,alpha: 1)
        return cell
    }
    //设置head的内容 -> UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        view.backgroundColor = .cyan

        let button = UIButton()
        button.tag = 100 + section
        button.addTarget(self, action: #selector(CellfolderVC.conversionClick(btn:)), for: .touchUpInside)
        if (isOpenSectionArray!.object(at: section) as AnyObject).isEqual("0"){
            button.setTitle("展开", for: .normal)
        }else{
            button.setTitle("收起", for: .normal)
        }
        view.addSubview(button)
        button.snp.makeConstraints{(make) in
            make.right.equalTo(view.snp.right).offset(0)
            make.centerY.equalTo(view)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

        let label = UILabel()
        label.text = sectionArray?.object(at: section) as? String
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        label.snp.makeConstraints{(make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.centerY.equalTo(view)
            make.width.equalTo(ScreenW/2)
            make.height.equalTo(40)
        }
        return view
    }
    //button 点击方法实现
    func conversionClick(btn: UIButton) {

        // 判断 标识符是否为0, 如果是把标识符转换成1,刷新TableView; else 再转换成0, 刷新TableView
        if (isOpenSectionArray!.object(at: btn.tag - 100) as AnyObject).isEqual("0") {
            isOpenSectionArray?.replaceObject(at: btn.tag - 100, with: "1")
            tableView.reloadSections(NSIndexSet(index: btn.tag - 100) as IndexSet, with: UITableViewRowAnimation.fade)
        } else {
            isOpenSectionArray?.replaceObject(at: btn.tag - 100, with: "0")
            tableView.reloadSections(NSIndexSet(index: btn.tag - 100) as IndexSet, with: UITableViewRowAnimation.fade)
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        STLog("\(indexPath.row)         \(indexPath.section)")
    }


}
