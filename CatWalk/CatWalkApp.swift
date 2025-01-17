//
//  CatWalkApp.swift
//  CatWalk
//
//  Created by  玉城 on 2024/9/26.
//

import SwiftUI

@main
struct CatWalkApp: App {
//    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
//            ContentView()
            Content1View()
//            NotificationDemoView()
//            Content12View()
        }
    }
}

//
//// App Delegate
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        print("checkConditionsAndNotify111")
//        // 注册后台任务
//        BackgroundTaskManager.shared.registerBackgroundTasks()
//        BackgroundTaskManager.shared.scheduleNextBackgroundTask()
//        return true
//    }
//     func applicationDidEnterBackground(_ application: UIApplication) {
//        print("应用程序进入后台")
//        BackgroundTaskManager.shared.scheduleNextBackgroundTask()
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("应用程序即将进入前台")
//    }
//}
