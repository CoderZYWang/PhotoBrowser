//
//  UIButton+Extension.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/18.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

extension UIButton {
    
    // 这是用类方法进行创建，但是类方法比较像OC的语法，在Swift中，我们还是用遍历构造方法去初始化控件
    class func createBtn(title: String, bgColor: UIColor, fontSize: CGFloat) -> UIButton {
        let btn = UIButton()
        
        btn.setTitle(title, forState: .Normal)
        btn.backgroundColor = bgColor
        btn.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
        return btn
    }
    
    /*
     在extension扩充构造函数,只能扩充 便利构造函数
     1> 必须在init前面加上convenience
     2> 必须在init方法中,调用self.init()
     */
    convenience init(title: String, bgColor: UIColor, fontSize: CGFloat) {
        self.init()

        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
