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
    
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let width : CGFloat = 100
    let height : CGFloat = 125
    let durationAndDelay : CGFloat = 0.3
    
    func flipCard() {
        isFlipped.toggle()
        if isFlipped {
            isShuffle = false
            selectedColor = cardColor
            withAnimation(.linear(duration: durationAndDelay).speed(2)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay).speed(2)) {
                frontDegree = 0
            }
        }else{
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
            flipCard()
            forCheck.toggle()
        } label: {
            ZStack{
                cardFront()
                cardBack()
            }
        }.onChange(of: isShuffle) { newValue in
            if newValue == true && isFlipped == true {
                flipCard()
            }
        }
    }
    
    @ViewBuilder
    func cardFront() -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
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
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
            Image(systemName: "suit.club.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
        }.rotation3DEffect(Angle.degrees(backDegree), axis: (x:0, y: 1, z: 0))
    }
    
}

//struct cardFront:View {
//
//    let width : CGFloat
//    let height : CGFloat
//    @Binding var degree : Double
//
//    var body: some View{
//        ZStack{
//            RoundedRectangle(cornerRadius: 20)
//                .fill(.white)
//                .frame(width: width, height: height)
//                .shadow(color: .gray, radius: 2, x: 0, y: 0)
//            Image(systemName: "suit.club.fill")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .foregroundColor(cardColor)
//        }.rotation3DEffect(Angle.degrees(degree), axis: (x:0, y: 1, z: 0))
//    }
//}

//struct cardBack:View {
//    
//    let width : CGFloat
//    let height : CGFloat
//    @Binding var degree : Double
//    
//    var body: some View{
//        ZStack{
//            RoundedRectangle(cornerRadius: 20)
//                .fill(.gray)
//                .frame(width: width, height: height)
//                .shadow(color: .gray, radius: 2, x: 0, y: 0)
//            Image(systemName: "suit.club.fill")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .foregroundColor(.red)
//        }.rotation3DEffect(Angle.degrees(degree), axis: (x:0, y: 1, z: 0))
//    }
//}

//struct cardFlip_Previews: PreviewProvider {
//    static var previews: some View {
//        cardFlip()
//    }
//}
