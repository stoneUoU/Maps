//
//  TimerCountV.swift
//  Maps
//
//  Created by test on 2018/1/16.
//  Copyright © 2018年 com.youlu. All rights reserved.
//
import UIKit

class TimerCountV: UIView {

    private lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.text = "距离抢购结束"
        titleL.textAlignment = .center
        titleL.textColor = UIColor.red
        titleL.font = UIFont.systemFont(ofSize: 14.0)
        return titleL
    }()

    private lazy var hourLabel: UILabel = {
        let temp = UILabel()
        temp.layer.borderColor = self.timeBorderColor.cgColor
        temp.layer.borderWidth = self.timeBorderWidth
        temp.textColor = self.timeColor
        temp.textAlignment = .center
        temp.text = "00"
        return temp
    }()

    private lazy var minLabel: UILabel = {
        let temp = UILabel()
        temp.layer.borderColor = self.timeBorderColor.cgColor
        temp.layer.borderWidth = self.timeBorderWidth
        temp.textColor = self.timeColor
        temp.textAlignment = .center
        temp.text = "00"
        return temp
    }()

    private lazy var secondLabel: UILabel = {
        let temp = UILabel()
        temp.layer.borderColor = self.timeBorderColor.cgColor
        temp.layer.borderWidth = self.timeBorderWidth
        temp.textColor = self.timeColor
        temp.textAlignment = .center
        temp.text = "00"
        return temp
    }()

    private lazy var colonLabel: UILabel = {
        let temp = UILabel()
        temp.text = ":"
        temp.textColor = self.timeBorderColor
        temp.textAlignment = .center
        return temp
    }()
    private lazy var colonLabel2: UILabel = {
        let temp = UILabel()
        temp.text = ":"
        temp.textColor = self.timeBorderColor
        temp.textAlignment = .center
        return temp
    }()

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }

    var timeBorderColor: UIColor = UIColor.black
    var timeBorderWidth: CGFloat = 1.0

    var timeColor: UIColor = UIColor.black

    var timeFont: CGFloat?

    /// 开始时间 现在距离开始时间的时间戳
    //    var dateNum: Date? = Date(timeIntervalSinceNow: 0)
    var timeInterval: Double = 24 * 60 * 60 {
        didSet {

        }
    }

    lazy var timer: Timer? = {
        let temp = Timer(timeInterval: 1, target: self, selector: #selector(self.timeChange(time:)), userInfo: nil, repeats: true)
        RunLoop.current.add(temp, forMode: .commonModes)
        return temp
    }()

    var timeOverBlock: ((_ countDownView: TimerCountV) -> ())?

    init(frame: CGRect, timeInterval: Double?, timeOverBlock: ((_ countDownView: TimerCountV) -> ())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
        self.timeOverBlock = timeOverBlock
        if let temp = timeInterval {
            self.timeInterval = temp
        }
        setup()
    }


    private func setup() {
        // 标题
        addSubview(self.titleLabel)
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 3)

        // 时分秒的label
        addLabels()

        timer?.fire()

    }

    private func addLabels() {

        // 时
        addSubview(hourLabel)

        // 第一个分割
        addSubview(colonLabel)

        // 分
        addSubview(minLabel)

        // 第二个分割
        addSubview(colonLabel2)

        // 秒
        addSubview(secondLabel)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let tempHeight = frame.height / 3 * 2 - 10

        //        let tempHeight = frame.height > 55 ? frame.height / 3 * 2 - 10 : CGFloat(55 / 3 * 2 - 10)
        let tempWidth = frame.width / 4

        //        let perLabelWidth: CGFloat = 25
        //        let height: CGFloat = 25

        let perLabelWidth = tempWidth > tempHeight ? tempHeight : tempWidth
        let height = perLabelWidth
        let spaceWidth = (frame.width - 3 * perLabelWidth) / 4

        hourLabel.frame = CGRect(x: spaceWidth, y: titleLabel.frame.maxY + 5, width: perLabelWidth, height: height)
        colonLabel.frame = CGRect(x: hourLabel.frame.maxX, y: hourLabel.frame.minY, width: spaceWidth, height: height)
        minLabel.frame = CGRect(x: colonLabel.frame.maxX, y: colonLabel.frame.minY, width: perLabelWidth, height: height)
        colonLabel2.frame = CGRect(x: minLabel.frame.maxX, y: minLabel.frame.minY, width: spaceWidth, height: height)
        secondLabel.frame = CGRect(x: colonLabel2.frame.maxX, y: colonLabel2.frame.minY, width: perLabelWidth, height: height)

    }


    @objc private func timeChange(time: Timer) {
        print("\(timeInterval)")

        calculateTime(timeInter: timeInterval)

        timeInterval -= 1

        if timeInterval < 0 {
            timer?.invalidate()
            guard self.timeOverBlock != nil else { return }
            self.timeOverBlock!(self)
        }

    }

    private func calculateTime(timeInter: Double) {

        let second = Int(timeInter)
        let min: Int = 1 * 60
        let hour: Int = min * 60

        let hourT = second / hour
        let minT = (second - hourT * hour) / min
        let secondT = (second - hourT * hour - minT * min)

        secondLabel.text = String(format: "%02d", secondT)
        minLabel.text = String(format: "%02d", minT)
        hourLabel.text = String(format: "%02d", hourT)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
