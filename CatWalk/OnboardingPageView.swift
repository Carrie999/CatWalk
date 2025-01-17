//
//  OnboardingPageView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/10/17.
//

import SwiftUI
import UserNotifications
import HealthKit

//"onboarding_title" = "Cats Walk🐈";
//"onboarding_description" = "Exchange steps for pets";
//

struct OnboardingPage: Identifiable {
    
    
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    let onboardingPages = [
        OnboardingPage(
            title: NSLocalizedString("onboarding_title", comment: "App title for onboarding screen"),
            description: NSLocalizedString("onboarding_description", comment: "Description for onboarding screen"),
            imageName: "cat15"
        ),
        OnboardingPage(
            title: NSLocalizedString("onboarding_title2", comment: "App title for onboarding screen"),
            description: NSLocalizedString("onboarding_description2", comment: "Description for onboarding screen"),
            imageName: "cat1"
            
        ),
        OnboardingPage(
            title: NSLocalizedString("onboarding_title3", comment: "App title for onboarding screen"),
            description: NSLocalizedString("onboarding_description3", comment: "Description for onboarding screen"),
            imageName: "cat3"
        )
    ]
    
    func nextPage() {
        if currentPage < onboardingPages.count - 1 {
            currentPage += 1
        }
    }
}

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingCompleted: Bool
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(viewModel.onboardingPages.indices, id: \.self) { index in
                OnboardingPageView(
                    page: viewModel.onboardingPages[index],
                    isLastPage: index == viewModel.onboardingPages.count - 1,
                    isSecondPage: index == viewModel.onboardingPages.count - 2,
                    onNextTapped: {
                        if index == viewModel.onboardingPages.count - 2 {
                            notificationManager.requestPermission { granted in
                                if granted {
                                    //                                    print("用户已授予通知权限")
                                    // 执行下一步逻辑，例如跳转到下一页
                                    viewModel.nextPage()
                                } else {
                                    //                                    print("用户拒绝了通知权限")
                                    viewModel.nextPage()
                                    // 可根据需要处理拒绝逻辑
                                }
                            }
                        }
                        if index == viewModel.onboardingPages.count - 1 {
                            healthKitManager.requestAuthorization()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isOnboardingCompleted = true
                            }
                            
                        }
                        if index == 0 {
                            viewModel.nextPage()
                        }
                    }
                )
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}



struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    let isSecondPage: Bool
    let onNextTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .foregroundColor(.blue)
            
            
            Text(page.title)
                .font(.title)
                .bold()
                .padding(.top, 40)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // fcc680
            Button(action: onNextTapped) {
                
                if isSecondPage {
                    Text("打开通知")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(DataColor.hexToColor(hex: "#dba866") )
                        .cornerRadius(25)
                } else{
                    Text(isLastPage ? "连接 Apple 健康" : "下一步")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(DataColor.hexToColor(hex: "#dba866") )
                        .cornerRadius(25)
                }
                
            }
            .padding(.bottom, 50)
        }
    }
}

// 主视图示例使用方法
struct Content1View: View {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        if !isOnboardingCompleted {
            OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
        } else {
            ContentView()
        }
    }
}


// 方法2：创建扩展来简化使用
extension String {
    var localized: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}
#Preview {
    Content1View()
}
