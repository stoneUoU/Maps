//
//  SortVC.swift
//  Maps
//
//  Created by test on 2018/1/11.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
let  sortH = 40
class SortVC: BaseToolVC {
    var whichFlag = Int()
    var shareView:STSortView!
    var renqiView:STSortView!
    var totalV = UIView()
    var pSort = UIButton()
    var xSort = UIButton()
    var rSort = UIButton()


    //var  countV = 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUp(centerVals: "筛选", rightVals: "")
        self.setUpUI()
        // Do any additional setup after loading the view.

        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(SortVC.handleTap(sender:))))


        shareView = STSortView.init(frame: CGRect(x:0, y:-120, width:UIScreen.main.bounds.width, height:120))
        shareView.backgroundColor = UIColor.lightGray
        shareView.addItem(title: "销量最高")
        shareView.addItem(title: "销量适中")
        shareView.addItem(title: "销量最低")
        shareView._delegate = self


        renqiView = STSortView.init(frame: CGRect(x:0, y:-80, width:UIScreen.main.bounds.width, height:80))
        renqiView.backgroundColor = UIColor.lightGray
        renqiView.addItem(title: "人气最高")
        renqiView.addItem(title: "人气适中")
        renqiView._delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CustomTabBarVC.hideBar(animated: true);
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
extension SortVC:STSortViewDelegate{
    func shareBtnClick(index: Int) {
        switch self.whichFlag {
        case 0:
            STLog("价格排序，\(index)")
        default:
            STLog("人气排序，\(index)")
        }
        STLog(index)
    }
    func setUpUI(){
        totalV.backgroundColor = .cyan
        totalV.isUserInteractionEnabled = true
//        let subGes = UITapGestureRecognizer(target: self, action: #selector(self.subJump(_:)))
//        totalV.addGestureRecognizer(subGes)
        self.view.addSubview(totalV)
        totalV.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(sortH)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.left.equalTo(self.view)
        }
        pSort.frame = CGRect.zero
        pSort.setTitle("价格排序", for: .normal)
        pSort.setTitleColor(.white, for: .normal)
        pSort.backgroundColor = UIColor.red
        pSort.tag = 0
        pSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(pSort)
        pSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }

        xSort.frame = CGRect.zero
        xSort.setTitle("销量排序", for: .normal)
        xSort.setTitleColor(.white, for: .normal)
        xSort.backgroundColor = UIColor.cyan
        xSort.tag = 1
        xSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(xSort)
        xSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(pSort.snp.right).offset(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }

        rSort.frame = CGRect.zero
        rSort.setTitle("人气排序", for: .normal)
        rSort.setTitleColor(.white, for: .normal)
        rSort.backgroundColor = UIColor.green
        rSort.tag = 2
        rSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(rSort)
        rSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(xSort.snp.right).offset(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }
    }
    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
//            renqiView.hidden()
//            shareView.hidden()
        }
        sender.cancelsTouchesInView = false
    }
    func click(btn:UIButton){
        switch btn.tag {
        case 0:
            self.whichFlag = 0

            shareView.show()
        case 1:
            STLog("价格排序")
        default:
            self.whichFlag = 1

            //renqiView.show()
            let sheetView = SmileActionSheet(title: "SmileLive", cancelButtonTitle: "取消", buttonTitles: ["1", "2", "3"])
            sheetView.show()

        }
    }
//    @objc func subJump(_ tapGes :UITapGestureRecognizer){
//        shareView.show()
//    }
}
