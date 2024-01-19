//
//  cardFlip.swift
//  test0708
//
//  Created by khg on 2022/08/18.
//

import SwiftUI

struct cardFlip: View {
    
    @Binding var cardColor:Color
    @Binding var isShuffle:Bool
    @Binding var selectedColor:Color
    @Binding var forCheck:Bool
    @Binding var isThirdCard:Bool
    
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let width : CGFloat = 100
    let height : CGFloat = 125
    let durationAndDelay : CGFloat = 0.3
    
    func flipCard() {
        isFlipped.toggle()
        if isFlipped {
            print("1")
            isShuffle = false
            selectedColor = cardColor
            withAnimation(.linear(duration: durationAndDelay).speed(2)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay).speed(2)) {
                frontDegree = 0
            }
        }else{
            print("2")
            withAnimation(.linear(duration: durationAndDelay).speed(2)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay).speed(2)){
                backDegree = 0
            }
        }
    }
      
    var body: some View {
        Button {
            if isThirdCard || isFlipped{
                HapticManager.manager.notification(type: .error)
            }else{
                flipCard()
                forCheck.toggle()
            }
        } label: {
            ZStack{
                cardFront()
                cardBack()
            }
        }
        .onChange(of: isShuffle, { oldValue, newValue in
            if newValue == true && isFlipped == true {
                flipCard()
            }
        })
        .buttonStyle(.pushAnimation)
    }
    
    @ViewBuilder
    func cardFront() -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: width, height: height)
                .shadow(color: .black, radius: 2, x: 2, y: 2)
            Image(systemName: "suit.club.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(cardColor)
        }.rotation3DEffect(Angle.degrees(frontDegree), axis: (x:0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func cardBack() -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
                .frame(width: width, height: height)
                .shadow(color: .black, radius: 2, x: 2, y: 2)
            Image(systemName: "suit.club.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
        }.rotation3DEffect(Angle.degrees(backDegree), axis: (x:0, y: 1, z: 0))
    }
    
}

