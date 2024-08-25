//
//  ContentView.swift
//  ToDoList
//
//  Created by Bryce Nicholson on 6/23/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var isSideBarOpened = false
    init(){
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    var body: some View {
        NavigationView {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                ZStack{
                    TabView {
                        HomeView(userId: viewModel.currentUserId)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            };
                        BuildView(userId: viewModel.currentUserId)
                            .tabItem {
                                Label("Budget", systemImage: "book.pages.fill")
                            }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                isSideBarOpened.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal").foregroundColor(.gray)
                            }
                        }
                    }
                    SideView(isSidebarVisible: $isSideBarOpened)
                    
                }
            }
            else{
                LoginView()
            }
        }

    }
}

#Preview {
    MainView()
}
