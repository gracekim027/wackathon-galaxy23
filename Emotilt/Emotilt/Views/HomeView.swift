//
//  HomeView.swift
//  Emotilt
//
//  Created by 최유림 on 2023/02/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var isReadyForSending: Bool = false
    @State private var isEmojiSheetOpen: Bool = false
    @State private var emoji: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24)
            
            Group {
                Text("내 주변 5m 이내에 ") +
                Text("\(viewModel.peersCount)").bold() +
                Text("명의 유저가 있습니다")
            }
            .font(.system(size: 15))
            
            Spacer()
            
            Group {
                Button {
                    isEmojiSheetOpen = true
                } label: {
                    ZStack {
                        if emoji.isEmpty {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.tertiary.opacity(0.4))
                                .frame(width: 168, height: 168)
                        }
                        
                        Text(emoji)
                            .font(.system(size: 168))
                    }
                }
                
                Spacer().frame(height: 24)
                
                TextField("", text: $content, prompt: Text("20자 이내"))
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }
            .disabled(isReadyForSending)
            
            Spacer()
            
            RoundedButton(label: isReadyForSending
                          ? "I'm Ready"
                          : "Ready") {
                isReadyForSending = true
            }
            .disabled(!viewModel.canFindPeers || !isReadyForSending)
            
            Spacer().frame(height: 16)
        }
        .padding(.horizontal, 36)
        .sheet(isPresented: $isEmojiSheetOpen) {
            EmojiSheet(selected: $emoji)
        }
        .sheet(isPresented: $viewModel.didReceiveMessage) {
            // MessagePopupView(message: viewModel.receivedMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
            .tint(.black)
    }
}
