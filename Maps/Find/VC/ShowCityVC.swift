//
//  ShowCityVC.swift
//  Maps
//
//  Created by test on 2017/9/30.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import CoreLocation
//声明一个protocal，必须继承NSObjectProtocal
protocol ReturnValDelegate:NSObjectProtocol {
    func passValue(passVals:String)
}
class ShowCityVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var currentCityLabel:UILabel?
    var tableView:UITableView?
    var cities:NSDictionary?
    var keys:[String]?
    weak var delegate:ReturnValDelegate?
    lazy var locationM: CLLocationManager = {//info.plist add :Privacy - Location Always Usage Description
        let locationM = CLLocationManager()
        locationM.delegate = self
        return locationM
    }()
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    fileprivate func buildNavigationItem() {
        // 返回按钮
        let backButton = UIButton(type: .custom)
        // 给按钮设置返回箭头图片
        backButton.setBackgroundImage(UIImage(named: "icon_fanhui_default"), for: .normal)
        // 设置frame
        backButton.frame = CGRect(x: 200, y: 13, width: 6, height: 14)
        backButton.addTarget(self, action: #selector(ShowCityVC.goBack), for: .touchUpInside)
        // 自定义导航栏的UIBarButtonItem类型的按钮
        let backView = UIBarButtonItem(customView: backButton)
        // 返回按钮设置成功
        navigationItem.leftBarButtonItems = [ backView]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(CLLocationManager.authorizationStatus() != .denied) {
            print("应用拥有定位权限")
            locationM.startUpdatingLocation()
        }else {
            let aleat = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许xxx使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            aleat.addAction(tempAction)
            aleat.addAction(callAction)
            self.present(aleat, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationM.stopUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "选择城市"
        self.buildNavigationItem()
        loaddata()
        initUI()
    }
    func loaddata() {
        guard let pathW = Bundle.main.path(forResource: "citydict" as String, ofType: "plist") else {
            return
        }
        // resource not found, handle error
        cities = NSDictionary(contentsOfFile: pathW)
        let allkays = cities!.allKeys as NSArray
        let sortedStates = allkays.sortedArray(using: #selector(NSNumber.compare(_:)))
        keys = sortedStates as? Array<String>
    }
    
    private func initUI() {
        let headerLabel = UILabel(frame:  CGRect(x: 0, y: 64, width: ScreenInfo.width, height: 20))
        headerLabel.text = "    当前城市"
        headerLabel.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.addSubview(headerLabel)
        
        currentCityLabel = UILabel(frame:  CGRect(x: headerLabel.frame.origin.x, y: headerLabel.frame.origin.y+headerLabel.frame.size.height, width: headerLabel.frame.size.width, height: headerLabel.frame.size.height+10))
        currentCityLabel!.backgroundColor = UIColor.white
        currentCityLabel?.textColor = UIColor.orange
        currentCityLabel?.isUserInteractionEnabled = true
        view.addSubview(currentCityLabel!)
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(tapToChangeCity(sender:)))
        currentCityLabel?.addGestureRecognizer(tap)
        
        tableView = UITableView(frame: CGRect(x: (currentCityLabel?.frame.origin.x)!, y: (currentCityLabel?.frame.origin.y)!+(currentCityLabel?.frame.size.height)!, width: (currentCityLabel?.frame.size.width)!, height: (ScreenInfo.height-(currentCityLabel?.frame.size.height)!)-headerLabel.frame.size.height), style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
        
    }
    
    @objc func tapToChangeCity(sender:UITapGestureRecognizer){
        if((currentCityLabel?.text?.isEmpty) == nil){
            return
        }
        let city:String = ((currentCityLabel?.text)! as NSString).substring(from: 4)
        //MARK: - 代理传值
        self.delegate?.passValue(passVals: city)
        navigationController?.popViewController(animated: true)
        
    }
    
    //UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let lengths = keys else{return 0}
        return lengths.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let keys_:NSArray = NSArray(array: keys!);
        let key = keys_.object(at: section)
        
        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        return temp.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let keysTemp:NSArray = NSArray(array: keys!);
        
        let key = keysTemp.object(at: indexPath.section)
        
        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        
        cell.textLabel?.text = temp.object(at: indexPath.row) as? String
        return cell
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        
        
        headerLabel.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        let keys_:NSArray = NSArray(array: keys!);
        
        let key = keys_.object(at: section)
        let textString = "    "+(key as? String)!;
        headerLabel.text = textString
        return headerLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let keysTemp:NSArray = NSArray(array: keys!);
        let key = keysTemp.object(at: indexPath.section)
        
        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        //MARK: - 代理传值
        self.delegate?.passValue(passVals: temp.object(at: indexPath.row) as! String)
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ShowCityVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        if newLocation.horizontalAccuracy < 0 { return }
        geoCoder.reverseGeocodeLocation(newLocation) { (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                self.currentCityLabel?.text = "    \(pl.locality!)"
            }else{
                print(error,"error")
            }
        }
        manager.stopUpdatingLocation()
    }
}
