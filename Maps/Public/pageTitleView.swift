//
//  PageTitleView.swift
//  DYTV
//
//  Created by idea on 2017/8/4.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit

//MARK: - 定义协议
//写Class是为类协议只能被类遵守
// 屏幕的宽度和高度
protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView : PageTitleView,selectedIndex index : Int)
}
//默认情况下文字的颜色
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (0,0,0)
//选中后的颜色
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (108,135,244)
//MARK: - 定义常量
private let kScrollLineH:CGFloat = 2
//MARK: - 定义类
class PageTitleView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //MARK: -定义属性
    var currentINdex:Int = 0

    var titles :[String]
    //    设置属性遵守协议
    weak var delegate : PageTitleViewDelegate?

    //MARK: -懒加载属性
    lazy var titleLables: [UILabel] = [UILabel]()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //        设置不超过范围
        scrollView.bounces = false
        return scrollView
    }()

    lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        return scrollLine
    }()

    //MARK: -自定义构造函数
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: - 设置UI界面
extension PageTitleView{
    func setupUI(){
        //1.   添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds

        //2.     添加title对应的label
        setupTitleLabels()
        //3.       设置底部的线条和滚动的滑块

        setupBottonMenuAndScrollLine()
    }

    private func setupTitleLabels(){
        //        确定label的一些frame的值
        let labelW:CGFloat = frame.width/CGFloat(titles.count)
        let labelH:CGFloat = frame.height - kScrollLineH
        let labelY:CGFloat = 0
        for (index, title) in titles.enumerated() {
            // 1.            创建UIlable
            let  label = UILabel()
            // 2.           设置label的属性
            label.text = title
            label.tag = index
            //            文字大小
            label.font = UIFont.systemFont(ofSize: 14.0)
            //            文字颜色
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            //3.            设置label的frame---->才能使其显示出来
            setupBottonMenuAndScrollLine()

            let labelX:CGFloat = labelW * CGFloat(index)

            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.             将lable添加到scrollView中
            scrollView.addSubview(label)
            titleLables.append(label)

            // 5.           给label添加手势
            //            将label用户交互设为true
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }

    private func setupBottonMenuAndScrollLine(){
        //       1. 添加底线
        let buttonLine = UIView()
        buttonLine.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5

        buttonLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        scrollView.addSubview(buttonLine)
        //       2. 添加scrollLine
        //        获取第一个label
        guard let firstLabel = titleLables.first else{ return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        scrollView.addSubview(scrollLine)

        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }


}
//MARK: - 监听label的点击
extension PageTitleView{
    @objc func titleLabelClick(_ tapGes :UITapGestureRecognizer){
        //   1.     获取当前label
        guard let currentlabel = tapGes.view as? UILabel else {return}
        //        如果是重复点击同一个Title，那么直接返回
        if currentlabel.tag == currentINdex {return}
        //  2.      获取之前的label
        let oldlabel = titleLables[currentINdex]
        //3.        切换文字的颜色
        currentlabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldlabel.textColor =  UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        // 4.       保存最新label的下标值
        currentINdex = currentlabel.tag
        // 5.    滚动条位置发生改变
        let scrollLinex = CGFloat(currentINdex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLinex
        }
        // 6.       通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentINdex)
    }
}

//MARK: - 对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress: CGFloat,sourceIndex: Int , targetIndex : Int){
        //1. 取出 sourcelabel/targetlabel
        let sourceLabel = titleLables[sourceIndex]
        let targetlabel = titleLables[targetIndex]

        //2. 处理滑块逻辑
        let moveToatlX = targetlabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveToatlX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX

        //3. 颜色的渐变
        //        3.1 取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        //        变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        //        变化targetLabel
        targetlabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)

        //        4. 记录最新的index
        currentINdex = targetIndex
    }
}





