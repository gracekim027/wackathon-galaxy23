//
//  HomeView.swift
//  Emotilt
//
//  Created by 최유림 on 2023/02/23.
//

import SwiftUI
import CoreMotion
import ConfettiSwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    
    let motionManager = CMMotionManager()
    @State private var sendTimer : Timer?
    @State private var isReadyForSending: Bool = false
    @State private var didSend : Bool = false
    /*{
        didSet{
            if (didSend){
                sendingSuccess += 1
            }
            tmpdidSend = didSend
        }
    }*/
    
    @State private var tmpdidSend : Bool = false
    @State private var sendingSuccess : Int = 0
    @State private var isEmojiSheetOpen: Bool = false
    @State private var emoji: String = ""
    @State private var content: String = ""
    @State private var counter: Int = 0

    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24)
            
            Group {
                Text("내 주변 5m 이내에 ") +
                Text("\(viewModel.peersCount)").bold() +
                Text("명의 유저가 있습니다")
            }
            .font(.system(size: 15))
            
            Spacer().frame(height: 24)
            
            if (isReadyForSending && !didSend){
                //카운터 라벨 
                Text("\(counter)")
                    .font(.system(size: 40, weight: .bold))
            }else if(didSend){
                Text("보내기 성공!")
                .font(.system(size: 20, weight: .bold))
                .confettiCannon(counter: $sendingSuccess, openingAngle: .degrees(180), closingAngle: .degrees(360))
            }
            
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
                detectUpwardAcceleration()
            }
            //.disabled(!viewModel.canFindPeers || !isReadyForSending)
            
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

extension HomeView {
    func detectUpwardAcceleration(){
        var detected = false
        
        //이 부분을 장전 터치시 넣으면 됨.
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(motion, error) in
            //여기 민감도 바꾸면 됨. 테스트해보니 0.3 ~ 0.4 적당 (0.3 이 더 예민)
            if ((motion?.acceleration.x)! > 0.4){
                detected = true
                //TODO: NSSession 에서 내용 보내기
                print("[Log] 모션 감지가 되어 세션 종료")
                didSend = true
            }
        })
        
        //타이머 초기화
        if (self.counter == 0){
            self.counter = 5
        }
        
        self.sendTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            
            if (self.counter > 0){
                self.counter -= 1
            }
            
            if (self.counter == 0){
                stopTimer()
                didSend = true //애니메이션 테스트를 위해 넣음
                
                if (!detected){
                    //레이블 초기화
                    self.content  = ""
                    emoji = ""
                    isReadyForSending = false
                    print("[Log] 모션 감지가 안되어서 보내기 세션 종료")
                }
            }
        }
    }
    
    func stopTimer(){
        self.sendTimer?.invalidate()
        self.sendTimer = nil
    }
}
