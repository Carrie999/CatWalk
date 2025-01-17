//
//  DataView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/10/11.
//

import SwiftUI
import HealthKit
import Charts



struct StepsView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    
    func formatWeeklyStepsForChart(_ weeklySteps: [(date: Date, steps: Int)]) -> [(String, Int)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return weeklySteps.map { (dateFormatter.string(from: $0.date), $0.steps) }
    }
    /// <#Description#>
    var body: some View {
        VStack {
           
            if (healthKitManager.weeklySteps.count >= 0) {
                List {
                    Section("今日步数") {
                        HStack {
                            Text("今日")
                            Spacer()
                            Text("\(healthKitManager.todaySteps)")
                        }
                    }
                    
                    Section("最近一周每日步数🐈") {
                        
                        ForEach(healthKitManager.weeklySteps, id: \.date) { dailyStep in
                            HStack {
                                Text(formatDate(dailyStep.date, format: "EEEE"))
                                Spacer()
                                Text("\(dailyStep.steps)")
                            }
                        }
                        
                        
                        
                    }
                    
                    Section("本月周均步数🐈") {
                        ForEach(healthKitManager.monthlyWeeklyAverages.reversed(), id: \.weekStart) { weekAvg in
                            HStack {
                                Text("\(formatDate(weekAvg.weekStart, format: "MM/dd")) - \(formatDate(weekAvg.weekEnd, format: "MM/dd"))")
                                Spacer()
                                Text("\(Int(weekAvg.averageSteps)) 步/天")
                            }
                        }
                    }
                    
                    Section("今年月均步数🐈") {
                        ForEach(healthKitManager.yearlyMonthlyAverages.reversed(), id: \.month) { monthAvg in
                            HStack {
                                Text(formatDate(monthAvg.month, format: "MMMM"))
                                Spacer()
                                Text("\(Int(monthAvg.averageSteps)) 步/天")
                            }
                        }
                    }
                }
            } else {
                if (healthKitManager.isAuth == false){
                    Spacer().frame(height: 200)
                    Text("您未授权健康步数,请在设置授权")
                } else{
                    ProgressView("loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .frame(height: UIScreen.main.bounds.height - 400)
                }
                //               Spacer() // Pushes content down
                //                
              
                //               Spacer() // Pushes content up
            }
        }
        .onAppear {
            healthKitManager.requestAuthorization()
        }
    }
    
    private func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}



func mockWeeklyStepsData() -> [(date: Date, steps: Int)] {
    let calendar = Calendar.current
    let today = Date()
    let weekAgo = calendar.date(byAdding: .day, value: -6, to: today)!
    
    return (0...6).map { dayOffset in
        let date = calendar.date(byAdding: .day, value: dayOffset, to: weekAgo)!
        let steps = Int.random(in: 3000...12000)  // 随机生成3000到12000之间的步数
        return (date: date, steps: steps)
    }
}



class HealthKitManager: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isAuth: Bool = true
    private let healthStore = HKHealthStore()
    @Published var todaySteps: Int = 0
    @Published var weeklySteps: [(date: Date, steps: Int)] = []
    @Published var monthlyWeeklyAverages: [(weekStart: Date, weekEnd: Date, averageSteps: Double)] = []
    @Published var yearlyMonthlyAverages: [(month: Date, averageSteps: Double)] = []
    
    private func fetchStepCount(completion: @escaping (HKQuantity?, Error?) -> Void) {
        let healthStore = HKHealthStore()
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: nil, options: .cumulativeSum) { (_, result, error) in
            if let error = error {
                completion(nil, error)
            } else if let result = result, let quantity = result.sumQuantity() {
                completion(quantity, nil)
            } else {
                completion(nil, NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法读取步数数据"]))
            }
        }
        
        healthStore.execute(query)
    }
    
    
    func requestAuthorization() {

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        guard HKHealthStore.isHealthDataAvailable() else {

            print("HealthKit 在此设备上不可用")
            return
        }

        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
//                print("11111")
        
//                // 检查用户是否确实授权了步数数据的读取权限
//                 let authorizationStatus = healthStore.authorizationStatus(for: stepType)
//                 if authorizationStatus == .sharingAuthorized {
//                     print("22222")
//                     print("成功授权读取步数数据")
//                     DispatchQueue.main.async {
//                         self.isLoading = false
//                         self.isAuth = true
//                         self.fetchAllStepsData()
//                     }
//                 } else {
//                     print("3333")
//                     print("步数数据读取未授权")
//                     DispatchQueue.main.async {
//                         self.isLoading = false
//                         self.isAuth = false
//                     }
//                 }
                self.fetchStepCount { (stepCount, error) in
                       if let error = error {
//                           print("读取步数数据失败: \(error.localizedDescription)")
                           self.isLoading = false
                           self.isAuth = false
                       } else {
                           self.isLoading = false
                           self.isAuth = true
                           self.fetchAllStepsData()
//                           print("成功读取步数: \(String(describing: stepCount))")
                       }
                   }
        
                
                
        
                
            } else if let error = error {

                print("授权失败: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
        
    }
    
    
    func fetchAllStepsData() {
        //      print("fetchAllStepsData")
        let group = DispatchGroup()
        
        group.enter()
        fetchTodaySteps {
            group.leave()
        }
        
        
        
        
        fetchTodaySteps()
        fetchWeeklySteps()
        fetchMonthlyWeeklyAverages()
        fetchYearlyMonthlyAverages()
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    private func fetchTodaySteps() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        fetchStepsForDateRange(start: startOfDay, end: now) { steps in
            DispatchQueue.main.async {
                self.todaySteps = steps
            }
        }
    }
    
    private func fetchTodaySteps(completion: @escaping () -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        fetchStepsForDateRange(start: startOfDay, end: now) { steps in
            DispatchQueue.main.async {
                self.todaySteps = steps
                completion()
            }
        }
        
    }
    
    private func fetchWeeklySteps() {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
        
        var dailySteps: [(date: Date, steps: Int)] = []
        let group = DispatchGroup()
        
        for dayOffset in 0...6 {
            group.enter()
            let dayStart = calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            fetchStepsForDateRange(start: dayStart, end: dayEnd) { steps in
                dailySteps.append((date: dayStart, steps: steps))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.weeklySteps = dailySteps.sorted(by: { $0.date < $1.date })
        }
    }
    
    private func fetchMonthlyWeeklyAverages() {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(byAdding: .month, value: -1, to: now)!
        
        var weeklyAverages: [(weekStart: Date, weekEnd: Date, averageSteps: Double)] = []
        let group = DispatchGroup()
        
        for weekOffset in 0...3 {
            group.enter()
            let weekStart = calendar.date(byAdding: .day, value: weekOffset * 7, to: monthStart)!
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
            
            fetchDailyStepsForDateRange(start: weekStart, end: weekEnd) { dailySteps in
                let totalSteps = dailySteps.reduce(0) { $0 + $1 }
                let averageSteps = Double(totalSteps) / Double(dailySteps.count)
                weeklyAverages.append((weekStart: weekStart, weekEnd: weekEnd, averageSteps: averageSteps))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.monthlyWeeklyAverages = weeklyAverages.sorted(by: { $0.weekStart < $1.weekStart })
        }
    }
    
    private func fetchYearlyMonthlyAverages() {
        let calendar = Calendar.current
        let now = Date()
        let yearStart = calendar.date(byAdding: .year, value: -1, to: now)!
        
        var monthlyAverages: [(month: Date, averageSteps: Double)] = []
        let group = DispatchGroup()
        
        for monthOffset in 0...11 {
            group.enter()
            let monthStart = calendar.date(byAdding: .month, value: monthOffset, to: yearStart)!
            let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
            
            fetchDailyStepsForDateRange(start: monthStart, end: monthEnd) { dailySteps in
                let totalSteps = dailySteps.reduce(0) { $0 + $1 }
                let daysInMonth = calendar.dateComponents([.day], from: monthStart, to: monthEnd).day ?? 30
                let averageSteps = Double(totalSteps) / Double(daysInMonth)
                monthlyAverages.append((month: monthStart, averageSteps: averageSteps))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.yearlyMonthlyAverages = monthlyAverages.sorted(by: { $0.month < $1.month })
        }
    }
    
    private func fetchStepsForDateRange(start: Date, end: Date, completion: @escaping (Int) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKStatisticsQuery(quantityType: stepType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            completion(steps)
        }
        
        healthStore.execute(query)
    }
    
    private func fetchDailyStepsForDateRange(start: Date, end: Date, completion: @escaping ([Int]) -> Void) {
        let calendar = Calendar.current
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .stepCount)!,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: start,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            var dailySteps: [Int] = []
            
            results?.enumerateStatistics(from: start, to: end) { statistics, stop in
                let steps = Int(statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)
                dailySteps.append(steps)
            }
            
            completion(dailySteps)
        }
        
        healthStore.execute(query)
    }
}

struct DataView: View {
    let screenHeight = UIScreen.main.bounds.height

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var body: some View {
        
        
        
        ZStack{
            //            DataColor.hexToColor(hex:"#f2f2f7")
            //                .edgesIgnoringSafeArea(.all)
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer().frame(height: 60)
                
                HStack(alignment: .center,spacing:0){
                    //                    let adaptiveHeight = UIScreen.getAdaptiveHeight(defaultHeight: 60)
                    // 左边返回按钮区域
                    Spacer().frame(width: 15)
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .opacity(1)
                        .frame(width: 60, height: 60)
                        .background(DataColor.hexToColor(hex: "ffffff"))
                        .clipShape(Circle())
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    
                    // 中间用Spacer()填充
                    Spacer()
                    
                    // 居中的data图片
                    Image("data")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    
                    // 右边用Spacer()和一个宽度75的空视图来平衡左边的返回按钮
                    Spacer()
                    
                    
                    
                    NavigationLink(destination: AboutUIView()) {
                        Image(systemName: "gearshape.fill").font(.system(size: 20))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .opacity(1)
                            .frame(width: 60, height: 60)
                            .background(DataColor.hexToColor(hex: "ffffff"))
                            .clipShape(Circle())
                        }
                    Color.clear.frame(width: 15) // 75 = 15 + 60 (左边padding + 返回按钮宽度)
                    
                    
                    
                    
                    
                    
                    
                }.frame(height: screenHeight <= 667 ? CGFloat(20) : CGFloat(60))
                
                
                //                Text("Daily Step Counts").font(.title)
                
                Spacer().frame(height: 30)
                ProVersionView()
                StepsView()
                
                
                Spacer()
                
            }
            
            
            
            
            
        }.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        
        
    }
}

#Preview {
    DataView()
}

