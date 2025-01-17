//
//  ContentView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/9/26.
//

import SwiftUI
import AVFoundation
import Foundation
import HealthKit
import StoreKit


class AnimalManager {
    private let userDefaults = UserDefaults.standard
    private let existingAnimalsKey = "existingAnimals"
    
    var existingAnimals: [String] {
        get {
            return userDefaults.stringArray(forKey: existingAnimalsKey) ?? ["cat1"]
        }
        set {
            userDefaults.set(newValue, forKey: existingAnimalsKey)
        }
    }
    
}


struct AnimatedCatImage: View {
    let indexCat: String
    @Binding var showModal: Bool
    @State private var isAnimating = false
    let playSound: () -> Void
    
    var body: some View {
        // 使用 ZStack 来隔离动画效果
        ZStack {
            // 固定大小的容器
            //            Color.clear
            //                .frame(width: 340, height: 340)
            
            Image(indexCat)
                .resizable()
                .scaledToFit()
                .frame(width: 340)
            // 将动画效果限制在图片内
                .scaleEffect(x: isAnimating ? 1.04 : 1, y: isAnimating ? 1 : 1.02)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        // 将点击事件添加到容器上
        .onTapGesture {
            showModal = true
            playSound()
        }
        .onAppear {
            // 确保动画在视图完全加载后开始
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
    }
}

// 创建一个单独的动画图标组件
struct AnimatedPetIcon: View {
    let todayHaveCat: Bool
    let scale: CGFloat
    let onTapAction: () -> Void
    
    var body: some View {
        // 将图片包装在另一个不会被动画影响的容器中
        ZStack {
            Image(todayHaveCat ? "icon5" : "icon3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            // 只对图片本身应用缩放动画
                .scaleEffect(scale)
        }
        // 确保容器大小固定，不受动画影响
        .frame(width: 70, height: 70)
        .onTapGesture(perform: onTapAction)
    }
}

struct ContentView: View {
    @StateObject var storeKit = StoreKitManager()
    @StateObject private var healthKitManager = HealthKitManager()
    //  @State private var isAnimating = false // 添加状态变量来控制动画
    @State private var scale: CGFloat = 1.0
    @State private var isAnimating = false
    @State private var showModal = false
    @State private var showModal2 = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var indexCat = UserDefaults.standard.string(forKey: "indexCat") ?? "cat1"
    @State private var todayHaveCat: Bool = false
    @State var isPurchased: Bool = false
    @State var isPurchasedId: String? = ""
    @State private var purchasedStatus: [String: Bool] = [:] // Key: Product ID, Value: Purchased status
    @State private var anyProductPurchased: Bool = false
    
    let images = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", "cat15", "cat16", "cat17", "cat18", "cat19", "cat20", "cat21", "cat22", "cat23", "cat24", "cat25", "cat26", "cat27","cat28", "cat29", "cat30", "cat31", "cat32", "cat33"]
    
    let dogs = ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6", "dog7", "dog8", "dog9", "dog10", "dog11", "dog12", "dog13", "dog14", "dog15", "dog16", "dog17", "dog18"]
    let animals = ["animal1", "animal2", "animal3", "animal4", "animal5", "animal6", "animal7", "animal8", "animal9", "animal10", "animal11", "animal12", "animal13", "animal14", "animal15", "animal16", "animal17", "animal18", "animal19", "animal20", "animal21", "animal22"]
    
    private let userDefaults = UserDefaults.standard
    private let allPetsCollectedKey = "allPetsCollected"
    private let existingAnimalsKey = "existingAnimals"
    private let allPetsCollected: Bool = false
    @State private var randomAnimal2: String? = "cat1"
    
    @State private var isShowingGuide = true
    @State private var hasPet = false
    
    //    @State private var existingAnimals: [String] = []
    var animalManager = AnimalManager()
    //    animalManager.existingAnimals = (anyProductPurchased ? (images + dogs + animals).count : images.count)
    
    //    private func loadExistingAnimals() {
    //        existingAnimals = UserDefaults.standard.stringArray(forKey: existingAnimalsKey) ?? []
    //    }
    //
    //    private func saveExistingAnimals(_ randomAnimal: String) {
    //        existingAnimals.append(randomAnimal)
    //        UserDefaults.standard.set(existingAnimals, forKey: existingAnimalsKey)
    //    }
    
    
    
    //    // 重置每日状态，清空所有宠物
    //    func resetDailyState() {
    //        existingAnimals.removeAll()
    //        userDefaults.set([], forKey: existingAnimalsKey)
    //        allPetsCollected = false
    //    }
    func isCollectionComplete() -> Bool {
        let totalItems = anyProductPurchased ? (images.count + dogs.count + animals.count) : Array(images.prefix(18)).count
        //            animalManager.existingAnimals = []
        return animalManager.existingAnimals.count == totalItems
    }
    
    func getRandomAnimal() -> String? {
        //        print("1111getRandomAnimal")
        
        // 如果所有宠物都已经被收集，直接返回 nil
        if animalManager.existingAnimals.count == (anyProductPurchased ? (images + dogs + animals).count : images.count)  {
            return nil
        }
        
        var availableAnimals: [String]
        if anyProductPurchased {
            availableAnimals = images + dogs + animals
        } else {
            availableAnimals = Array(images.prefix(18))
        }
        
        availableAnimals = availableAnimals.filter { !animalManager.existingAnimals.contains($0) }
        
        // 如果没有可用的宠物了，更新状态并返回 nil
        if availableAnimals.isEmpty {
            print("所有宠物都已经获得了！")
            
            return nil
        }
        
        let randomAnimal = availableAnimals.randomElement()!
        
        animalManager.existingAnimals.append(randomAnimal)
        
        
        return randomAnimal
    }
    
    
    func setTodayHaveCat(_ value: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "todayHaveCat")
        defaults.set(Date(), forKey: "todayHaveCatDate")
        todayHaveCat = value
    }
    
    func checkTodayHaveCat() {
        let defaults = UserDefaults.standard
        if let savedDate = defaults.object(forKey: "todayHaveCatDate") as? Date {
            if Calendar.current.isDateInToday(savedDate) {
                todayHaveCat = defaults.bool(forKey: "todayHaveCat")
            } else {
                // 如果不是今天的日期，重置值
                todayHaveCat = false
                defaults.removeObject(forKey: "todayHaveCat")
                defaults.removeObject(forKey: "todayHaveCatDate")
            }
        } else {
            todayHaveCat = false
        }
    }
    // 每次更新 purchasedStatus 后调用此方法
    func updateAnyProductPurchased() {
        
        anyProductPurchased = purchasedStatus.values.contains(true)
        UserDefaults.standard.set(anyProductPurchased, forKey: "isPurchased")
    }
    
    // 播放音效的函数
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "meow", withExtension: "mp3") {
            //            print("音频文件路径：\(soundURL)")  // 输出文件路径调试
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
                                print("音频播放成功")
            } catch {
                                print("无法播放音频文件：\(error.localizedDescription)")
            }
        } else {
                        print("找不到音频文件")
        }
    }
    
    func playSound2() {
        if let soundURL = Bundle.main.url(forResource: "success", withExtension: "mp3") {
            //            print("音频文件路径：\(soundURL)")  // 输出文件路径调试
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
                //                print("音频播放成功")
            } catch {
                //                print("无法播放音频文件：\(error.localizedDescription)")
            }
        } else {
            //            print("找不到音频文件")
        }
    }
    
    func checkPurchases(product: Product) {
        //        print("checkPurchases111")
        Task {
            
            do {
                //                print("111checkPurchases")
                let purchased = try await storeKit.isPurchased(product)
                DispatchQueue.main.async {
                    UserDefaults.standard.set(purchased, forKey: product.id )
                    purchasedStatus[product.id] = purchased // 存储每个产品的购买状态
                    //                  print("11111\(product.id)+\(purchased)")
                    updateAnyProductPurchased()
                }
            } catch {
                //               print("checkPurchases1111111111111111111111111111")
                //               print("Failed2 to check purchase status for \(product.id) after delay: \(error)")
            }
        }
        
    }
    
    
    var body: some View {
        
        
        NavigationStack {
            
            ZStack {
                ZStack{
                    VStack {
                        // 使用 ForEach 显示产品列表
                        ForEach(storeKit.storeProducts) { product in
                            HStack {
                                
                            }.onAppear {
                                checkPurchases(product: product)
                            }
                        }
                        
                        NotificationDemoView()
                        
                        
                    }
                }.hidden()
                
                DataColor.hexToColor(hex:"#f8f8f8")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    HStack {
                        // 左边的圆形图片和文字、数据
                        VStack {
                            // Image(systemName: "pawprint.fill") // 你的图片
                            //     .resizable()
                            //     .scaledToFit()
                            //     .frame(width: 100, height: 100)
                            //     .clipShape(Circle()) // 圆形裁剪
                            //     .overlay(Circle().stroke(Color.blue, lineWidth: 4)) // 圆形边框
                            
                            NavigationLink(destination: DataView()) {
                                
                                Image("icon1") // 使用本地图片
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle()) // 圆形裁剪
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 0)) // 圆形边框
                                
                            }
                            
                            
                            
                            
                            
                            
                            Text("步数")
                                .font(.headline)
                                .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                                .padding(.top, -5)
                                .padding(.leading, 3)
                            
                            
                            //                            Text("1234 步") // 这里是步数数据
                            //                                .font(.subheadline)
                            //                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 40)
                        Spacer()
                        // 右边的圆形图片和文字、图鉴
                        VStack {
                            NavigationLink(destination: TujianView()) {
                                
                                Image("icon2") // 你的图片
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.green, lineWidth: 0))
                                
                            }
                            
                            Text("图鉴")
                                .font(.headline)
                                .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                                .padding(.top, -5)
                            
                            
                            
                            
                            
                            //
                            //                            Text("已解锁: 5/10") // 图鉴信息
                            //                                .font(.subheadline)
                            //                                .foregroundColor(.gray)
                        }
                    }.padding(.horizontal, 20)
                    
                    Spacer().frame(height: 60)
                    
                    //                    Text("\(anyProductPurchased ? "是Pro" : "不是Pro")")
                    //                    Image(indexCat) // 使用本地图片
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .frame(width: 340)
                    //                        .scaleEffect(x: isAnimating ? 1.04 : 1, y: isAnimating ? 1 : 1.02)
                    //                        .animation(
                    //                            Animation.easeInOut(duration: 1)
                    //                                .repeatForever(autoreverses: true),
                    //                            value: isAnimating
                    //                        ).onAppear{
                    //                            isAnimating = true
                    //                        }
                    //                         .onTapGesture {
                    //                            showModal = true
                    //                             playSound() // 点击时播放声音
                    //                        }
                    
                    AnimatedCatImage(
                        indexCat: indexCat,
                        showModal: $showModal,
                        playSound: {
                            playSound()
                            // 你的播放声音函数
                        }
                    )
                    
                    // .sheet(isPresented: $showModal) {
                    //     // ModalView(isPresented: $showModal)
                    
                    //     ModalView(isPresented: $showModal, modalHeight: UIScreen.main.bounds.height * 3/5) // 传递高度
                    //     .frame(width: UIScreen.main.bounds.width) // 设置全屏大小的背景
                    //     .background(Color.black.opacity(0.2))
                    //     .edgesIgnoringSafeArea(.all)
                    //     .transition(.move(edge: .bottom))
                    // }
                    
                    
                    
                    Spacer().frame(height: 40)
                    
                    Text("今天的步数🐈")
                        .font(.headline)
                        .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                    
                    Spacer().frame(height: 0)
                    
                    Text("\(healthKitManager.todaySteps)")
                         .font(.system(size: 86, weight: .bold))
                        .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
      
                    
//                    Text("2,279")
//                        .font(.system(size: 86, weight: .bold))
//                        .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                    
                    
                    Spacer().frame(height: 10)
                    
                    
                    Spacer()
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white) // 设置卡片颜色，这里用白色作为示例
                            .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5) // 添加阴影效果
                            .frame(height: 180) // 设置卡片高度，可以根据需要调整
                            .padding(.horizontal, 20) // 左右边距
                            .padding(.bottom, 0) // 底部边距
                        VStack{
                            Spacer().frame(height: 10)
                            
                            AnimatedPetIcon(
                                todayHaveCat: todayHaveCat,
                                scale: scale,
                                onTapAction: {
                                   if todayHaveCat {
                                       return
                                   }
                                    if healthKitManager.todaySteps >= 3000 {
                                    if !showModal2 {
                                        setTodayHaveCat(true)
                                        playSound2()
                                        randomAnimal2 = getRandomAnimal()
                                        showModal2 = true
                                        todayHaveCat = true
                                    }
                                    }
                                }
                            )
                            .onAppear {
                                // 使用 DispatchQueue 确保动画在视图完全加载后开始
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(
                                        Animation.easeInOut(duration: 0.7)
                                            .repeatForever(autoreverses: true)
                                    ) {
                                        scale = 1.05
                                    }
                                }
                            }
                            
                            //                            Image(todayHaveCat ? "icon5" :"icon3") // 使用本地图片
                            //                            .resizable()
                            //                            .aspectRatio(contentMode: .fit)
                            //                            .frame(width: 60, height: 60) // 设置图片尺寸
                            //                            .scaleEffect(scale) // 应用缩放效果
                            //                            .onAppear {
                            ////                                 当视图出现时启动动画
                            //                                withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                            //                                    scale = 1.05 // 设置缩放的最大值
                            //                                }
                            //                            }
                            ////                            .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: scale) // 仅对 scaleEffect 应用动画
                            ////                            .onAppear {
                            ////                                scale = 1.05 // 设置缩放的最大值
                            ////                            }
                            //
                            //                            .onTapGesture {
                            ////                                let remainingSteps = 3000 - healthKitManager.todaySteps
                            //
                            //                                if todayHaveCat {
                            //                                    return
                            //                                }
                            //                                if healthKitManager.todaySteps >= 3000 {
                            //
                            //                                    if !showModal2 {
                            //                                        setTodayHaveCat(true)
                            //                                        playSound2()
                            //                                        randomAnimal2 = getRandomAnimal()
                            //                                        showModal2 = true
                            //                                        todayHaveCat = true
                            //                                    }
                            //                                }
                            //
                            //
                            //                            }
                            
                            
                            
                            //                            Image("icon5") // 使用本地图片
                            //                            .resizable()
                            //                            .aspectRatio(contentMode: .fit)
                            //                            .frame(width: 60, height: 60) // 设置图片尺寸
                            
                            
                            Spacer().frame(height: 30)
                            
                            
                            //                            if healthKitManager.isLoading {
                            //                                           ProgressView("加载中...")
                            //                                       } else {
                            //                                           Text("今日步数: \(healthKitManager.todaySteps)")
                            //                                       }
                            
                            if todayHaveCat {
                                Text("今天已得到 🐱，明天再来吧～") .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                            } else{
                                if healthKitManager.todaySteps >= 3000 {
                                    
                                    Text("恭喜你得到一个新宠物 🎉")
                                        .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                                } else {
                                    let remainingSteps = 3000 - healthKitManager.todaySteps
                                    Text("还需要 \(remainingSteps) 步获得新的宠物 🐱")
                                    .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))                            }
                            }
                            
                            //
                            Spacer().frame(height: 20)
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                ZStack {
                    
                    // 添加一个全屏幕的透明视图来捕获点击事件
                    if showModal {
                        Color.black.opacity(0.001) // 几乎完全透明
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal = false
                            }
                    }
                    // 弹窗部分
                    if showModal {
                        ModalView(isPresented: $showModal, modalHeight: UIScreen.main.bounds.height * 3/5,
                          indexCat: $indexCat)
                            .frame(width: UIScreen.main.bounds.width * 1) // 弹窗宽度稍小于屏幕宽度
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5) // 添加阴影效果
                        
                            .transition(.move(edge: .bottom))
                            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: showModal)
                        
                    }
                }.animation(.easeInOut(duration: 0.5), value: showModal)
                
                
                
                ZStack {
                    
                    // 添加一个全屏幕的透明视图来捕获点击事件
                    if showModal2 {
                        Color.black.opacity(0.1) // 几乎完全透明
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal2 = false
                            }
                    }
                    // 弹窗部分
                    if showModal2 {
                        
                        ModalView2(isPresented: $showModal2, modalHeight: UIScreen.main.bounds.height * 0.78,
                                   isCollectionComplete: isCollectionComplete(),
                                   randomAnimal:  randomAnimal2) // 传递较小高度
                        
                        .frame(width: UIScreen.main.bounds.width * 1) // 弹窗宽度稍小于屏幕宽度
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5) // 添加阴影效果
                        
                        .transition(.move(edge: .bottom))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: showModal2)
                        
                    }
                }.animation(.easeInOut(duration: 0.5), value: showModal2)
                
                
                
                // 新手引导覆盖层
                if isShowingGuide {
                    OnboardingOverlay(isShowingGuide: $isShowingGuide, showModal2: $showModal2) {
                        // 完成引导后的回调
                        hasPet = true
                        // 这里可以添加其他逻辑，比如保存状态等
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    }
                }
            }.onAppear {
                isShowingGuide = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
                checkTodayHaveCat()
                healthKitManager.requestAuthorization()
                //                healthKitManager.requestAuthorization { success in
                //                    if success {
                //                        print("HealthKit 授权成功1111")
                //
                //                    } else {
                //
                //                        print("HealthKit 授权失败222222")
                //
                //                    }
                //                }
                //    loadExistingAnimals()
                //
            }
            //            .onChange(of: anyProductPurchased) { newValue in
            //                // 监听 anyProductPurchased 的变化，并同步到 AnimalManager
            //                animalManager.updateMembershipStatus(isPurchased: newValue)
            //            }
            //
            
            
        }
    }
}

#Preview {
    ContentView()
}

struct ModalView: View {
    @Binding var isPresented: Bool
    
    var modalHeight: CGFloat // 外部传入的高度
    @Binding var indexCat: String
    @State private var existingAnimals: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("关闭")
                                .foregroundColor(DataColor.hexToColor(hex: "#b5b5b5"))
                                .padding()
                            
                            
                        }
                        Spacer()
                    }
                    
                    
                    
                    Text("选择你的散步伙伴🐈")
                    
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(DataColor.hexToColor(hex: "#2a2a2a"))
                        .padding(.leading, 20) // 设置左边距离为 20
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Spacer().frame(height: 50)
                    
                    ScrollView(.horizontal, showsIndicators: false) { // 水平滚动，隐藏滚动条
                        HStack(spacing: 20) { // 设置卡片之间的间距为 20
                            
                            //                                   ForEach(existingAnimals, id: \.self) { animal in
                            //                                       Image("\(animal)") // 替换成你的图片名称
                            //                                               .resizable()
                            //                                               .scaledToFit() // 让图片保持比例
                            //                                               .frame(height: 200) // 设置图片大小
                            //                                               .clipShape(RoundedRectangle(cornerRadius: 20))
                            //                                               .onTapGesture {
                            //                                                   print("2222")
                            //                                                   indexCat = "\(animal)"
                            //                                               }
                            //                                   }
                            ForEach(existingAnimals, id: \.self) { animal in
                                ZStack { // 使用 ZStack 叠放图片和 RoundedRectangle
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white) // 卡片颜色
                                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5) // 阴影效果
                                        .frame(width: 200, height: 280) // 卡片宽高
                                    //613202 #bfbbb7
                                        .overlay( // 添加边框
                                            RoundedRectangle(cornerRadius: 20) // 确保边框和矩形的圆角一致
                                                .stroke(DataColor.hexToColor(hex: "#613202"), lineWidth: indexCat == "\(animal)" ? 4 : 2) // 边框颜色和宽度
                                        )
                                        .onTapGesture {
//                                            print("11111111")
                                            indexCat = "\(animal)"
                                            UserDefaults.standard.set("\(animal)", forKey: "indexCat")
                                        }
                                    
                                    // 添加图片到卡片上
                                    Image("\(animal)") // 替换成你的图片名称
                                        .resizable()
                                        .scaledToFit() // 让图片保持比例
                                        .frame(height: 200) // 设置图片大小
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .onTapGesture {
//                                            print("2222")
                                            indexCat = "\(animal)"
                                            UserDefaults.standard.set("\(animal)", forKey: "indexCat")
                                        }
                                    
                                    
                                    VStack {
                                        Spacer() // 将 icon 推到卡片的底部
                                        HStack {
                                            Spacer() // 将 icon 推到卡片的右边
                                            
                                            if(indexCat == "\(animal)"){
                                                Image("icon4") // 右下角的图标
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 30) // 设置图标大小
                                                    .padding(20) // 可以根据需求调整右下角的距离
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }
                                .padding(.horizontal, 0) // 每个卡片的左右边距
                            }
                            
                            ZStack { // 使用 ZStack 叠放图片和 RoundedRectangle
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white) // 卡片颜色
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5) // 阴影效果
                                    .frame(width: 200, height: 280) // 卡片宽高
                                //613202 #bfbbb7
                                    .overlay( // 添加边框
                                        RoundedRectangle(cornerRadius: 20) // 确保边框和矩形的圆角一致
                                            .stroke(DataColor.hexToColor(hex: "#613202"), lineWidth: 2) // 边框颜色和宽度
                                    )
                                
                                // 添加图片到卡片上
                                Text("?") // 替换成你的图片名称
                                    .font(.system(size: 180))
                                    .foregroundColor(DataColor.hexToColor(hex: "#613202"))
                                    .frame(height: 200) // 设置图片大小
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        .padding() // 控制整个 HStack 的左右内边距
                        
                        
                        
                        
                        
                    }
                    
                    Spacer().frame(height: 50)
                    
                }
                .frame(height: modalHeight)
                .frame(width: geometry.size.width)
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .onAppear {
            // 从 UserDefaults 读取已获得的宠物
            existingAnimals = UserDefaults.standard.stringArray(forKey: "existingAnimals") ?? ["cat1"]
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .transition(.move(edge: .bottom))
    }
}

// 用于创建部分圆角的扩展
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}




struct ModalView2: View {
    @Binding var isPresented: Bool
    var modalHeight: CGFloat
    var isCollectionComplete: Bool
    var randomAnimal: String?
    @State private var selectedMessage: String = ""
    @State private var showImage = false
    @State private var imageOffset: CGFloat = -300
    @State private var isAnimating = false
    
    // Detect the device's language setting
    let languageCode = Locale.current.languageCode ?? "en"
    
    // Define pet messages in Chinese and English
    let petMessages: [String]
    
    init(isPresented: Binding<Bool>, modalHeight: CGFloat, isCollectionComplete: Bool, randomAnimal: String?) {
        self._isPresented = isPresented
        self.modalHeight = modalHeight
        self.isCollectionComplete = isCollectionComplete
        self.randomAnimal = randomAnimal
        
        // Choose the pet messages based on the language code
        if languageCode.starts(with: "zh") {
            self.petMessages = [
                "我是你的忠实伙伴，总是懂你的小心思，期待和你一起度过每一个快乐的时光！",
                "我不仅可爱，还很贴心哦！陪在你身边是我最幸福的事，我们要一起享受每一天！",
                "我是小小的开心果，每天都会给你带来无尽的欢乐和温暖，请好好照顾我吧！",
                "我喜欢撒娇，也喜欢玩耍，有你在的日子，我的世界才最完美，咱们一起创造更多美好回忆吧！",
                "我是你最忠诚的朋友，无论什么时候我都会陪伴你，请放心地把爱给我吧，我们会一起成长！",
                "我是个小调皮鬼，但我知道你最喜欢我可爱的样子，跟着我一起玩吧！",
                "我会用温柔的眼神看着你，用小爪子抓住你的心，我们会一起开心成长！",
                "有我陪伴，你的每一天都会充满欢乐和笑声，让我们一起探索这个美好的世界吧！",
                "我爱听你说话，也喜欢在你身边撒娇，跟你在一起的日子，是我最快乐的时光！",
                "我会永远在你身边，无论开心还是难过，我都是你最好的陪伴者！",
                "无论你走到哪里，我都会跟随你，因为你的陪伴对我来说最重要！",
                "每天我都在等你回来，我们一起度过的时光，是我最珍贵的回忆！",
                "我喜欢在你身边打滚，只要你在，世界就变得温暖又安心！",
                "我是你的守护者，用我全部的爱给你带来温暖和力量！",
                "无论晴天还是雨天，我都会陪你一起走过，因为你就是我的全世界！",
                "我非常聪明，也很活泼，喜欢陪伴你，请多多宠爱我，我们一起快乐生活吧！",
                "我是你的小跟班，无论你去哪里，我都会默默陪伴在你身边！",
                "我喜欢躺在你的脚边，感受你的温暖和安心！",
                "你的笑容是我最大的动力，我们一起过每一个幸福的日子吧！",
                "每天看到你回家，我的小心脏都会扑通扑通地跳得更快！"
            ]
        } else {
            self.petMessages = [
                "I’m your loyal friend, always here for you. Can’t wait for good times together!",
                "I’m not just cute, I’m thoughtful too! Being by your side is my greatest joy.",
                "I’m your little joy-bringer, bringing endless happiness. Take good care of me!",
                "I love cuddles and playtime. Let’s create beautiful memories together!",
                "I’m your most loyal friend, always by your side. Let’s grow together!",
                "I’m a little mischievous, but you love my cute side. Let’s play!",
                "I’ll melt your heart with my eyes and paws. Let’s grow happy together!",
                "With me around, every day will be full of laughter. Let’s explore the world!",
                "I love hearing you talk and being near you. Time with you is my happiest time!",
                "I’ll always be by your side, whether you’re happy or sad. I’m your best companion!",
                "Wherever you go, I’ll follow because your company means the world to me!",
                "I wait for you every day. Our time together is my most precious memory!",
                "I love rolling around near you. When you’re here, everything feels warm and safe!",
                "I’m your protector, bringing you warmth and strength with all my love!",
                "Rain or shine, I’ll walk with you because you’re my whole world!",
                "I’m smart and playful. Please spoil me, and let’s enjoy life together!",
                "I’m your little shadow, quietly following you wherever you go!",
                "I love lying by your feet, feeling your warmth and comfort!",
                "Your smile is my biggest motivation. Let’s enjoy every happy day together!",
                "Every time you come home, my heart beats faster with excitement!"
            ]
        }
    }
    
    
    
    
    var body: some View {
        //        let animalManager = AnimalManager()
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("关闭")
                                .foregroundColor(DataColor.hexToColor(hex: "#b5b5b5"))
                                .padding()
                            
                            
                        }
                        Spacer()
                    }.padding(.top, 5)
                    
                    Spacer()
                    
                    if isCollectionComplete {
                        //                      if false {
                        Image("cat12") // 右下角的图标
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280) // 设置图标大小
                            .padding(20) //
                        Text("🎉你已经收集完成🎉")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white) // 设置卡片颜色，这里用白色作为示例
                                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5) // 添加阴影效果
                                .frame(height: 100) // 设置卡片高度，可以根据需要调整
                                .padding(.horizontal, 20) // 左右边距
                            //                           .padding(.bottom, 20) // 底部边距
                            
                            
                            Text("恭喜🎉！你已经收集了所有的宠物，让我们一起快乐生活吧！")
                                .font(.headline)
                                .font(.system(size: 14))
                                .foregroundColor(DataColor.hexToColor(hex: "#4a4a4a"))
                                .padding(.horizontal, 40) // 设置左右边距为 20
                            
                        } .padding(20)
                        
                    } else{
                        
                        Image(randomAnimal ?? "cat2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)
                            .scaleEffect(x: isAnimating ? 1.04 : 1, y: isAnimating ? 1 : 1.02)
                            .offset(x: imageOffset, y: 0) // Apply the horizontal offset
                            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.4), value: imageOffset) // Slide-in animation
                            .padding(20)
                            .onAppear {
                                // Animate the image to the center
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    imageOffset = 0
                                }
                                
                                // Start the scaling animation after the slide-in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        isAnimating = true
                                    }
                                }
                            }
                        Text("🐾🐱🐱🐱🐾")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(DataColor.hexToColor(hex:"#4a4a4a"))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white) // 设置卡片颜色，这里用白色作为示例
                                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5) // 添加阴影效果
                                .frame(height: 100) // 设置卡片高度，可以根据需要调整
                                .padding(.horizontal, 20) // 左右边距
                            //                           .padding(.bottom, 20) // 底部边距
                            
                            
                            Text(selectedMessage)
                                .font(.headline)
                                .font(.system(size: 14))
                                .foregroundColor(DataColor.hexToColor(hex: "#4a4a4a"))
                                .padding(.horizontal, 40) // 设置左右边距为 20
                            
                        }.padding(20)
                    }
                    
                    
                    Spacer().frame(height: 60)
                    
                    
                    
                    
                    //                    Spacer().frame(height: 50)
                    
                }
                .frame(height: modalHeight)
                .frame(width: geometry.size.width)
                .background(DataColor.hexToColor(hex: "#f8f8f8"))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                
            }.onAppear {
                selectedMessage = petMessages.randomElement() ?? "我非常聪明，也很活泼，喜欢陪伴你，请多多宠爱我，我们一起快乐生活吧！"
                // Animate the image to its final position
                //                imageOffset = 0
                //                isAnimating = true
            }
            .onDisappear {
                
                // Reset the offset for the next time the modal appears
                imageOffset = -300
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .transition(.move(edge: .bottom))
    }
}



class DataColor {
    static func hexToColor(hex: String, alpha: Double = 1.0) -> Color {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        let scanner = Scanner(string: formattedHex)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let red = Double((color & 0xFF0000) >> 16) / 255.0
            let green = Double((color & 0x00FF00) >> 8) / 255.0
            let blue = Double(color & 0x0000FF) / 255.0
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // 返回默认颜色，当转换失败时
            return Color.black
        }
    }
}



struct OnboardingOverlay: View {
    @Binding var isShowingGuide: Bool
    @Binding var showModal2: Bool
    @State private var currentStep = 0
    let onComplete: () -> Void
    
    private let guideSteps = [
        NSLocalizedString("guideSteps1", comment: "guideSteps"),
        NSLocalizedString("guideSteps2", comment: "guideSteps"),
        NSLocalizedString("guideSteps3", comment: "guideSteps"),
    ]
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 半透明黑色背景
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("cat12")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.blue)
                        .padding(.bottom, 2)
                    //                       .padding(.leading, 20)  // 左侧 padding
                        .padding(.trailing, 230) // 右侧 padding
                    
                    //                    Spacer()
                    // 引导文本
                    Text(guideSteps[currentStep])
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    //                        .padding(45)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius:45)
                                .fill(Color.white)
                                .shadow(radius: 40)
                                .padding(.horizontal)
                        )
                    
                    
                    // 按钮
                    Button(action: handleButtonTap) {
                        Text(currentStep < guideSteps.count - 1 ? "下一步" : "打开看看")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 260, height: 58)
                            .background(DataColor.hexToColor(hex: "#dba866") )
                            .cornerRadius(40)
                    }
                    .padding(.vertical, 80)
                }
                .padding(.bottom, 60)
            }
        }
    }
    
    private func handleButtonTap() {
        if currentStep < guideSteps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            
            showModal2.toggle()
            isShowingGuide = false
            onComplete()
        }
    }
}


// 1. 创建语言工具类
class LanguageManager {
    static let shared = LanguageManager()
    
    // 获取当前语言代码
    var currentLanguage: String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return languageCode
    }
    
    // 检查是否是中文
    var isChinese: Bool {
        return currentLanguage.starts(with: "zh")
    }
    
    // 根据语言获取值
    func getValue<T>(chinese: T, english: T) -> T {
        return isChinese ? chinese : english
    }
}

// 2. 创建环境值来存储当前语言
struct CurrentLanguageKey: EnvironmentKey {
    static let defaultValue: String = Locale.current.language.languageCode?.identifier ?? "en"
}

extension EnvironmentValues {
    var currentLanguage: String {
        get { self[CurrentLanguageKey.self] }
        set { self[CurrentLanguageKey.self] = newValue }
    }
}
