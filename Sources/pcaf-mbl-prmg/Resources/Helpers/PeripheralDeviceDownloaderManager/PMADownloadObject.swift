//
//  FWDownloadObject.swift
//  FWDownloadManager
//

import UIKit

class PMADownloadObject: NSObject {

    // MARK: - Properties
    var completionBlock: PMADownloadManager.DownloadCompletionBlock
    var progressBlock: PMADownloadManager.DownloadProgressBlock?
    let downloadTask: URLSessionDownloadTask
    let directoryName: String?
    let fileName:String?
    
    init(downloadTask: URLSessionDownloadTask,
         progressBlock: PMADownloadManager.DownloadProgressBlock?,
         completionBlock: @escaping PMADownloadManager.DownloadCompletionBlock,
         fileName: String?,
         directoryName: String?) {
        self.downloadTask = downloadTask
        self.completionBlock = completionBlock
        self.progressBlock = progressBlock
        self.fileName = fileName
        self.directoryName = directoryName
    }
}
