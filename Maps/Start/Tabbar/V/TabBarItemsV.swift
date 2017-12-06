//
//  TabBarItemsV.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit


protocol TabBarItemsVDelegate: NSObjectProtocol {
    
    func didSelectItemAtIndex(view: TabBarItemsV, index: Int) -> Void
    func didClickCenterItem(view: TabBarItemsV) -> Void
}

class TabBarItemsV: UIView {
    
    var selectedIndex = 0
    weak var delegate: TabBarItemsVDelegate?
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var btns = [CenterBtn]()
    let titles = ["发现","关注","","消息","我的"]
    let images = ["icon_tab_shouye_default","icon_tab_guaguatiandi_default","中间","icon_tab_shoucaizhongxin_default","icon_tab_wode_default"]
    let selectedImages = ["icon_tab_shouye_selected","icon_tab_guaguatiandi_selected","中间","icon_tab_shoucaizhongxin_selected","icon_tab_wode_selected"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        for index in 0..<titles.count {
            
            //定义正常及选中状态下的字体颜色
            let normalColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            let selectedColor = UIColor.red
            
            //准备按钮需要的图及标题
            let image = UIImage(named: images[index])
            let selImage = UIImage(named: selectedImages[index])
            let title = titles[index]
            
            let btn = CenterBtn()
            btn.setImage(image, for: .normal)
            btn.setImage(selImage, for: .selected)
            
            btn.setTitle(title, for: .normal)
            btn.setTitle(title, for: .selected)
            
            btn.setTitleColor(normalColor, for: .normal)
            btn.setTitleColor(selectedColor, for: .selected)
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(tabBarItemClicked(sender:)), for: .touchUpInside)
            
            if index == 0 {
                selectedIndex = 0
                btn.isSelected = true
            }
            
            btns.append(btn)
            self.addSubview(btn)
            
        }
    }
    
    /// 按钮响应方法
    ///
    /// - Parameter sender: 按钮对象
    @objc func tabBarItemClicked(sender: UIButton) {
        
        let tempIndex = sender.tag - 100
        if tempIndex == btns.count / 2 {
            delegate?.didClickCenterItem(view: self)
            return
        }
        if tempIndex != selectedIndex {
            
            let oldBtn = btns[selectedIndex]
            let newBtn = sender
            
            oldBtn.isSelected = false
            newBtn.isSelected = true
            
            selectedIndex = tempIndex
            if delegate != nil {
                
                switch selectedIndex {
                case 0:
                    delegate?.didSelectItemAtIndex(view: self, index: 0)
                case 1:
                    delegate?.didSelectItemAtIndex(view: self, index: 1)
                case 2:
                    delegate?.didSelectItemAtIndex(view: self, index: 2)
                case 3:
                    delegate?.didSelectItemAtIndex(view: self, index: 3)
                case 4:
                    delegate?.didSelectItemAtIndex(view: self, index: 4)
                default:
                    break
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerIndex = titles.count / 2
        let centerSize = CGSize(width: 64, height: 64)
        let normalBtnWith = Double(screenWidth - centerSize.width) / Double(btns.count - 1)
        
        for index in 0..<btns.count {
            
            let btn = btns[index]
            
            var xFrom = 0.0
            var yFrom = 0.0
            var btnWidth = 0.0
            var btnHeight = 49.0
            
            //左边
            if index < centerIndex {
                xFrom = Double(index) * normalBtnWith
                btnWidth = normalBtnWith
            }

            //右边
            if index > centerIndex {
                xFrom = Double(index - 1) * Double(normalBtnWith) + Double(centerSize.width)
                btnWidth = normalBtnWith
            }
        
            //中间
            if index == centerIndex {

                xFrom = Double(index) * normalBtnWith
                yFrom = btnHeight - Double(centerSize.height)
                btnWidth = Double(centerSize.width)
                btnHeight = Double(centerSize.height)
            }
        
            btn.frame = CGRect(x: xFrom, y: yFrom, width: btnWidth, height: btnHeight)
        }
    }
    
    
}
