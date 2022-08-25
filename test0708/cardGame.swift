//
//  cardGame.swift
//  test0708
//
//  Created by khg on 2022/08/19.
//

import SwiftUI
import Foundation

struct cardGame: View {
    
    
    @State private var colorAry = [Color.purple,Color.green,Color.blue,Color.orange,Color.black,Color.orange,
                                   Color.blue,Color.gray,Color.purple,Color.green,Color.gray,Color.black]
    @State private var selectedColorAry:[Color] = []
    @State private var isShuffle = true
    @State private var selectedColor = Color.white
    @State private var maxNum = 11
    @State private var firstCard = Color.white
    @State private var secondCard = Color.white
    @State private var forCheck = false
    @State private var count = 0
    @State private var isSecondCard = false
    
    let columns = [GridItem(),GridItem(),GridItem()]
    
    var body: some View {
        VStack{
            
            Text("점수는 = \(count)")
                .font(.title)
            
            LazyVGrid(columns: columns) {
                ForEach(0...maxNum,id:\.self) { num in
                    if selectedColorAry.contains(colorAry[num])  {
                        cardFlip(cardColor: $colorAry[num],isShuffle: $isShuffle,selectedColor: $selectedColor,forCheck:$forCheck)
                            .hidden()
                    }else{
                        cardFlip(cardColor: $colorAry[num],isShuffle: $isShuffle,selectedColor: $selectedColor,forCheck:$forCheck)
                    }
                    
                }
            }
            Button {
                count = 0
                isShuffle = true
                selectedColorAry = []
                secondCard = .white
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    colorAry.shuffle()
                }
            } label: {
                Text("카드 재정렬")
                    .padding(.top,20)
            }
        }.onChange(of: forCheck) { newValue in
            if !isSecondCard {
                isSecondCard = true
                firstCard = selectedColor
            }else {
                isSecondCard = false
                secondCard = selectedColor
                if firstCard == secondCard {
                    count += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        HapticManager.manager.notification(type: .success)
                        selectedColorAry.append(selectedColor)
                    }
                }else{
                    count -= 1
                    secondCard = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(450)) {
                        isShuffle = true
                    }
                }
            }
            
            print("1 = \(firstCard), 2 = \(secondCard), issecond = \(isSecondCard)")
        }
        .animation(.easeInOut(duration: 1.0), value: selectedColorAry)
    }
}



