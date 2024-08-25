//
//  SideMenuViewContent.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/16/24.
//

import SwiftUI

struct SideMenuViewContent: View {
    @Binding var presentSideMenu: Bool
    var body: some View {
        HStack{
            ZStack{
                Text("Hello World")
            }
            .frame(maxWidth: .infinity)
        }
        .padding([.leading, .trailing], 20)
    }
}

