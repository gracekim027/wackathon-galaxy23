//
//  HomeViewModel.swift
//  Emotilt
//
//  Created by 최유림 on 2023/02/24.
//

import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var peersCount: Int = 0
        @Published var didReceiveMessage: Bool = false
        
        var canFindPeers: Bool {
            peersCount != 0
        }
        
        func sendMessage(_ message: Message) {
            // send message
        }
        
        // TODO: implement others
    }
}
