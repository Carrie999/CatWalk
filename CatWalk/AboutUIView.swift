//
//  AboutUIView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/10/19.
//


import SwiftUI
import MessageUI
import AppIntents
import StoreKit
import UIKit

struct AboutUIView: View {
    let screenHeight = UIScreen.main.bounds.height
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var body: some View {
        
        
        
        ZStack{
            //            DataColor.hexToColor(hex:"#f2f2f7")
            //                .edgesIgnoringSafeArea(.all)
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            VStack{
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
                    
                    Text("Setting").font(.system(size: 22)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                    
                    
                    
                    Color.clear.frame(width: 75) // 75 = 15 + 60 (左边padding + 返回按钮宽度)
                    
                    
                    
                    
                    
                    
                    
                }.frame(height: screenHeight <= 667 ? CGFloat(20) : CGFloat(60))
                
                
                //                Text("Daily Step Counts").font(.title)
                
                Spacer().frame(height: 30) }
//                ProVersionView()
                //                StepsView()
                
                
//                Spacer()
                
//                ScrollView(){
              
                
                VStack {
                    HStack {
                        Spacer().frame(width: 30)
                        Text("我的其他作品").padding()
                        Spacer()
                    }
                    
                    // First row
                    HStack(spacing: 0) {
                        // Fixed-width spacer for consistent edge spacing
                        Spacer().frame(width: 40)
                        
                        // First app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/soulwanderer/id6584520522")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/e1/c7/79/e1c7794f-b390-4ed6-9d89-9d9422c56f86/AppIcon-0-0-1x_U007emarketing-0-6-0-85-220.png/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("灵魂漫步")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Second app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/diffusecard/id6624303246")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/4a/46/d9/4a46d91d-2939-8d8d-797c-4d69dbd3506d/AppIcon-0-0-1x_U007epad-0-85-220.png/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("弥散卡片")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Third app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/floraltile/id6504483514")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/c2/7c/00/c27c00ff-d1b9-da6a-623e-ab5df56184a6/AppIcon-0-0-1x_U007epad-0-85-220.jpeg/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("FloralTile")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Fixed-width spacer for consistent edge spacing
                        Spacer().frame(width: 40)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    // Second row
                    HStack(spacing: 0) {
                        // Fixed-width spacer for consistent edge spacing
                        Spacer().frame(width: 40)
                        
                        // Fourth app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/edgesnap/id6504001857")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/87/41/5a/87415a07-fc8e-a81c-8fd0-17613cd0fd9c/AppIcon-0-0-1x_U007epad-0-85-220.png/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("EdgeSnap")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Fifth app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/hexa-pop/id6670310325")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/38/67/1c/38671c50-b3b8-c64a-c8dc-28befaddb827/AppIcon-0-0-1x_U007emarketing-0-7-0-85-220.png/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("Hexa Pop")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Sixth app
                        VStack {
                            Button(action: {
                                openAppStore(urlString: "https://apps.apple.com/us/app/led-banner-big-text/id6502876201")
                            }) {
                                AsyncImage(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/34/1b/c7/341bc73c-a1aa-fd91-7b3b-38ac3db4ef48/AppIcon-0-0-1x_U007epad-0-85-220.png/512x512bb.jpg")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text("LED Banner")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Fixed-width spacer for consistent edge spacing
                        Spacer().frame(width: 40)
                    }
                }
                
                
                
                
                SettingsView()
                
//                Spacer().frame(height: -20)
                Spacer()
//                }
        }
               
                
                
                
                
           
            
            
            
            
            
        }.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        
        
    }
}


struct SettingsView: View {
    
    @State private var isShowingActivityView = false
    
    func getAppShareText() -> String {
        // Customize the share text with your app's description
        return "Check out this amazing cat walk app! It's the best walk app ever!"
    }
    func getAppStoreLink() -> URL {
        // Replace "your_app_id" with your actual App Store ID
        let appStoreID = "6736933073"
        let appStoreURL = "https://apps.apple.com/app/id\(appStoreID)?action=write-review"
        return URL(string: appStoreURL)!
    }
    
    
    var body: some View {
        List {
            Section {
                Button(action: {
                    
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/6736933073?action=write-review"),
                       
                        UIApplication.shared.canOpenURL(url){
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    }
                    
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        //                            .foregroundColor(.yellow)
                        Text("给个好评")
                    }
                }
                
                Button(action: {
                    // 跳转到小红书
                    openURL(urlString: "https://www.xiaohongshu.com/user/profile/59ab59f850c4b46f8cdbdff4")
                }) {
                    HStack {
                        Image(systemName: "app.fill")
                        //                            .foregroundColor(.red)
                        Text("小红书")
                    }
                }
                
                Button(action: {
                    // 关于我们页面
                    openURL(urlString: "https://docs.qq.com/doc/DUGNMUGtqQmpTQm9x")
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                        //                            .foregroundColor(.blue)
                        Text("关于我们")
                    }
                }
                
                Button(action: {
                    // 隐私协议页面
                    openURL(urlString: "https://docs.qq.com/doc/DUHJwUlRqWmF0dHdo")
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                        //                            .foregroundColor(.gray)
                        Text("隐私协议")
                    }
                }
                
                Button(action: {
                    openURL(urlString: "https://docs.qq.com/doc/DUHVkTmNaUWVsc0V2")
                    // 用户协议页面
                }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        //                            .foregroundColor(.green)
                        Text("用户协议")
                    }
                }
                
                Button(action: {
                    // 分享给朋友的操作
                    self.isShowingActivityView = true
                    
                    
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up.fill")
                        
                        Text("分享我们")
                    }
                }   .sheet(isPresented: $isShowingActivityView, content: {
                    ActivityViewController(activityItems: [self.getAppShareText(), self.getAppStoreLink()])
                    
                })
                
                
              
                
                
                
                
                
            }
            
        }.scrollDisabled(true)
        //        .listStyle(GroupedListStyle())  // 分组样式
        
        
    }
    
    // Helper function to open external URLs
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}


#Preview {
    AboutUIView()
}

struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Do nothing
    }
}




// Helper function to open external URLs for App Store links
func openAppStore(urlString: String) {
    if let url = URL(string: urlString),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
