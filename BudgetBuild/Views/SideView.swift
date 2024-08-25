//
//  SideView.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/16/24.
//
import FirebaseAuth
import SwiftUI

struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
    var action: () -> Void
}

var secondaryColor: Color = Color.gray



struct SideView: View {
    @Binding var isSidebarVisible: Bool
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
        var bgColor: Color = Color.white

        var body: some View {
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(.black.opacity(0.6))
                .opacity(isSidebarVisible ? 1 : 0)
                .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }
                content
            }
            .edgesIgnoringSafeArea(.all)
        }
        var content: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    Color.white
                    VStack (alignment: .leading, spacing: 20) {
                        MenuLinks(items: [
                            MenuItem(id: 4001, icon: "rectangle.portrait.and.arrow.right", text: "Sign out"){
                                do {
                                try Auth.auth().signOut()
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                                isSidebarVisible.toggle()
                               }
                        ])
                    }.padding(.top, 100)
                        .padding(.leading, -20)
                }
                .frame(width: sideBarWidth)
                .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
                .animation(.default, value: isSidebarVisible)

                Spacer()
            }
        }
    struct MenuLinks: View {
        var items: [MenuItem]
        var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                ForEach(items) { item in
                    menuLink(icon: item.icon, text: item.text, action: item.action)
                }
            }
            .padding(.vertical, 14)
            .padding(.leading, 8)
        }
    }
    struct menuLink: View {
        var icon: String
        var text: String
        var action: () -> Void
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(secondaryColor)
                    .padding(.trailing, 10)
                Text(text)
                    .foregroundColor(.gray)
                    .font(.body)
            }
            .onTapGesture {
                action()
            }
        }
    }
}


