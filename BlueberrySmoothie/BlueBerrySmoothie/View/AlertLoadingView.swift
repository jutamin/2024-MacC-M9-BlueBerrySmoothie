//
//  AlertLoadingView.swift
//  BlueberrySmoothie
//
//  Created by 원주연 on 11/22/24.
//

import SwiftUI

struct AlertLoadingView: View {
    @State private var dotCount: Int = 1 // 현재 점 개수
    private let maxDots: Int = 3 // 최대 점 개수
    private let animationInterval: TimeInterval = 0.4 // 애니메이션 간격 (초)
    
    var body: some View {
        ZStack{
            Color.gray6DGray1 // 배경 색
                .edgesIgnoringSafeArea(.all) // 화면 전체 배경 적용
            
            VStack(spacing: 4) {
                Image("AlertLoadingView")
                HStack(spacing:2) {
                    Text("버스 노선을 불러오고 있어요")
                    Text(String(repeating: ".", count: dotCount))
                        .animation(.easeInOut(duration: animationInterval), value: dotCount)
                        .onAppear {
                            startDotAnimation()
                        }
                }.font(.body2)
                    .foregroundStyle(.gray1)
            }.padding(.top, -100)
        }
    }
    
    private func startDotAnimation() {
        // SwiftUI 타이머 스타일 애니메이션 구현
        Task {
            while true {
                try? await Task.sleep(nanoseconds: UInt64(animationInterval * 1_000_000_000))
                dotCount = (dotCount % maxDots) + 1 // 1 → 2 → 3 → 1 순환
            }
        }
    }
}

#Preview {
    AlertLoadingView()
}

