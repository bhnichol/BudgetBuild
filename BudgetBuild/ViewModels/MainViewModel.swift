//
//  MainViewViewModel.swift
//  ToDoList
//
//  Created by Bryce Nicholson on 6/23/24.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation



class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener {[weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                if self?.currentUserId != nil{
                }
            }
           
        }
        
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
}
