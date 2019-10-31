//
//  ViewController.swift
//  downloadTest
//
//  Created by henry wong on 2019/10/30.
//  Copyright © 2019 henry wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var downloadLabel: UILabel = {
        let downloadLabel = UILabel(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 30))
        downloadLabel.textColor = UIColor.black
        downloadLabel.textAlignment = .center
        downloadLabel.font = UIFont.systemFont(ofSize: 14)
        return downloadLabel
    }()
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel(frame: CGRect(x: 0, y: 250, width: UIScreen.main.bounds.size.width, height: 200))
        infoLabel.textColor = UIColor.black
        infoLabel.textAlignment = .center
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.numberOfLines = 4
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        return infoLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        view.addSubview(self.downloadLabel)
        view.addSubview(self.infoLabel)
        self.downloadfiles()
    }
    
    
    func downloadfiles() {
        DownloadTool.shared.downloadFile(dlProgress: { (progress) in
            let total = String(format: "%.2f", (progress.fileTotalCount?.byteSwapped ?? 0)/1024/1024)
            let complete = String(format: "%.2f", (progress.fileCompletedCount?.byteSwapped ?? 0)/1024/1024)
            let completePersent = String(format: "%.0f", progress.fractionCompleted * 100.0)
//            print("总共的数据\(progress.fileTotalCount ?? 0),百分比\(progress.fractionCompleted * 100.0)完成的数据\(progress.fileCompletedCount ?? 0),")
            self.downloadLabel.text = "总共的数据\(total)M,百分比\(completePersent)%,完成的数据\(complete)M"
        }, success: { (filePath) in
            print("下载成功后的文件路径：\(filePath)")
//            self.infoLabel.text = "下载成功后的文件路径：\(filePath)"
            self.infoLabel.text = "文件解压中..."
            UnzipTool.shared.newUnzipFile(fromPath: filePath) { (isSuccess, resultInfo) in
                if(isSuccess) {
                    self.infoLabel.text = "解压成功了：\(resultInfo)"
                } else {
                    self.infoLabel.text = "解压失败了：\(resultInfo)"
                }
            }
            
        }) { (error) in
            print("下载失败了：\(error)")
            self.infoLabel.text = "下载失败了：\(error)"
        }
    }


}

