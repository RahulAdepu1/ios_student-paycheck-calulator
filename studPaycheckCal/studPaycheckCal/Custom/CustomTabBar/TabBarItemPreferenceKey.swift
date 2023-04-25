//
//  TabBarItemPreferenceKey.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/23/23.
//

import Foundation
import SwiftUI

struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarViewModifier: ViewModifier {
    
    let tab : TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemPreferenceKey.self, value: [tab])
    }
}

extension View {
    
    func tabBarItem(tab: TabBarItem, selectoin: Binding<TabBarItem>) -> some View {
        self
            .modifier(TabBarViewModifier(tab: tab, selection: selectoin))
    }
}
