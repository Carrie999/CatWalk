////
////  dataAccessView.swift
////  CatWalk
////
////  Created by  玉城 on 2024/10/11.
////
//
//import SwiftUI
//import HealthKit
////
////struct DataAccessView: View {
////    var body: some View {
////        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
////    }
////}
////
////#Preview {
////    DataAccessView()
////}
//
//
//
//
//class HealthDataManager {
//    let healthStore = HKHealthStore()
//
//    // Fetch step count for a given time period (e.g., daily, weekly)
//    func fetchStepCount(for startDate: Date, to endDate: Date, completion: @escaping ([HKStatistics]) -> Void) {
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let calendar = Calendar.current
//        
//        var interval = DateComponents()
//        interval.day = 1  // Daily data
//        
////        •    每天步数：interval.day = 1
////        •    每周步数：interval.weekOfYear = 1
////        •    每月步数：interval.month = 1
////        •    每年步数：interval.year = 1
//      
//        let query = HKStatisticsCollectionQuery(
//            quantityType: stepType,
//            quantitySamplePredicate: nil,
//            options: .cumulativeSum,
//            anchorDate: startDate,
//            intervalComponents: interval)
//        
//        query.initialResultsHandler = { query, results, error in
//            if let statsCollection = results {
//                var steps: [HKStatistics] = []
//                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
//                    steps.append(statistics)
//                }
//                completion(steps)
//            } else {
//                completion([])
//            }
//        }
//        
//        healthStore.execute(query)
//    }
//    
//    func requestAuthorization(completion: @escaping (Bool) -> Void) {
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let dataTypes = Set([stepType])
//        
//        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { success, error in
//            completion(success)
//        }
//    }
//}
