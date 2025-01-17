//
//  TujianView.swift
//  CatWalk
//
//  Created by  玉城 on 2024/9/27.
//

import SwiftUI




struct TujianView: View {
    let images = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", "cat15", "cat16", "cat17", "cat18", "cat19", "cat20", "cat21", "cat22", "cat23", "cat24", "cat25", "cat26", "cat27","cat28", "cat29", "cat30", "cat31", "cat32", "cat33"] // Example image names
    
    let Dogs = ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6", "dog7", "dog8", "dog9", "dog10", "dog11", "dog12", "dog13", "dog14", "dog15", "dog16", "dog17", "dog18"] // Example image names
    
    let Animals = ["animal1", "animal2", "animal3", "animal4", "animal5", "animal6", "animal7", "animal8", "animal9", "animal10", "animal11", "animal12", "animal13", "animal14", "animal15", "animal16", "animal17", "animal18", "animal19", "animal20", "animal21", "animal22", "animal23", "animal24"]
    let screenHeight = UIScreen.main.bounds.height
    @State private var existingAnimals: [String] = []
    let screenWidth = UIScreen.main.bounds.width
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            ZStack {
                DataColor.hexToColor(hex:"#f8f8f8")
                    .edgesIgnoringSafeArea(.all)
                
                
                
                VStack{
                    Spacer().frame(height: 60)
                    
                    HStack(alignment: .center,spacing:0){
                        Spacer().frame(width: 15)
                        Image(systemName: "chevron.backward").font(.system(size: 22))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .opacity(1)
                            .frame(width: 60, height: 60)
                            .background(DataColor.hexToColor(hex: "ffffff"))
                            .clipShape(Circle()) // Make the background circular
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        
                        Spacer()
                        
                        
                        Image("MyPets") // 使用本地图片
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame( height: 40) // 设置图片尺寸
                        
                        Spacer()
                        
                        Color.clear.frame(width: 75)
                        
                    } .frame(height:screenHeight <= 667 ? CGFloat(20) : CGFloat(60))
                    

                    Spacer().frame(height: 20)
                    

                    ScrollView(.vertical) {
                        VStack {
                            //                    LazyVStack {
                            ProVersionView()
                            
                            Spacer().frame(height: 20)
                            Text("🐱每月会提供新的宠物伙伴🐱")
                                .foregroundStyle(DataColor.hexToColor(hex: "704918"))
                   
                            
                            Spacer().frame(height: 20)
                            
                            Image("catss").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250)
                            
                            ForEach(0..<11, id: \.self) { row in // Simulating infinite rows
                                HStack {
                                    ForEach(0..<3, id: \.self) { col in
                                        let imageName = images[(row * 3 + col) % images.count]
                                        
                                        // 检查 existingAnimals 中是否包含当前图片
                                        if !existingAnimals.contains(imageName) {
                                            if row < 6 {
                                                Image(imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: (screenWidth - 20) / 3)
                                                    .overlay(
                                                        DataColor.hexToColor(hex: "#bda689")
                                                            .mask(
                                                                Image(imageName)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                            )
                                                    )
                                                    .padding(.horizontal, -5)
                                            } else{
                                                
                                                if !UserDefaults.standard.bool(forKey: "isPurchased") {
                                                    NavigationLink(destination: ProSwiftUIView()) {
                                                        ZStack {
                                                            Image(imageName)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: (screenWidth - 20) / 3)
                                                                .overlay(
                                                                    DataColor.hexToColor(hex: "#bda689")
                                                                        .mask(
                                                                            Image(imageName)
                                                                                .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                        )
                                                                )
                                                                .padding(.horizontal, -5)
                                                            
                                                            ZStack {
                                                                // 底层的黑色描边
                                                                Image(systemName: "lock.circle")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 35, height: 35) // 比实际图标略大
                                                                    .foregroundColor(DataColor.hexToColor(hex: "#603301")) // 设置描边颜色为黑色
                                                                
                                                                // 顶层的填充图标
                                                                Image(systemName: "lock.circle.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 30, height: 30) // 实际图标
                                                                    .foregroundColor(  DataColor.hexToColor(hex: "#fcc680")) // 图标颜色为蓝色
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                }else{
                                                    Image(imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: (screenWidth - 20) / 3)
                                                        .overlay(
                                                            DataColor.hexToColor(hex: "#bda689")
                                                                .mask(
                                                                    Image(imageName)
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                )
                                                        )
                                                        .padding(.horizontal, -5)
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            
                                        } else {
                                            Image(imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: (screenWidth - 20) / 3)
                                                .padding(.horizontal, -5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 0) // Add 10 points padding on both left and right
                                .padding(.top, 20)
                            }
                            
                            
                            
                            
                            
                            Spacer().frame(height: 60)
                            
                            
                            Image("dogss").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250)
                            
                            
                            
                            
                            //                        ForEach(0..<5, id: \.self) { row in // Simulating infinite rows
                            //                            HStack {
                            //                                ForEach(0..<3, id: \.self) { col in
                            //                                    Image(Dogs[(row * 3 + col) % Dogs.count])
                            //                                        .resizable()
                            //                                        .aspectRatio(contentMode: .fit)
                            //                                        .frame(width: (screenWidth - 20) / 3 )
                            ////                                        .overlay(
                            ////                                            DataColor.hexToColor(hex: "#bda689")
                            //////                                                      Color.black // Overlay the image with a black color
                            ////                                                          .mask(
                            ////                                                              Image(images[(row * 3 + col) % images.count])
                            ////                                                                  .resizable()
                            ////                                                                  .aspectRatio(contentMode: .fit)
                            ////                                                          ) // Mask the black color to the shape of the image
                            ////                                                  )
                            //                                        .padding(.horizontal, -5)
                            //                                }
                            //                            }
                            //                            .padding(.horizontal, 0) // Add 10 points padding on both left and right
                            //                            .padding(.top, 20)
                            //                        }
                            
                            ForEach(0..<6, id: \.self) { row in // Simulating infinite rows
                                HStack {
                                    ForEach(0..<3, id: \.self) { col in
                                        let imageName = Dogs[(row * 3 + col) % Dogs.count]
                                        
                                        
                                        // 检查 existingAnimals 中是否包含当前图片
                                        if !existingAnimals.contains(imageName) {
                                            if UserDefaults.standard.bool(forKey: "isPurchased") {
                                                
                                                
                                                Image(imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: (screenWidth - 20) / 3)
                                                    .overlay(
                                                        DataColor.hexToColor(hex: "#bda689")
                                                            .mask(
                                                                Image(imageName)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                            )
                                                    )
                                                    .padding(.horizontal, -5)
                                                
                                                
                                                
                                                
                                                
                                            } else{
                                                NavigationLink(destination: ProSwiftUIView()) {
                                                    ZStack{
                                                        Image(imageName)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: (screenWidth - 20) / 3)
                                                            .overlay(
                                                                DataColor.hexToColor(hex: "#bda689")
                                                                    .mask(
                                                                        Image(imageName)
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                    )
                                                            )
                                                            .padding(.horizontal, -5)
                                                        
                                                        
                                                        
                                                        
                                                        ZStack {
                                                            // 底层的黑色描边
                                                            Image(systemName: "lock.circle")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 35, height: 35) // 比实际图标略大
                                                                .foregroundColor(DataColor.hexToColor(hex: "#603301")) // 设置描边颜色为黑色
                                                            
                                                            // 顶层的填充图标
                                                            Image(systemName: "lock.circle.fill")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 30, height: 30) // 实际图标
                                                                .foregroundColor(  DataColor.hexToColor(hex: "#fcc680")) // 图标颜色为蓝色
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            
                                            
                                        } else {
                                            Image(imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: (screenWidth - 20) / 3)
                                                .padding(.horizontal, -5)
                                        }
                                        
                                        
                                        
                                    }
                                }
                                .padding(.horizontal, 0) // Add 10 points padding on both left and right
                                .padding(.top, 20)
                            }
                            
                            
                            
                            Spacer().frame(height: 60)
                            
                            
                            
                            
                            Image("animalss").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                            
                            ForEach(0..<8, id: \.self) { row in // Simulating infinite rows
                                HStack {
                                    ForEach(0..<3, id: \.self) { col in
                                        let imageName = Animals[(row * 3 + col) % Animals.count]
                                        
                                        
                                        if (row == 7 && col == 2) || (row == 7 && col == 1){
                                            Spacer()
                                                .frame(width: (screenWidth - 20) / 3)
                                                .padding(.horizontal, -5)
                                            
                                        } else {
                                            if !existingAnimals.contains(imageName) {
                                                if UserDefaults.standard.bool(forKey: "isPurchased") {
                                                    Image(imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: (screenWidth - 20) / 3)
                                                        .overlay(
                                                            DataColor.hexToColor(hex: "#bda689")
                                                                .mask(
                                                                    Image(imageName)
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                )
                                                        )
                                                        .padding(.horizontal, -5)
                                                    
                                                }
                                                else {
                                                    NavigationLink(destination: ProSwiftUIView()) {
                                                        ZStack{
                                                            Image(imageName)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: (screenWidth - 20) / 3)
                                                                .overlay(
                                                                    DataColor.hexToColor(hex: "#bda689")
                                                                        .mask(
                                                                            Image(imageName)
                                                                                .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                        )
                                                                )
                                                                .padding(.horizontal, -5)
                                                            
                                                            
                                                            
                                                            
                                                            ZStack {
                                                                // 底层的黑色描边
                                                                Image(systemName: "lock.circle")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 35, height: 35) // 比实际图标略大
                                                                    .foregroundColor(DataColor.hexToColor(hex: "#603301")) // 设置描边颜色为黑色
                                                                
                                                                // 顶层的填充图标
                                                                Image(systemName: "lock.circle.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 30, height: 30) // 实际图标
                                                                    .foregroundColor(  DataColor.hexToColor(hex: "#fcc680")) // 图标颜色为蓝色
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                }
                                            } else {
                                                Image(imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: (screenWidth - 20) / 3)
                                                    .padding(.horizontal, -5)
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        //
                                    }
                                }
                                .padding(.horizontal, 0) // Add 10 points padding on both left and right
                                .padding(.top, 20)
                            }
                            
                            
                            
                            
                            
                        }
                        Spacer().frame(height: 100)
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
            }
            .onAppear {
                // 从 UserDefaults 读取已获得的宠物
                existingAnimals = UserDefaults.standard.stringArray(forKey: "existingAnimals") ?? ["cat1"]
                
                //            existingAnimals =  ["cat11", "cat15", "cat9", "cat14", "cat8", "cat2", "cat10", "cat16","dog1","animal1"]
                //            print(existingAnimals)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}



struct ProVersionView: View {
    var body: some View {
        NavigationLink(destination: ProSwiftUIView()) {
            ZStack {
                Image("pro")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 40)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("解锁专业版💎")
                            .font(.system(size: 28, weight: .bold))
                        Text("解锁所有宠物朋友")
                            .font(.system(size: 16))
                            .opacity(0.5)
                    }
                    .padding(.leading, 40)
                    .padding(.top, -8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // 让 NavigationLink 看起来像普通视图而不是按钮
    }
}



#Preview {
    TujianView()
}
