//
//  CustomTabBarView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    
    var body: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .paycheck, .favorites, .profile
    ]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!))
        }
    }
}

extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack{
            Image(systemName: tab.iconImageName)
                .font(.subheadline)
            Text(tab.iconTitle)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selection == tab ? tab.iconColor : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
//        .background(selection == tab ? tab.iconColor.opacity(0.2) : Color.white)
        .background(
            ZStack{
                if selection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.iconColor.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle" , in: namespace)
                }
            }
        )
    }
    
    private func switchToTab(tab: TabBarItem) {
//        withAnimation(.easeInOut) {
            selection = tab
//        }
    }
}
