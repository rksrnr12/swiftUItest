//
//  ContentView.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isShowingSheet = false
    
    
    var body: some View {
        
        ScrollView{
            VStack(spacing:20){
                Button("Show sheet", action: {
                    isShowingSheet.toggle()
                })
                .sheet(isPresented: $isShowingSheet, content: {
                    ViewOne(showParentSheet: $isShowingSheet)
                })
                NavigationLink("barChart") {
                    BarChart()
                }
                NavigationLink("calendar") {
                    calendar()
                }
                NavigationLink("tabView") {
                    tabVIew()
                }
                NavigationLink("floationgButton") {
                    floatingButton()
                }
                NavigationLink("datePicker") {
                    datePicker()
                }
                NavigationLink("MapTest") {
                    MapTest()
                }
//                NavigationLink("cardFlip") {
//                    cardFlip(cardColor: .constant(.blue),isShuffle:.constant(false),selectedColor: .constant(.white),)
//                }
                NavigationLink("cardGame") {
                    cardGame()
                }
                NavigationLink("URLTest") {
                    URLTest()
                }
            }
        }.onOpenURL { url in
            isShowingSheet = true
        }
    }
}

struct ViewOne: View {
    @Binding var showParentSheet : Bool
    
    var body: some View {
        NavigationView {
            NavigationLink("Go to ViewTwo", destination: ViewTwo(showParentSheet: $showParentSheet))
            //.isDetailLink(false)
        }
    }
}

struct ViewTwo: View {
    @Binding var showParentSheet : Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button("Dismiss sheet here") {
            showParentSheet = false
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
