//
//  ProView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/10/15.
//

import SwiftUI
import StoreKit

struct ProSwiftUIView: View {
    @StateObject var storeKit = StoreKitManager()
    @State var isPurchased: Bool = false
    @State var isPurchasedId: String? = ""
    
    func hexToColor(hex: String, alpha: Double = 1.0) -> Color {
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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedProductId: String = "CatsWalkPro"
    @State private var selectedProduct: Product? = nil
    
    
    
    let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        
        
        VStack{
            HStack(alignment: .center,spacing:20){
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .opacity(1)
                        .frame(width: 60, height: 60)
                        .background(DataColor.hexToColor(hex: "ffffff"))
                        .clipShape(Circle()) // Make the background circular
                    
                }.padding(.leading, 20)
                
                
                Spacer()
                Text("Pro").font(.system(size: 22)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Color.clear.frame(width: 80)
                
                //                Button(action: {
                ////                    self.presentationMode.wrappedValue.dismiss()
                //                }) {
                ////                    Text("恢复购买")
                //                    Image(systemName: "chevron.backward.2").font(.system(size: 24))
                //                        .frame(width: 80, height: 60)
                //                }.padding().opacity(0)
                //                
            }.frame(height: screenHeight <= 667 ? CGFloat(60) : CGFloat(60))
            
            
            ScrollView(){
                
         
            
            Image("cat12") // 右下角的图标
                .resizable()
                .scaledToFit()
                .frame(height: 110) // 设置图标大小
                .padding(5) //
            
            Text("解锁所有的宠物").font(.system(size: 20))
                Spacer().frame(height: 5)
            Text("每月会提供新的宠物伙伴").font(.system(size: 20))
//                    .foregroundStyle(DataColor.hexToColor(hex: "704918"))
            Spacer().frame(height: 30)
            //                    .cornerRadius(20, corners: [.topLeft, .topRight])
            //            VStack{
            ////                Spacer().frame(width: 50)
            //                
            //                Text("🐕  解锁所有的动物宠物").font(.system(size: 22)) .background(DataColor.hexToColor(hex: "#ffffff"))
            //                    .cornerRadius(20, corners: [.topLeft, .topRight])
            //                
            //               
            //
            //            }.padding(50)
            //                .background(DataColor.hexToColor(hex: "#ffffff"))
            //                .cornerRadius(20)
            
            
            VStack {
                ForEach(storeKit.storeProducts, id: \.self) { product in
                    VStack {
                        Spacer().frame(height:16)
//                        if product.subscription != nil {
//                            HStack {
//                                Text(UserDefaults.standard.bool(forKey: "CatsWalkProSubscription") == true ? "🎉您已每月续订" :"每月续订")
//                                    .font(.system(size: 22, weight: .bold))
//                                //                                    .padding(.leading, 10) // 添加左侧内边距，确保内容不贴边
//                                //                                    .background(DataColor.hexToColor(hex: "#ffffff"))
//                                    .cornerRadius(20, corners: [.topLeft, .topRight])
//                                Spacer() // 保证文本左对齐
//                            }
//                        } else {
                            HStack {
                                
                                Text(UserDefaults.standard.bool(forKey: "CatsWalkPro") == true ? "🎉您已是永久会员" :"永久会员")
                                    .font(.system(size: 22, weight: .bold))
                                //                                    .background(DataColor.hexToColor(hex: "#ffffff"))
                                    .cornerRadius(20, corners: [.topLeft, .topRight])
                                Spacer()
                            }
                            
//                        }
                        Spacer().frame(height:4)
                        
                        HStack {
                            Text(product.displayPrice)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color.black)
                            
                            Spacer()
                            
                            //
                            if selectedProductId == product.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.black) // 图标的颜色
                                    .font(.system(size: 32)) // 图标的大小
                            } else{
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(DataColor.hexToColor(hex: "#818181")) // 图标的颜色
                                    .font(.system(size: 32)) // 图标的大小
                            }
                        }
                        Spacer().frame(height:4)
                        
//                        if product.subscription != nil {
//                            HStack {
//                                Text("仅一杯咖啡的价格")
//                                    .font(.system(size: 18)).opacity(0.7)
//                                
//                                Spacer()
//                            }
//                            
//                            
//                        } else {
                            HStack {
                                Text("一次付费，永久拥有")
                                    .font(.system(size: 18)).opacity(0.7)
                                
                                Spacer()
                            }
                            
                            
//                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, minHeight: 150)
                    
                    .background( selectedProductId == product.id ? DataColor.hexToColor(hex: "#fcc680") : DataColor.hexToColor(hex: "#ffffff")) // 点击后背景变黄
                    //                    .background(DataColor.hexToColor(hex: "#ffffff"))
                    .cornerRadius(20)
                    .overlay( // 添加黄色描边效果
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedProductId == product.id ? DataColor.hexToColor(hex: "#603301") : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedProductId = product.id // 点击后更新选中的产品ID
                        selectedProduct = product // 点击后更新选中的产品ID
                    }
                    .opacity((UserDefaults.standard.bool(forKey: "CatsWalkPro") == true &&  product.id == "CatsWalkProSubscription") ? 0.4 : 1)
                    .padding(.vertical, 5)
                    .onAppear {
                        //                        checkPurchases(product: product)
                    }
                    
                }.onAppear {
                    if let oneTimeProduct = storeKit.storeProducts.first(where: { $0.subscription == nil }) {
                        selectedProductId = oneTimeProduct.id
                        selectedProduct = oneTimeProduct
                    }
                }
            }
            
            .padding(.horizontal, 20)
            
            
            
            
            Spacer().frame(height:70)
            
            
            
            //            ForEach(storeKit.storeProducts) {
            //                                    product in HStack{
            VStack{
                
                
                
                Button(action: {
                    //                        print(storeKit.storeProducts)
                    
                    //                        if isPurchased {
                    //                           
                    //        
                    //                           
                    //                        }
                    if UserDefaults.standard.bool(forKey: "CatsWalkPro") == true {
                        return
                    }
                    Task{
                        //                            try await storeKit.purchase(selectedProduct ?? <#default value#>)
                        if let productToPurchase = selectedProduct {
                            try await storeKit.purchase(productToPurchase)
                        } else {
                            // 处理 selectedProduct 为空的情况，比如选择一个默认产品或显示错误提示
                            print("No product selected for purchase.")
                        }
                    }
                    
                }) {
                    //                           CourseItem(storeKit: storeKit, product: product)
                    
                    if (isPurchased || UserDefaults.standard.bool(forKey: "CatsWalkPro") == true) {
//                        if(selectedProductId == "CatsWalkPro" ){
                            if( UserDefaults.standard.bool(forKey: "CatsWalkPro") == true){
                                Text("🎉您已是永久会员").font(.system(size: 20))
                            }else{
                                Text("下一步").font(.system(size: 20))
                            }
//                        }
                        
//                        if(selectedProductId == "CatsWalkProSubscription" ){
//                            if( UserDefaults.standard.bool(forKey: "CatsWalkProSubscription") == true){
//                                Text("🎉您已成功连续每月订阅").font(.system(size: 20))
//                            }
//                            else{
//                                Text("🎉您已是永久会员").font(.system(size: 20))
//                            }
//                        }
                        
                        //                               Text(Image(systemName: "checkmark"))
                        //                                   .bold()
                        //                                   .padding(10).foregroundColor(hexToColor(hex:"192d32"))
                        
                    } else {
                        Text("下一步").font(.system(size: 18))
                    }
                    
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                
                .foregroundColor(hexToColor(hex:"192d32"))
                
                .background( DataColor.hexToColor(hex: "#fcc680") )
                
                //                       .cornerRadius(20)
                //                       .overlay( // 添加黄色描边效果
                //                               RoundedRectangle(cornerRadius: 20)
                //                                   .stroke( DataColor.hexToColor(hex: "#603301"), lineWidth: 2)
                //                           )
                .cornerRadius(15)
                .padding(.horizontal,20)
                .padding(.top,-10)
                .onChange(of: storeKit.purchasedCourses) { _ in
                    Task {
                        if let productToCheck = selectedProduct {
                            if let purchased = try? await storeKit.isPurchased(productToCheck) {
                                isPurchased = purchased
                                UserDefaults.standard.set(isPurchased, forKey: "isPurchased")
                                
                                if (isPurchased){
                                    UserDefaults.standard.set(true, forKey: "CatsWalkPro")
//                                    if(selectedProductId == "CatsWalkPro") {
//                                      
//                                    }
//                                    if(selectedProductId == "CatsWalkProSubscription") {
//                                        UserDefaults.standard.set(true, forKey: "CatsWalkProSubscription")
//                                    }
                                }
                                
                                
                            } else {
                                // 如果购买检查失败，默认将 isPurchased 设置为 false
                                isPurchased = false
                                UserDefaults.standard.set(false, forKey: "isPurchased")
                                UserDefaults.standard.set(false, forKey: "CatsWalkPro")
                            }
                        } else {
                            // 处理 selectedProduct 为空的情况
                            print("No product selected to check purchase status.")
                        }
                    }
                }
         
            }
            
            
            //                                    }
            //            }
            
            
            
            
            Spacer().frame(height: 26)
            HStack{
                Spacer().frame(width: 10)
                Link(destination: URL(string: "https://docs.qq.com/doc/DUHVkTmNaUWVsc0V2")!) {
                    Text("使用条款")
                        .font(.system(size: 12))
                        .opacity(0.6)
//                        .padding()
                }
//                Text("使用条款").font(.system(size: 14)).opacity(0.6).padding()
                Spacer()
                Link(destination: URL(string: "https://docs.qq.com/doc/DUHJwUlRqWmF0dHdo")!) {
                    Text("隐私协议").font(.system(size: 12)).opacity(0.6)
                }
              
                Spacer()

                Button(action: {
                    Task {
                        
                        try? await AppStore.sync()
                    }
                    
                }) {
                    Text("恢复购买").font(.system(size: 12)).opacity(0.6)
                }
                
                Spacer().frame(width: 10)
                
                
            }
//           Text("订阅将会自动续费，除非您在当前订阅结束前 24 小时取消自动订阅。如果需要取消订阅，可以手动在 Apple ID 设置管理中关闭自动续费功能。").font(.system(size: 14)).opacity(0.6)
            
            .padding(.horizontal,40)
            .padding(.top,0)
            }
          
            
            
            
            
            
            
            
            Spacer()
            
            
            
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        .foregroundColor(hexToColor(hex:"000000"))
        .background(hexToColor(hex:"#f8f8f8"))
        .navigationBarHidden(true)
        .onAppear {
            
            
        }
        .onDisappear {
            
        }
        
        
        
        
        
        
        
    }
    
    
}

struct CourseItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .padding(10)
            } else {
                //                Text(product.displayPrice)
                //                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedCourses) { _ in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}



#Preview {
    ProSwiftUIView()
}

