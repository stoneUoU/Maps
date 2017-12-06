//
//  seg3VC.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SnapKit
class Seg3VC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var dateArray = NSArray()
    var markAreas = NSArray()
    //列数
    var columnsNum = 7
    // 时间Label
    lazy var timeLabel: UILabel = {
        let time = UILabel(frame: CGRect.zero)
        time.text = "xxxx年xx月"
        time.textAlignment = .center
        return time
    }()
    var myCollection: UICollectionView!
    lazy var lastButton: UIButton = {
        let last = UIButton(type: .system)
        last.setTitle("<", for: UIControlState())
        last.setTitleColor(UIColor.black, for: UIControlState())
        last.addTarget(self, action: #selector(lastAction), for: .touchUpInside)
        return last
    }()
    lazy var nextButton: UIButton = {
        let next = UIButton(type: .system)
        next.setTitle(">", for: UIControlState())
        next.setTitleColor(UIColor.black, for: UIControlState())
        next.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return next
    }()
    var date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIBuild()
        self.myCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        self.myCollection.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Seg3VC {

    func UIBuild() {
        dateArray = ["日","一","二","三","四","五","六"]
        markAreas = [1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0]
        self.view.addSubview(lastButton)
        self.view.addSubview(timeLabel)
        self.view.addSubview(nextButton)
        lastButton.snp.makeConstraints{
            (make) in
            make.width.equalTo(30)
            make.height.equalTo(40)
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
        timeLabel.snp.makeConstraints{
            (make) in
            make.height.equalTo(40)
            make.top.equalTo(10)
            make.left.equalTo(lastButton.snp.right).offset(10)
        }
        nextButton.snp.makeConstraints{
            (make) in
            make.height.equalTo(40)
            make.top.equalTo(10)
            make.left.equalTo(timeLabel.snp.right).offset(10)
        }
        let layout = UICollectionViewFlowLayout()
        //间隔
        let spacing:CGFloat = 0
        //水平间隔
        layout.minimumInteritemSpacing = spacing
        //垂直行间距
        layout.minimumLineSpacing = spacing

        //计算单元格的宽度
        let itemWidth = (ScreenInfo.width - 20 - spacing * CGFloat(columnsNum-1))
            / CGFloat(columnsNum)
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width:itemWidth, height:itemWidth)
        //let rect = CGRect(x: 10, y: , width: ScreenInfo.width, height: 400)
        myCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollection.backgroundColor = UIColor.white
        myCollection.dataSource = self
        myCollection.delegate = self
        self.view.addSubview(myCollection)
        myCollection.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width - 20)
            make.height.equalTo(360)
            make.top.equalTo(nextButton.snp.bottom)
            make.left.equalTo(10)
        }
        self.timeLabel.text = String(format: "%li年%.2ld月", self.year(self.date), self.month(self.date))
    }

    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dateArray.count
        default:
            return  columnsNum * 6
        }
    }

    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeekCollectionViewCell
            cell.timeLabel.text = dateArray[(indexPath as NSIndexPath).row] as? String
            cell.backgroundColor = .white
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! DateCollectionViewCell
            cell.backgroundColor = .white
            let days = self.daysInThisMonth(date)
            let week = self.firstWeekInThisMonth(date)
            var day = 0
            let index = (indexPath as NSIndexPath).row
            if index  % columnsNum == 0{
                cell.lineV.isHidden = false
            }else{
                cell.lineV.isHidden = true
            }
            let da = Date()
            let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: da)
            if index < week{
                cell.timeLabel.text = " "
            }else if index>(week+days) - 1{
                cell.timeLabel.text = " "
            }else{
                day = index - week + 1
                cell.timeLabel.text = String(day)
                let abc = String(format: "%li年%.2ld月", com.year!, com.month!)
                let prev = "\(self.year(date))\(self.month(date))"
                if  Int(prev.substring(to: prev.index(prev.startIndex, offsetBy: 4)) + (prev.substring(from: prev.index(prev.startIndex, offsetBy: 4)).count == 1 ? "0\(prev.substring(from: prev.index(prev.startIndex, offsetBy: 4)))" : prev.substring(from: prev.index(abc.startIndex, offsetBy: 4))))! < Int(String(format: "%li%.2ld", com.year!, com.month!))!{
                    cell.timeLabel.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.1)
                }else if Int(prev.substring(to: prev.index(prev.startIndex, offsetBy: 4)) + (prev.substring(from: prev.index(prev.startIndex, offsetBy: 4)).count == 1 ? "0\(prev.substring(from: prev.index(prev.startIndex, offsetBy: 4)))" : prev.substring(from: prev.index(abc.startIndex, offsetBy: 4))))! == Int(String(format: "%li%.2ld", com.year!, com.month!))!{
                    if self.timeLabel.text! == abc {
                        if cell.timeLabel.text == String(self.day(date)) {
                            cell.backgroundColor = UIColor.orange
                            cell.timeLabel.textColor = UIColor.black
                        } else if Int(cell.timeLabel.text!)! < Int(self.day(date)){
                            cell.timeLabel.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.1)
                        }else{
                            cell.backgroundColor = UIColor.white
                            cell.timeLabel.textColor = UIColor.black
                        }
                    } else {
                        cell.backgroundColor = UIColor.white
                    }
                }else{
                    cell.timeLabel.textColor = UIColor.black
                }
//                let keys = (indexPath as NSIndexPath).row - week
//                if markAreas[0] as! Int == 1{
//                    cell.backgroundColor = .red
//                }else{
//                    cell.backgroundColor = .cyan
//                }
            }
            return cell
        }
    }

    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        print(cell.timeLabel.text)
    }

}

extension Seg3VC {

    // 获取当前日期
    func day(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.day!
    }

    // 获取当前月
    func month(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.month!
    }

    // 获取当前年
    func year(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.year!
    }

    // 每个月1号对应的星期
    func firstWeekInThisMonth(_ date: Date) -> NSInteger {
        var calender = Calendar.current
        calender.firstWeekday = 1
        var com = (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        com.day = 1
        let firstDay = calender.date(from: com)
        let firstWeek = (calender as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: firstDay!)
        return firstWeek - 1
    }

    // 当前月份的天数
    func daysInThisMonth(_ date: Date) -> NSInteger {
        let days: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return days.length
    }

    // 上个月
    func lastMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        dateCom.month = -1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }

    // 下个月
    func nextMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        let abc = 1
        dateCom.month = +abc
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }

}

extension Seg3VC {
    func lastAction() {
        UIView.transition(with: self.myCollection, duration: 0.5, options: .transitionCurlDown, animations: {
            self.date = self.lastMonth(self.date)
            self.timeLabel.text = String(format: "%li年%.2ld月", self.year(self.date), self.month(self.date))
        }, completion: nil)
        self.myCollection.reloadData()
    }

    func nextAction() {
        UIView.transition(with: self.myCollection, duration: 0.5, options: .transitionCurlUp, animations: {
            self.date = self.nextMonth(self.date)
            self.timeLabel.text = String(format: "%li年%.2ld月", self.year(self.date), self.month(self.date))
        }, completion: nil)

        self.myCollection.reloadData()
    }
}

//import UIKit
//import FSCalendar
//class Seg3VC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
//    fileprivate let gregorian = Calendar(identifier: .gregorian)
//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
//
//    fileprivate weak var calendar: FSCalendar!
//    fileprivate weak var eventLabel: UILabel!
//
//    // MARK:- Life cycle
//
//    override func loadView() {
//
//        let view = UIView(frame: UIScreen.main.bounds)
//        view.backgroundColor = .white
//        self.view = view
//
//        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: height))
//        calendar.dataSource = self
//        calendar.delegate = self
//        calendar.allowsMultipleSelection = false
//        view.addSubview(calendar)
//        self.calendar = calendar
//        calendar.backgroundColor = .white
//        calendar.calendarHeaderView.backgroundColor = UIColor.white
//        calendar.calendarWeekdayView.backgroundColor = UIColor.white
//        calendar.appearance.eventSelectionColor = UIColor.orange
//        calendar.appearance.eventDefaultColor = .white
//        calendar.appearance.borderDefaultColor = .gray
//        //calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
//        calendar.appearance.headerDateFormat = "yyyy年MM月"
//        calendar.appearance.headerMinimumDissolvedAlpha = 0;
//        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
//        calendar.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let dates = [
//            self.gregorian.date(byAdding: .day, value: -1, to: Date()),
//            Date(),
//            self.gregorian.date(byAdding: .day, value: 1, to: Date())
//        ]
//        dates.forEach { (date) in
//            self.calendar.select(date, scrollToDate: false)
//        }
//        // For UITest
//        self.calendar.accessibilityIdentifier = "calendar"
//
//    }
//
//    // MARK:- FSCalendarDataSource
//
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//        return cell
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        return UIColor.white
//    }
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return 2
//    }
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        if self.gregorian.isDateInToday(date) {
//            return [UIColor.orange]
//        }
//        return [appearance.eventDefaultColor]
//    }
//    // MARK:- FSCalendarDelegate
//
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendar.frame.size.height = bounds.height
//        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
//    }
//
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}

