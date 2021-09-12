//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Yong Jin on 2021/9/12.
//

import SwiftUI

struct CustomTabBar: View {
    
    // This App will work for both iOS 14/15...
    // Current tab...
    @State var currentTab: Tab = .Home
    
    // Hiding native One...
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    //Matched Geometry effect...
    @Namespace var animation
    
    // Current Tab XValue...
    @State var currentXValue: CGFloat = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
            
            SampleCards(color: .purple, count: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Home)
                
            
            Text("Search")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Search)
            
            Text("Notifications")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Notifications)
            
            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Account)
        }
        // Curved Tab Bar...
        .overlay(
            
            HStack(spacing: 0){
                
                ForEach(Tab.allCases, id: \.rawValue) {tab in
                    
                    TabButton(tab: tab)
                }
            }
                .padding(.vertical)
            // Preview not show seafArea edgeInsets
                .padding(.bottom, getSafeArea().bottom == 0 ? 10 : getSafeArea().bottom - 10)
                .background(
                    
                    MaterialEffect(style: .systemUltraThinMaterial)
                        .clipShape(BottomCurve(currentXValue: currentXValue))
                )
            , alignment: .bottom
            
        )
        .ignoresSafeArea(.all, edges: .bottom)
        // Always Dark...
        .preferredColorScheme(.dark)
    }
    
    // Sample Cards...
    func SampleCards(color: Color, count: Int) -> some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    
                    ForEach(1...count, id: \.self) {id in
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(height: 250)
                        
                    }
                }
                .padding()
                // Approx Bottom Padding...
                //30 size...
                // padding = 30
                // Bottom Edge...
                .padding(.bottom, 60)
                .padding(.bottom, getSafeArea().bottom == 0 ? 15: getSafeArea().bottom)
            }
            .navigationBarTitle("Home")
        }
    }
    
    //TabButton...
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        
        //Since we need XAxis Value for Curve..
        GeometryReader{ proxy in
            
            Button {
                
                withAnimation(.spring()) {
                    currentTab = tab
                    currentXValue = proxy.frame(in: .global).midX
                }
                
            } label: {
                
                // Moving Button up for current Tab...
                
                Image(systemName: tab.rawValue)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        
                        ZStack {
                            
                            if currentTab == tab{
                                
                                MaterialEffect(style: .systemChromeMaterial)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            // Setting initial curve position...
            .onAppear{
                
                if tab == Tab.allCases.first && currentXValue == 0{
                    
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
        
        // MaxSize...
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}

// To Iterater...
//Enum for tab
enum Tab: String, CaseIterable{
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Account = "person.fill"
}

// Getting Safe Area...
extension View {
    
    func getSafeArea() -> UIEdgeInsets{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
