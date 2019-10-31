//
//  DownloadTool.swift
//  downloadTest
//
//  Created by henry wong on 2019/10/30.
//  Copyright © 2019 henry wong. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DownloadTool: NSObject {
    
    static let shared = DownloadTool()
    
    let destination: DownloadRequest.DownloadFileDestination = { _, response in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
        //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    func downloadFile(dlProgress:@escaping(_ downloadProgress: Progress) -> () ,success:@escaping(_ localFileUrl: String) -> () ,failure: @escaping(_ result: String) -> ()) {
        Alamofire.download("https://down.hoyi52.com/zesheng/static.zip", to: destination)
            .downloadProgress { (progress) in
                print(progress)
                dlProgress(progress)
        }
        .responseData { response in
            if let filePath = response.destinationURL?.path {
                print("下载完毕！！", filePath)
                success(filePath)
            } else {
                print("下载失败了")
                failure("下载失败了")
            }
        }
    }
}
