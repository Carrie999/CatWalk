//
//  notificationView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/10/17.
//

import SwiftUI


#Preview {
    NotificationDemoView()
}

import SwiftUI
import UserNotifications
//import BackgroundTasks

// 通知管理器
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var isPermissionGranted = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // 请求通知权限
    //    func requestPermission() {
    //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
    //            DispatchQueue.main.async {
    //                self.isPermissionGranted = granted
    //                if granted {
    //                    print("通知权限已授予")
    //                } else {
    //                    print("通知权限被拒绝")
    //                }
    //            }
    //            
    //            if let error = error {
    //                print("请求权限错误: \(error)")
    //            }
    //        }
    //    }
    //    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
                
                if let error = error {
                    print("请求权限错误: \(error)")
                    completion(false)
                    return
                }
                
                if granted {
                    print("通知权限已授予")
                    completion(true) // 返回结果，表示权限已授予
                } else {
                    print("通知权限被拒绝")
                    completion(false) // 返回结果，表示权限被拒绝
                }
            }
        }
    }
    
    // 检查通知权限状态
    func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // 发送立即通知
    func sendImmediateNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // 发送定时通知
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // 发送每日定时通知
    func scheduleDailyNotification(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyNotification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // 取消所有通知
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 处理前台通知
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 在前台也显示通知
        completionHandler([.banner, .sound, .badge])
    }
}
//
//// 后台任务管理器
//class BackgroundTaskManager {
//    static let shared = BackgroundTaskManager()
//    
//    func registerBackgroundTasks() {
//        BGTaskScheduler.shared.register(
//            forTaskWithIdentifier: "siantgirl.com.CatWalk",
//            using: nil
//        ) {
//            task in
//            self.handleBackgroundTask(task as! BGAppRefreshTask)
//        }
//         print("后台任务注册完成")
//    }
//    
//    private func handleBackgroundTask(_ task: BGAppRefreshTask) {
//
//
//         print("开始处理后台任务")
//        task.expirationHandler = {
//            print("后台任务即将过期")
//            task.setTaskCompleted(success: false)
//        }
//        
//        checkConditionsAndNotify()
//        scheduleNextBackgroundTask()
//        
//        print("后台任务处理完成")
//        task.setTaskCompleted(success: true)
//
//        // // 确保任务在到期前完成
//        // task.expirationHandler = {
//        //     task.setTaskCompleted(success: false)
//        // }
//        // print("checkConditionsAndNotify222")
//        // // 执行后台检查
//        // checkConditionsAndNotify()
//        
//        // // 安排下一次后台任务
//        // scheduleNextBackgroundTask()
//        
//        // // 标记任务完成
//        // task.setTaskCompleted(success: true)
//    }
//    
////    func checkConditionsAndNotify() {
////        // 在这里添加你的条件检查逻辑
////        // 例如：检查数据、时间等条件
//////        if shouldSendNotification() {
////            NotificationManager.shared.sendImmediateNotification(
////                title: "条件满足",
////                body: "您设置的条件已经满足！"
////            )
//////        }
////    }
//    func checkConditionsAndNotify() {
//        let currentDate = Date()
//        let currentHour = Calendar.current.component(.hour, from: currentDate)
//        let currentMinute = Calendar.current.component(.minute, from: currentDate)
//        print("checkConditionsAndNotify 被调用，当前时间：\(currentHour):\(currentMinute)")
//        
//        // 始终发送通知，用于测试
//        NotificationManager.shared.sendImmediateNotification(
//            title: "后台任务执行",
//            body: "当前时间：\(currentHour):\(currentMinute)"
//        )
//        // 获取当前时间的小时和分钟
////         let currentHour = Calendar.current.component(.hour, from: Date())
////         let currentMinute = Calendar.current.component(.minute, from: Date())
////         print("checkConditionsAndNotify")
////         // 判断是否是19点20分
//// //        if currentHour == 21 && currentMinute == 05 {
////             print("truecheckConditionsAndNotify")
////             // 如果是19:20，发送通知
////             NotificationManager.shared.sendImmediateNotification(
////                 title: "条件满足",
////                 body: "现在是19:21，您设置的条件已经满足！"
////             )
//// //        }
//       
//    }
//    
//    private func shouldSendNotification() -> Bool {
//        // 在这里实现你的具体条件判断逻辑
//        // 返回 true 表示满足发送通知的条件
//        return false
//    }
//    
//    func scheduleNextBackgroundTask() {
//        let request = BGAppRefreshTaskRequest(identifier: "siantgirl.com.CatWalk")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // 15分钟后
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//            print("后台任务已安排")
//        } catch {
//            print("无法安排后台任务: \(error)")
//        }
//    }
//}

// 示例视图
struct NotificationDemoView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
        }
        .hidden() 
        .frame(height: 0)
        .onAppear {
            notificationManager.checkPermission()
            // 在页面加载时偷偷执行每日通知的调度
            
            notificationManager.scheduleDailyNotification(
                title: NSLocalizedString("notification_title", comment: "notification_title"),
                body: NSLocalizedString("notification_content", comment: "notification_content"),
                hour: 19,
                minute: 00
            )
            
        }
        
        
        
        
    }
}
