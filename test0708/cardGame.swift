//
//  cardGame.swift
//  test0708
//
//  Created by khg on 2022/08/19.
//

import SwiftUI
import Foundation

struct cardGame: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var colorAry = [Color.purple,Color.green,Color.blue,Color.orange,Color.black,Color.orange,
                                   Color.blue,Color.gray,Color.purple,Color.green,Color.gray,Color.black]
    @State private var isShuffle = true
    @State private var selectedColor = Color.white
    @State private var maxNum = 11
    
    
    let columns = [GridItem(),GridItem(),GridItem()]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns) {
                ForEach(0...maxNum,id:\.self) { num in
                    cardFlip(cardColor: $colorAry[num],isShuffle: $isShuffle,selectedColor: $selectedColor)
                }
            }
            Button {
                isShuffle = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    colorAry.shuffle()
                }
            } label: {
                Text("카드 재정렬")
                    .padding(.top,20)
            }
            
            Text("지도")
                .onTapGesture {
                    openURL(URL(string: "map:")!)
                }
            
        }
    }
}



