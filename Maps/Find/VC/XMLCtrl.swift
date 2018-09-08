
import UIKit
class XMLCtrl: UIViewController,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar:UINavigationBar!
    var btnStart :UIButton!
    var btnStop :UIButton!
    var xmlM:[XmlModel] = [XmlModel]()
    var xmlS:[XmlStruct] = [XmlStruct]()
    var xmlText:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension XMLCtrl{
    func setUpUI(){
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar)
        onAdd()
        btnStart = UIButton()
        btnStart.setTitle("开始", for: .normal)
        btnStart.titleLabel?.textColor = .white
        btnStart.backgroundColor = UIColor.cyan
        btnStart.addTarget(self, action: #selector(btnStart(_:)), for:.touchUpInside)
        self.view.addSubview(btnStart)
        btnStart.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width/2)
            make.height.equalTo(40)
            make.left.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-StatusBarAndNavigationBarH)
        }

        btnStop = UIButton()
        btnStop.setTitle("结束", for: .normal)
        btnStop.titleLabel?.textColor = .white
        btnStop.backgroundColor = UIColor.cyan
        //btnStop.ignoreInterval = true
        btnStop.addTarget(self, action: #selector(btnStop(_:)), for:.touchUpInside)
        self.view.addSubview(btnStop)
        btnStop.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width/2 - 1)
            make.height.equalTo(40)
            make.left.equalTo(btnStart.snp.right).offset(1)
            make.bottom.equalTo(self.view.snp.bottom).offset(-StatusBarAndNavigationBarH)
        }
    }
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        let navigationItem = UINavigationItem()
        //设置导航栏标题
        navigationItem.title = "解析xml"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(BackCellVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    @objc func btnStart(_:UIButton){
        STLog("Start")
        testXML()
    }
    @objc func btnStop(_:UIButton){
        //testSortV()

        let SHE = TestOC()
        STLog(SHE)
        SHE.sayHello()
        SHE.sayWhat("I am Stone", andAge: "24")
        TestOC.sayHelloTwo()
        //STLog(SHE.nsStr)
    }

    func testXML() {
        //xml数据源
        var xmlData = "<Users><User id='666'><name>Stone</name><tel><mobile>15717914505</mobile><home>江西省南昌市红谷滩万达广场旁边的一小卖部点</home></tel></User></Users>";
        //获取xml文件路径
        //let file = Bundle.main.path(forResource: "users", ofType: "xml")
        //let url = URL(fileURLWithPath: file!)
        //获取xml文件内容
        //let xmlData = try! Data(contentsOf: url)
        let doc:GDataXMLDocument = try! GDataXMLDocument(data:xmlData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options : 0)
        //通过XPath方式获取Users节点下的所有User节点，在路径复杂时特别方便
        let users = try! doc.nodes(forXPath: "//User", namespaces:nil) as! [GDataXMLElement]
        var dict:Dictionary<String,Any> = [:]
        //var dictArr:[Dictionary<String,Any>] = [[:]]
        //dictArr = [["name":"DevZhang", "job":"iOSDev", "company":"VSTECS"],["name":"DevZhang", "job":"iOSDev", "company":"VSTECS"]]
        for user in users {
            //User节点的id属性
            let uid = user.attribute(forName: "id").stringValue()
            //获取name节点元素
            let nameElement = user.elements(forName: "name")[0] as! GDataXMLElement
            //获取元素的值
            let uname =  nameElement.stringValue()
            //获取tel子节点
            let telElement = user.elements(forName: "tel")[0] as! GDataXMLElement
            //获取tel节点下mobile和home节点
            let mobile = (telElement.elements(forName: "mobile")[0]
                as! GDataXMLElement).stringValue()
            let home = (telElement.elements(forName: "home")[0]
                as! GDataXMLElement).stringValue()
            //输出调试信息
            dict["uname"] = uname
            dict["uid"] = uid
            dict["mobile"] = mobile
            dict["home"] = home
            let datas = XmlModel(uid: "\(uid)",uname: "\(uname)",mobile: "\(mobile)",home: "\(home)");
            self.xmlM.append(datas)
            let structD = XmlStruct(uid: "\(uid)",uname: "\(uname)",mobile: "\(mobile)",home: "\(home)");
            self.xmlS.append(structD)
        }
        STLog(dict)
        let sortResult = dict.sorted {$0.0 < $1.0}
        var strMds = ""
        for i in 0 ..< sortResult.count{
            strMds = strMds + sortResult[i].key + "=" + String(describing: sortResult[i].value) + (i == sortResult.count-1 ? "" : "&")
        }
        STLog(strMds) //按字典排序key=value&格式拼接而成
        self.xmlText = "<Users><User id='\(sortResult[2].value)'><name>\(sortResult[3].value)</name><tel><mobile>\(sortResult[1].value)</mobile><home>\(sortResult[0].value)</home></tel></User></Users>"
        STLog(self.xmlText)
        STLog(self.xmlM[0].mobile)
        STLog(self.xmlM)
        STLog(self.xmlS)

        let weChatMs = "appid=wxd930ea5d5a258f4f&body=test&device_info=1000&mch_id=10000100&nonce_str=ibuaiVcKdpRxkhJA&key=192006250b4c09247ec02edce69f6a2d"
        STLog(weChatMs.MD5().uppercased())
        STLog(weChatMs.md5.uppercased())
        STLog(weChatMs.hmac(algorithm: .SHA256, key: "192006250b4c09247ec02edce69f6a2d").uppercased())
        STLog("林磊".MD5().uppercased())
        STLog("林磊".md5.md5.uppercased())
        STLog("林磊".MD5().MD5().MD5().uppercased())
    }


    func testWeXml(){
        var xmlData = "<xml><appid>wxd930ea5d5a258f4f</appid><mch_id>10000100</mch_id><device_info>1000</device_info><body>test</body><nonce_str>ibuaiVcKdpRxkhJA</nonce_str><sign>9A0A8659F005D6984697E2CA0A9CF3B7</sign></xml>";
        let doc:GDataXMLDocument = try! GDataXMLDocument(data:xmlData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options : 0)
        let xmls = try! doc.nodes(forXPath: "//xml", namespaces:nil) as! [GDataXMLElement]
        var dict:Dictionary<String,Any> = [:]
        for xml in xmls {
            //获取appid节点元素
            let appid = (xml.elements(forName: "appid")[0]
                as! GDataXMLElement).stringValue()
            //获取mch_id节点元素
            let mch_id = (xml.elements(forName: "mch_id")[0]
                as! GDataXMLElement).stringValue()
            //获取device_info节点元素
            let device_info = (xml.elements(forName: "device_info")[0]
                as! GDataXMLElement).stringValue()
            //获取body节点元素
            let body = (xml.elements(forName: "body")[0]
                as! GDataXMLElement).stringValue()
            //获取nonce_str节点元素
            let nonce_str = (xml.elements(forName: "nonce_str")[0]
                as! GDataXMLElement).stringValue()
            //获取sign节点元素
            let sign = (xml.elements(forName: "sign")[0]
                as! GDataXMLElement).stringValue()
            //输出调试信息
            dict["appid"] = appid
            dict["mch_id"] = mch_id
            dict["device_info"] = device_info
            dict["body"] = body
            dict["nonce_str"] = nonce_str
            dict["sign"] = sign
        }
        STLog(dict)
        let sortResult = dict.sorted {$0.0 < $1.0}
        var strMds = ""
        for i in 0 ..< sortResult.count{
            strMds = strMds + sortResult[i].key + "=" + String(describing: sortResult[i].value) + (i == sortResult.count-1 ? "" : "&")
        }
        STLog(strMds) //按字典排序key=value&格式拼接而成
    }

    func testSortV(){
        //testSort(sortObject: BubbleSort())
        testSort(sortObject: InsertSort())
//        testSort(sortObject: SimpleSelectionSort())
//        testSort(sortObject: ShellSort())
//        testSort(sortObject: HeapSort())
//        testSort(sortObject: MergingSort())
//        testSort(sortObject: QuickSort())
//        testSort(sortObject: RadixSort())
    }
    func testSort(sortObject: SortType) {
        let list: Array<Int> = [12, 1, 6, 3, 100, 5, 32, 51, 0, 37, 93]
        let sortList = sortObject.sort(items: list)
        STLog(sortList)
        STLog("\n\n\n\n")
    }


}
