//
//  WZYCollectionViewFlowLayout.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/15.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

class WZYCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        super.prepareLayout()
        
        // 常量属性值的计算
        let margin: CGFloat = 10
        let cols: CGFloat = 3

        let itemWH = (UIScreen.mainScreen().bounds.width - (cols + 1) * margin) / cols
        
        // 设置流水布局的属性
        self.minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        itemSize = CGSizeMake(itemWH, itemWH)
        
        // 设置内边距（在当前方法中我们能拿到一个collectionView的对象）
        collectionView?.contentInset = UIEdgeInsetsMake(64 + 10, 10, 10, 10)
    }
    
}
