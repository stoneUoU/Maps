//
//  ScrollBtnsView.swift
//  Maps
//
//  Created by test on 2017/12/15.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
//class ScrollBtnsView: UIView ,UITableViewDelegate,UITableViewDataSource{
//    var clickBlock:((_ tag:Int)->())?  //点击cell的回调
//    var btnTitleArr:[String] = [] {   //按钮标题数据
//        didSet{
//            if btnTitleArr.count == 0 {
//                self.frame = .zero
//            }
//            var allLength:CGFloat = 0
//            for titleStr in btnTitleArr {
//                let curLength = self.getStrLength(str: titleStr as NSString)+60
//                lengthArr.append(curLength)
//                pointXArr.append(allLength)
//                allLength += curLength
//            }
//            viewLength = allLength
//        }
//    }
//    var tbView:UITableView! //横向滚动视图
//    var flagView:UIView!  //底部的标注线
//    var earlierFlag:Int = 0 //标注点击之前的cell
//    var lengthArr:[CGFloat] = []  //每个 cell 的宽度
//    var pointXArr:[CGFloat] = []  //每个 cell 的位置
//    var viewLength:CGFloat = 0{  //视图总宽度
//        didSet{
//            if viewLength<ScreenInfo.width{
//                //如果所有按钮的宽度小于屏幕宽度,按比例调整每个宽度
//                var newLengthArr:[CGFloat] = []
//                var newPonitXArr:[CGFloat] = []
//                var aLength:CGFloat = 0
//                for length in lengthArr {
//                    let newLength = (length*ScreenInfo.width)/viewLength
//                    newLengthArr.append(newLength)
//                    newPonitXArr.append(aLength)
//                    aLength += newLength
//                }
//                lengthArr = newLengthArr
//                pointXArr = newPonitXArr
//                viewLength = ScreenInfo.width
//            }
//        }
//    }
//    // MARK: - system method
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.setUp()
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setUp()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    // MARK: - private method
//    func setUp() {
//        //创建 tbview
//        tbView = UITableView.init(frame: CGRect(x:0, y:0, width:ScreenInfo.width, height:self.frame.height), style: .plain)
//        tbView.showsVerticalScrollIndicator = false
//        tbView.scrollsToTop = false
//        tbView.separatorStyle = .none
//        tbView.delegate = self
//        tbView.dataSource = self
//        //逆时针旋转90度
//        tbView.center = CGPoint(x:ScreenInfo.width/2.0, y:self.frame.height/2.0)
//        tbView.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)/2)
//        self.addSubview(tbView)
//        //创建 flagView
//        flagView = UIView.init(frame: CGRect(x:0, y:0, width:2, height:0))
//        flagView.backgroundColor = UIColor.red
//        tbView.addSubview(flagView)
//        //添加线
//        let lineView = UIView.init(frame: CGRect(x:0, y:self.frame.height-1, width:self.frame.width, height:1))
//        lineView.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
//        self.addSubview(lineView)
//    }
//    func getStrLength(str:NSString) -> CGFloat {
//        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15)]
//        let size = str.size(attributes: attributes)
//        return size.width
//    }
//    // MARK: - public method
//    func configBtnScrollView(titles:[String],block:@escaping ((_ tag:Int)->())) {
//        btnTitleArr = titles
//        clickBlock = block
//        flagView.frame = CGRect(x:0, y:0, width:2, height:lengthArr[0])
//        tbView.reloadData()
//    }
//    func upDataOldAndNewBtn(newRow:Int)  {
//        let newIndexPath = NSIndexPath(row: newRow, section: 0)
//        //修改文字颜色
//        let earlierCell:HorizontalLabelCell? = tbView.cellForRowAtIndexPath(NSIndexPath.init(forRow: earlierFlag, inSection: 0)) as! HorizontalLabelCell?
//        earlierCell?.cellLabel.textColor = UIColor.grayColor()
//        let curCell = tbView.cellForRowAtIndexPath(newIndexPath)  as! HorizontalLabelCell?
//        curCell?.cellLabel.textColor = UIColor.redColor()
//
//        //修改 flagView 的位置
//        let curY = pointXArr[newRow]
//        let curH = lengthArr[newRow]
//        UIView.animate(withDuration: 0.3, animations: {
//            self.flagView.frame = CGRect(x:0, y:curY, width:2,height:curH )
//        })
//        //重设 tableview 的偏移量
//        var offSet:CGFloat = 0
//        if (viewLength-curY)<ScreenInfo.width{
//            offSet = viewLength-ScreenInfo.width
//        }else if (curY + curH)>ScreenInfo.width {
//            offSet = curY + curH/2.0-ScreenInfo.width/2.0
//        }
//        UIView.animate(withDuration: 0.3) {
//            self.tbView.contentOffset = CGPoint(x:0, y:offSet)
//        }
//
//        //重设 earlierCell 标注
//        earlierFlag = newRow
//    }
//
//    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return btnTitleArr.count
//    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
//        return lengthArr[indexPath.row]
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellID = "HorizontalLabelCell"
//        var cell:HorizontalLabelCell? = tableView.dequeueReusableCellWithIdentifier(cellID) as! HorizontalLabelCell?
//        if cell == nil {
//            cell = HorizontalLabelCell.init(style: .Default, reuseIdentifier: cellID)
//        }
//        //设置选中风格
//        cell?.selectionStyle = .None
//        //顺时针旋转90度
//        cell?.transform =  CGAffineTransformMakeRotation(CGFloat(M_PI)/2)
//        cell?.cellLabel.text = btnTitleArr[indexPath.row]
//        //设置 label 的 frame
//        cell?.cellLabel.frame = CGRectMake(0, 0, lengthArr[indexPath.row], self.frame.height)
//        if indexPath.row == earlierFlag {
//            cell?.cellLabel.textColor = UIColor.redColor()
//        }else{
//            cell?.cellLabel.textColor = UIColor.grayColor()
//        }
//        return cell!
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        self.upDataOldAndNewBtn(newRow: indexPath.row)
//        //cell 点击回调
//        let tag = indexPath.row
//        if let clickBlock = clickBlock {
//            clickBlock(tag)
//        }
//    }
//}

