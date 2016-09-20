//
//  WZYHTTPTools.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/15.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

import AFNetworking

enum WZYRequestMethod {
    case GET
    case POST
}

class WZYHTTPTools: AFHTTPSessionManager {

    static let shareSessionManager: WZYHTTPTools = {
        let tools = WZYHTTPTools()
        
        // 往Set里面插入数据的特有方式
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tools
    }()
    
}

extension WZYHTTPTools {
    
    // 请求数据操作（GET/ POST）
    func request(method: WZYRequestMethod, urlString: String, parameters: [String: AnyObject], progress: (progressResult: NSProgress?) -> (), success: (successResult: AnyObject?)  -> (), error: (errorResult: NSError?) -> ()) {
        
        // 进度回调闭包
        let progressCallback = { (progressData: NSProgress) in
            progress(progressResult: progressData)
        }
        
        // 成功结果回调闭包
        let successCallback = { (task: NSURLSessionDataTask, successData: AnyObject?) in
            success(successResult: successData)
        }
        
        // 失败错误信息回调闭包   
        let failureCallback = { (task: NSURLSessionDataTask?, errorData: NSError) in
            error(errorResult: errorData)
        }
        
        if method == .GET {
            GET(urlString, parameters: parameters, progress: progressCallback, success: successCallback, failure: failureCallback)
        
        } else {
            POST(urlString, parameters: parameters, progress: progressCallback, success: successCallback, failure: failureCallback)
        }
    }
    
    // 下载操作
    func download(urlString: String, progress: (progressResult: NSProgress?) -> (), destination: (targetPath: NSURL?, response: NSURLResponse?) -> (NSURL), completionHandler: (response: NSURLResponse?, filePath: NSURL?, errorResult: NSError?) -> ()) {

        let request = NSURLRequest(URL: NSURL(string: urlString)!)

        // 进度回调闭包
        let progressCallback = { (progressData: NSProgress) in
            progress(progressResult: progressData)
        }
        
        // URL处理结果回调
        /*
         targetPath: 文件下载到沙盒中的临时路径
         response: 响应头信息
 */
        let destinationCallback = { (targetPath: NSURL, responseData: NSURLResponse) -> NSURL in
            destination(targetPath: targetPath, response: responseData)
        }
        
        // 下载完成之后的回调
        /*
         filePath: 文件保存的最终位置（全路径）
 */
        let completionHandlerCallback = { (response: NSURLResponse?, filePath: NSURL?, errorData: NSError?) in
            completionHandler(response: response, filePath: filePath, errorResult: errorData)
        }
        
        downloadTaskWithRequest(request, progress: progressCallback, destination: destinationCallback, completionHandler:completionHandlerCallback)
    }
    
    func upload() {
        
//        uploadTaskWithRequest(<#T##request: NSURLRequest##NSURLRequest#>, fromFile: <#T##NSURL#>, progress: <#T##((NSProgress) -> Void)?##((NSProgress) -> Void)?##(NSProgress) -> Void#>, completionHandler: <#T##((NSURLResponse, AnyObject?, NSError?) -> Void)?##((NSURLResponse, AnyObject?, NSError?) -> Void)?##(NSURLResponse, AnyObject?, NSError?) -> Void#>)
    }
}
