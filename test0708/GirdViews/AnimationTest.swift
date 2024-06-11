//
//  AnimationTest.swift
//  test0708
//
//  Created by khg on 2022/09/07.
//

import Foundation
import SwiftUI
import Combine

struct AnimationTest: View {
    
    @Namespace var test
    @StateObject private var viewModel = testModel()
    
    var body: some View {
        VStack(alignment:.center){
            if viewModel.isDetail {
                imageBtn(size: 300)
                Spacer()
                
            }else {
                imageBtn(size: 150)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(viewModel.isDetail ? Color.gray : Color.black)
    }
    
    func imageBtn(size:CGFloat) -> some View {
        
        Button {
            withAnimation(.spring(response: 0.7,dampingFraction: 0.7,blendDuration: 1.0)) {
                withAnimation(.spring(response: 0.7,dampingFraction: 0.7,blendDuration: 1.0)) {
                    viewModel.test = true
                    viewModel.isDetail.toggle()
                }
            }
        } label: {
            Image("dog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .matchedGeometryEffect(id: "test", in: test)
                .frame(width: size)
                .padding()
            
        }
        .buttonStyle(PushButtonStyle(isBool: viewModel.isDetail))
        .disabled(viewModel.test)
        
        
    }
    
    
    
}

@MainActor
final class testModel:ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var isDetail = false
    @Published var test = false
    
    public init() {
        //RunLoop = UI업데이트(스크롤) 끝나고 실행
        //DisPatchQueue = UI업데이트와 동시에 실행
        //debounce - 자동완성에서 주로 사용,구독한 값이 변경 시 특정시간 이후에 실행
//        $isDetail.debounce(for: 2, scheduler: DispatchQueue.main).sink { [weak self] value in
//            guard let self = self else {return}
//            self.test = false
//        }.store(in: &cancellables)
        
        //throttle - 버튼 중복 방지에서 주로 사용 - 구독한 값이 변경 시 특정시간 동안 받은 입력은 무시됨,letest ? 마지막 입력이 적용됨 : 맨처음 입력만 적용됨
        $isDetail.throttle(for: 2, scheduler: DispatchQueue.main, latest: false).sink { [weak self] value in
            guard let self = self else {return}
            self.test = false
        }.store(in: &cancellables)
    }
}
