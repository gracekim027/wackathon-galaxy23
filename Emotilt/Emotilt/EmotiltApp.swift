//
//  EmotiltApp.swift
//  Emotilt
//
//  Created by peng on 2023/02/23.
//

import SwiftUI

@main
struct EmotiltApp: App {
    
    init() {
        // MARK: initialization
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: .init())
        }
    }
}
