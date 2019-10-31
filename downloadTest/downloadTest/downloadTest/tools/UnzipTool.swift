//
//  UnzipTool.swift
//  downloadTest
//
//  Created by henry wong on 2019/10/31.
//  Copyright © 2019 henry wong. All rights reserved.
//

import Foundation
//import ZIPFoundation
//import SSZipArchive

class UnzipTool: NSObject {
    
    static let shared = UnzipTool()
    
    //解压的最终文件夹html
    func getHtmlDirectryPath() -> String {
//        //文档目录
//        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
//        //缓存目录
//        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
//        //临时目录
//        let tempPath = NSTemporaryDirectory() as NSString
        if let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last {
            return documentPath + "/html"
        } else {
            return ""
        }
        
    }
    //每次要先删除再解压
    func handleFilePath(path: String, fileHandleResult: @escaping(_ isSuccess: Bool, _ result: String) -> ()) {
        print("删除html 的路径：\(path)")
        let fileManager = FileManager()
        if (fileManager.fileExists(atPath: path)) {
            do {
                try fileManager.removeItem(atPath: path)
                fileHandleResult(true, "删除成功")
            } catch {
                print("删除html失败了")
                fileHandleResult(false, "删除失败")
            }
        }
        
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            fileHandleResult(true, "文件夹创建成功")
        } catch {
            print("创建文件失败了：\(path)")
            fileHandleResult(true, "文件夹创建失败")
        }
    }
    
    func newUnzipFile(fromPath: String, unzipResult: @escaping(_ isSuccess: Bool, _ result: String) -> ()) {
        
        let toPath = getHtmlDirectryPath()
        handleFilePath(path: toPath) { (isSuccess, resultInfo) in
            if(!isSuccess) {
                unzipResult(false, resultInfo)
                return
            }
        }
        
        SSZipArchive
        
        
//        let fileManager = FileManager()
//        do {
//            print("frompath:\(URL(fileURLWithPath: fromPath)),   topath:\(URL(fileURLWithPath: toPath))")
//            try fileManager.unzipItem(at: URL(fileURLWithPath: fromPath), to: URL(fileURLWithPath: toPath))
//            unzipResult(true, "解压成功")
//        } catch {
//            unzipResult(false, "Extraction of ZIP archive failed with error:\(error)")
//            print("Extraction of ZIP archive failed with error:\(error)")
//        }
        
    }
}
