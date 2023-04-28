//
//  custom.swift
//  test0708
//
//  Created by khg on 2023/04/27.
//

import Foundation
import SwiftUI

struct PushButtonStyle: ButtonStyle {
    var isBool = false
    func makeBody(configuration: Configuration) -> some View {
        let num = isBool ? 1.1 : 0.9
        configuration.label
            .scaleEffect(configuration.isPressed ? num : 1)
            .animation(.easeInOut.speed(2), value: configuration.isPressed)
    }
}

struct ColorButtonStyle: ButtonStyle {
    var bgColor:Color = .black
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical,18)
            .background(bgColor)
    }
}

extension ButtonStyle where Self == PushButtonStyle {
    
    internal static var pushAnimation: PushButtonStyle { return PushButtonStyle()}
}

extension ButtonStyle where Self == ColorButtonStyle {
    
    internal static var greenButton:ColorButtonStyle {return ColorButtonStyle(bgColor: .green)}
    internal static var grayButton:ColorButtonStyle {return ColorButtonStyle(bgColor: .gray)}
}



extension View {
    
    func customAlert<Content:View>(isPresented:Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .fullScreenCover(isPresented: isPresented) {
                VStack {
                    content()
                }.frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).ignoresSafeArea())
                    .presentationBackground(Color.clear)
            }
    }
}

struct PresentationPopupView: View{
    
    @Environment(\.presentationMode) private var presentationMode
    
    var boldTitle:Text
    var mainText:Text
    var noTitle:String = "아니요"
    var yesTitle:String = "네"
    var hideNoButton:Bool = false
    var action:@MainActor () -> ()
    
    
    var body: some View {
        VStack(spacing:0) {
            VStack(spacing:10) {
                if Text("") != boldTitle  {
                    boldTitle
                }
                mainText
            }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical,40)
                .background(Color.white)
            HStack(spacing:0) {
                if !hideNoButton {
                    Button(noTitle) {
                        presentationMode.wrappedValue.dismiss()
                    }//.buttonStyle(.grayButton)
                }
                Button(yesTitle) {
                    presentationMode.wrappedValue.dismiss()
                    action()
                }//.buttonStyle(.greenButton)
                
            }
            
        }.cornerRadius(10)
            .padding(.horizontal,20)
    }
}

extension PresentationPopupView {
    init(test1:String,test2:String,action: @escaping () -> ()) {
        boldTitle = Text(test1)
        mainText = Text(test2)
        self.action = action
    }
    
    init(test12:Text,test21:Text,action: @escaping () -> ()) {
        boldTitle = test12
        mainText = test21
        self.action = action
    }
}
