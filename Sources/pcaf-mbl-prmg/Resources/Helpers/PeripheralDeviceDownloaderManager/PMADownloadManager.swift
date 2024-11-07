//
//  PMADownloadManager.swift
//  PMADownloadManager
//

import UIKit
import UserNotifications

class PMADownloadManager: NSObject {
    
    public typealias DownloadCompletionBlock = (_ error : Error?, _ fileUrl:URL?) -> Void
    public typealias DownloadProgressBlock = (_ progress : CGFloat) -> Void
    public typealias BackgroundDownloadCompletionHandler = () -> Void
    
    // MARK: - Properties
    private var session: URLSession!
    private var ongoingDownloads: [String : PMADownloadObject] = [:]
    private var backgroundSession: URLSession!
    public var backgroundCompletionHandler: BackgroundDownloadCompletionHandler?
    public var showLocalNotificationOnBackgroundDownloadDone = true
    public var localNotificationText: String?
    public static let shared: PMADownloadManager = { return PMADownloadManager() }()

    //MARK: - User defined public methods
    
    /// Download file from url
    /// - Parameters:
    ///   - request: URLRequest
    ///   - directory: Directory path
    ///   - fileName: File Name
    ///   - shouldDownloadInBackground: Is download backgroud supported
    ///   - progressBlock: Progress
    ///   - completionBlock: compeletion
    /// - Returns: String - File Path
    public func downloadFile(withRequest request: URLRequest,
                            inDirectory directory: String? = nil,
                            withName fileName: String? = nil,
                            shouldDownloadInBackground: Bool = false,
                            onProgress progressBlock:DownloadProgressBlock? = nil,
                            onCompletion completionBlock:@escaping DownloadCompletionBlock) -> String? {
        
        guard let url = request.url else {
            return nil
        }
        if let _ = self.ongoingDownloads[url.absoluteString] {
            return nil
        }
        var downloadTask: URLSessionDownloadTask
        if shouldDownloadInBackground {
            downloadTask = self.backgroundSession.downloadTask(with: request)
        } else{
            downloadTask = self.session.downloadTask(with: request)
        }
        let download = PMADownloadObject(downloadTask: downloadTask,
                                        progressBlock: progressBlock,
                                        completionBlock: completionBlock,
                                        fileName: fileName,
                                        directoryName: directory)

        let key = self.getDownloadKey(withUrl: url)
        self.ongoingDownloads[key] = download
        downloadTask.resume()
        return key;
    }
    
    
    /// Download key path
    /// - Parameter url: File url
    /// - Returns: String
    public func getDownloadKey(withUrl url: URL) -> String {
        return url.absoluteString
    }
    
    
    ///  Ongoing download process
    /// - Returns: Array of downlaod process
    public func currentDownloads() -> [String] {
        return Array(self.ongoingDownloads.keys)
    }
    
    
    /// Cancel all ongoing downloads
    public func cancelAllDownloads() {
        for (_, download) in self.ongoingDownloads {
            let downloadTask = download.downloadTask
            downloadTask.cancel()
        }
        self.ongoingDownloads.removeAll()
    }
    
    
    /// Cancel specific ongoing download
    /// - Parameter key: Download file key
    public func cancelDownload(forUniqueKey key:String?) {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.0
        if presence {
            if let download = downloadStatus.1 {
                download.downloadTask.cancel()
                self.ongoingDownloads.removeValue(forKey: key!)
            }
        }
    }
    
    
    /// Pause ongoing download process
    /// - Parameter key: Download file key
    public func pause(forUniqueKey key:String?) {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.0
        if presence {
            if let download = downloadStatus.1 {
                let downloadTask = download.downloadTask
                downloadTask.suspend()
            }}
    }
    
    
    /// Resume paused download
    /// - Parameter key: Download file key
    public func resume(forUniqueKey key:String?) {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.0
        if presence {
            if let download = downloadStatus.1 {
                let downloadTask = download.downloadTask
                downloadTask.resume()
            }}
    }
    
    
    /// Check is download process
    /// - Parameter key: Download file key
    /// - Returns: Result
    public func isDownloadInProgress(forKey key:String?) -> Bool {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        return downloadStatus.0
    }
    
    public func alterDownload(withKey key: String?,
                              onProgress progressBlock:DownloadProgressBlock?,
                              onCompletion completionBlock:@escaping DownloadCompletionBlock) {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.0
        if presence {
            if let download = downloadStatus.1 {
                download.progressBlock = progressBlock
                download.completionBlock = completionBlock
            }
        }
    }
    
    //MARK: - User defined Private methods
    
    private override init() {
        super.init()
        let sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier!)
        backgroundConfiguration.isDiscretionary = false
        backgroundConfiguration.sessionSendsLaunchEvents = true
        backgroundConfiguration.shouldUseExtendedBackgroundIdleMode = true
        self.backgroundSession = URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: OperationQueue())
    }

    private func isDownloadInProgress(forUniqueKey key:String?) -> (Bool, PMADownloadObject?) {
        guard let key = key else { return (false, nil) }
        for (uniqueKey, download) in self.ongoingDownloads {
            if key == uniqueKey {
                return (true, download)
            }
        }
        return (false, nil)
    }
    
    
    /// Present local notifiction on file download
    /// - Parameter text: Text message
    private func showLocalNotification(withText text:String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                PMLog.shared.logger?.log(.error, message: "Not authorized to schedule notification")
                return
            }
            let content = UNMutableNotificationContent()
            content.title = text
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                            repeats: false)
            let identifier = "FWDownloadManagerNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            notificationCenter.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    PMLog.shared.logger?.log(.error, message: "Could not schedule notification, error : \(error)")
                }
            })
        }
    }
}

// MARK: - Delegates Method for URL Session or Session doenalod

extension PMADownloadManager : URLSessionDelegate, URLSessionDownloadDelegate {
   
    public func urlSession(_ session: URLSession,
                             downloadTask: URLSessionDownloadTask,
                             didFinishDownloadingTo location: URL) {
        
        let key = (downloadTask.originalRequest?.url?.absoluteString)!
        if let download = self.ongoingDownloads[key]  {
            if let response = downloadTask.response {
                let statusCode = (response as! HTTPURLResponse).statusCode
                guard statusCode < 400 else {
                    let error = NSError(domain:"HttpError", code:statusCode, userInfo:[NSLocalizedDescriptionKey : HTTPURLResponse.localizedString(forStatusCode: statusCode)])
                    OperationQueue.main.addOperation({
                        download.completionBlock(error,nil)
                    })
                    return
                }
                let fileName = download.fileName ?? downloadTask.response?.suggestedFilename ?? (downloadTask.originalRequest?.url?.lastPathComponent)!
                let directoryName = download.directoryName
                let fileMovingResult = PMAFileUtils.moveFile(fromUrl: location, toDirectory: directoryName, withName: fileName)
                let didSucceed = fileMovingResult.0
                let error = fileMovingResult.1
                let finalFileUrl = fileMovingResult.2
                OperationQueue.main.addOperation({
                    (didSucceed ? download.completionBlock(nil,finalFileUrl) : download.completionBlock(error,nil))
                })
            }
        }
        self.ongoingDownloads.removeValue(forKey:key)
    }
    
    public func urlSession(_ session: URLSession,
                             downloadTask: URLSessionDownloadTask,
                             didWriteData bytesWritten: Int64,
                             totalBytesWritten: Int64,
                             totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else {
            PMLog.shared.logger?.log(.error, message: "Could not calculate progress as totalBytesExpectedToWrite is less than 0")
            return;
        }
        if let download = self.ongoingDownloads[(downloadTask.originalRequest?.url?.absoluteString)!],
            let progressBlock = download.progressBlock {
            let progress : CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
            OperationQueue.main.addOperation({
                progressBlock(progress)
            })
        }
    }
    
    public func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             didCompleteWithError error: Error?) {
        if let error = error {
            let downloadTask = task as! URLSessionDownloadTask
            let key = (downloadTask.originalRequest?.url?.absoluteString)!
            if let download = self.ongoingDownloads[key] {
                OperationQueue.main.addOperation({
                    download.completionBlock(error,nil)
                })
            }
            self.ongoingDownloads.removeValue(forKey:key)
        }
    }

    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            if downloadTasks.count == 0 {
                OperationQueue.main.addOperation({
                    if let completion = self.backgroundCompletionHandler {
                        completion()
                    }
                    if self.showLocalNotificationOnBackgroundDownloadDone {
                        var notificationText = "Download completed"
                        if let userNotificationText = self.localNotificationText {
                            notificationText = userNotificationText
                        }
                        self.showLocalNotification(withText: notificationText)
                    }
                    self.backgroundCompletionHandler = nil
                })
            }
        }
    }
}
