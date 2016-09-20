//
//  WZYHomeCollectionViewCell.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/15.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

import SDWebImage

class WZYHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var homeItem: WZYHomeItem? {
        
        didSet {
         
            guard let homeItem = homeItem else {
                return
            }
            
            let url = NSURL(string: homeItem.q_pic_url)
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "empty_picture"))
            
        }
        
    }
}
