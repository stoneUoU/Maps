//
//  PayAlert.swift
//  Maps
//
//  Created by test on 2017/12/19.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit

class PayAlert: UIView,UITextFieldDelegate {

    var contentView:UIView?
    var completeBlock : (((String) -> Void)?)
    static var receAmount:String?
    static var ifMoneyDisplay:Bool?
    static var titleInfo:String?
    static var methodInfo:String?
    private var textField:UITextField!
    private var inputViewWidth:CGFloat!
    private var passCount:CGFloat!
    private var passheight:CGFloat!
    private var inputViewX:CGFloat!
    private var pwdCircleArr = [UILabel]()
    let ScreenW=UIScreen.main.bounds.size.width
    let ScreenH=UIScreen.main.bounds.size.height
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.passheight = 35
        self.passCount = 6
        self.inputViewWidth = 35 * passCount
        self.inputViewX = (240 - inputViewWidth) / 2.0

        contentView =  UIView(frame: CGRect(x:40,y:100,width:240,height:200))
        contentView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        contentView?.layer.cornerRadius = 5;
        contentView?.center.x = ScreenW / 2
        if  UIScreen.main.bounds.height > 568.0 {
            contentView?.center.y = ScreenH / 2
        }
        self.addSubview(contentView!)


        let btn:UIButton = UIButton(type: .custom)
        btn.frame = CGRect(x:0, y:0, width:46, height:46)
        btn .addTarget(self, action: #selector(PayAlert.close), for: .touchUpInside)
        btn .setTitle("╳", for: .normal)
        btn .setTitleColor(UIColor.black, for: .normal)
        contentView!.addSubview(btn)

        let titleLabel:UILabel = UILabel(frame: CGRect(x:0,y:0,width:contentView!.frame.size.width,height:46))
        titleLabel.text = PayAlert.titleInfo
        STLog(PayAlert.ifMoneyDisplay!)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView!.addSubview(titleLabel)

        let linView:UIView = UIView (frame: CGRect(x:0,y:46,width:contentView!.frame.size.width,height:1))
        linView.backgroundColor = UIColor.black
        linView.alpha = 1
        contentView?.addSubview(linView)

        let withMethod:UILabel = UILabel(frame: CGRect(x:0,y:56,width:contentView!.frame.size.width,height:24))
        withMethod.text = PayAlert.methodInfo
        withMethod.textAlignment = NSTextAlignment.center
        withMethod.font = UIFont.systemFont(ofSize: 14)
        if PayAlert.ifMoneyDisplay == true{
            contentView?.addSubview(withMethod)
        }

        let moneyLabel:UILabel = UILabel(frame: CGRect(x:0,y:72,width:contentView!.frame.size.width,height:48))
        moneyLabel.text = "需支付金额:"+PayAlert.receAmount!+"元";
        moneyLabel.textAlignment = NSTextAlignment.center
        moneyLabel.font = UIFont.systemFont(ofSize: 16)
        if PayAlert.ifMoneyDisplay == true{
            contentView?.addSubview(moneyLabel)
        }

        textField = UITextField(frame: CGRect(x:0,y:contentView!.frame.size.height - 54, width:contentView!.frame.size.width, height:35))
        textField.delegate = self
        textField.isHidden = true
        textField.keyboardType = UIKeyboardType.numberPad
        contentView?.addSubview(textField!)


        let inputView:UIView = UIView(frame: CGRect(x:self.inputViewX,y:contentView!.frame.size.height - 60,width:inputViewWidth, height:35))

        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor;
        contentView?.addSubview(inputView)

        let rect:CGRect = inputView.frame
        let x:CGFloat = rect.origin.x + (inputViewWidth / 12)
        let y:CGFloat = rect.origin.y + 35 / 2 - 5
        for i in 0  ..< 6 {
            let circleLabel:UILabel =  UILabel(frame: CGRect(x:x + 35 * CGFloat(i) ,y:y,width:10,height:10))
            circleLabel.backgroundColor = UIColor.black
            circleLabel.layer.cornerRadius = 5
            circleLabel.layer.masksToBounds = true
            circleLabel.isHidden = true
            contentView?.addSubview(circleLabel)
            pwdCircleArr.append(circleLabel)

            if i == 5 {
                continue
            }
            let line:UIView = UIView(frame: CGRect(x:rect.origin.x + (inputViewWidth / 6)*CGFloat(i + 1),y:rect.origin.y, width:1 ,height:35))
            line.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            line.alpha = 1
            contentView?.addSubview(line)
        }
        //忘记支付密码：
        let Fpbtn:UIButton = UIButton(type: .custom)
        Fpbtn.frame = CGRect(x:120, y:176, width:120, height:24)
        Fpbtn .addTarget(self, action: #selector(PayAlert.toFpay), for: .touchUpInside)
        Fpbtn .setTitle("忘记支付密码？", for: .normal)
        Fpbtn .setTitleColor(UIColor.black, for: .normal)
        Fpbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        Fpbtn.setTitleColor(UIColor.blue,for:.normal) //普通状态下文字的颜色
        if PayAlert.ifMoneyDisplay == true{
            contentView!.addSubview(Fpbtn)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(view:UIView){
        view.addSubview(self)
        contentView!.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        contentView!.alpha = 1;
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.textField.becomeFirstResponder()
            self.contentView!.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.contentView!.alpha = 1;

        }, completion: nil)

    }

    func close(){
        self.removeFromSuperview()
    }
    func toFpay() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            //通知点击忘记支付密码去修改支付密码界面
            let NotifyForCodeChange = NSNotification.Name(rawValue:"NotifyForCodeChange")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"NotifyForCodeChange"), object: nil, userInfo: ["success":"true"])
        })
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if((textField.text?.characters.count)! > 6){
            return false
        }

        var password : String
        if string.characters.count <= 0 {
            //let index = textField.text?.endIndex.advancedBy(-1)
            let index = textField.text?.index((textField.text?.endIndex)!, offsetBy: -1)
            password = textField.text!.substring(to:index!)
        }
        else {
            password = textField.text! + string
        }
        self .setCircleShow(count: password.characters.count)

        if(password.characters.count == 6){
            completeBlock?(password)
            close()
        }
        return true;
    }

    func setCircleShow(count:NSInteger){
        for circle in pwdCircleArr {
            circle.isHidden = true;
        }
        for i in 0 ..< count {
            pwdCircleArr[i].isHidden = false
        }
    }
}

