//
//  LaunchController.swift
//  AppLaunchADExample
//
//  Created by 童星 on 2016/10/28.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit

class LaunchController: NSObject {

    public class func loadLaunchImage() -> UIImage {
        let viewSize = UIScreen.main.bounds.size
        var viewOrientation: String? = nil
        var launchImage: String? = nil
        
        
        if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait {
            viewOrientation = "Portrait"
        }else{
        
            viewOrientation = "Landscape"
        }
        
        let dic = (Bundle.main.infoDictionary)
        
        print(dic?.description)
        

        let imagesDict: [[String: Any]] = (Bundle.main.infoDictionary)?["UILaunchImages"] as! [[String : Any]]
        
        for dict in imagesDict {
            
            let imageSize: CGSize = CGSizeFromString(dict["UILaunchImageSize"] as! String)
            
            if __CGSizeEqualToSize(imageSize, viewSize) && viewOrientation == (dict["UILaunchImageOrientation"] as! String) {
                launchImage = (dict["UILaunchImageName"] as! String)
            }
        }
        
        return UIImage(named: launchImage!)!
        
    }
}
