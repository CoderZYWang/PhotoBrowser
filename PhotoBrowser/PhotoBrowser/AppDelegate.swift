//
//  AppDelegate.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/15.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

// MARK:- 根据image计算放大之后的frame
func calculateBigFrameWithSmallImage(smallImage: UIImage) -> CGRect {
    let screenW = UIScreen.mainScreen().bounds.width
    let screenH = UIScreen.mainScreen().bounds.height
    
    let bigImageW = screenW
    // 小图的宽高比 等于 大图的宽高比（根据此计算大图的H）
    let bigImageH = bigImageW * smallImage.size.height / smallImage.size.width
    let bigImageX: CGFloat = 0
    let bigImageY: CGFloat = (screenH - bigImageH) * 0.5
    
    return CGRect(x: bigImageX, y: bigImageY, width: bigImageW, height: bigImageH)
}

