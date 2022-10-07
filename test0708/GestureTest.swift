//
//  GestureTest.swift
//  test0708
//
//  Created by khg on 2022/09/08.
//

import SwiftUI

struct GestureTest: View {
    
    @State private var testCase:testEnum = .one
    @State private var testBool = false
    @Namespace var pagingAnimation
    @Namespace var pagingView
    
    enum testEnum:String,CaseIterable {
        case one = "1"
        case two = "2"
        case three = "3"
    }
    
    var body: some View {
        VStack{
            HStack(spacing:0){
                pagingButton(title: "1", status: .one) {
                    testBool = false
                    testCase = .one
                }
                pagingButton(title: "2", status: .two) {
                    testCase = .two
                }
                pagingButton(title: "3", status: .three) {
                    testBool = true
                    testCase = .three
                }
                Spacer()
            }
            ScrollView{
                switch testCase {
                case .one:
                    cardGame()
                        .frame(maxWidth:.infinity ,maxHeight:.infinity)

//                        .transition(.move(edge: .leading))
                case .two:
                    URLTest()
                        .frame(maxWidth:.infinity ,maxHeight:.infinity)
//                        .transition(.asymmetric(insertion: .move(edge: testBool ? .leading : .trailing), removal: .move(edge: testBool ? .trailing : .leading)))
                case .three:
                    AnimationTest()
                        .frame(maxWidth:.infinity ,maxHeight:.infinity)
//                        .transition(.move(edge: .trailing))
                }
            }
        }.animation(.easeInOut(duration: 0.3), value: testCase)
    }
    
    
    
    @ViewBuilder
    func pagingButton(title:String,status:testEnum,action: @escaping () -> Void) -> some View{
        Button {
            action()
        } label: {
            Text(title)
                .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                .foregroundColor(testCase == status ? .green : .gray)
                .overlay(alignment: .bottom, content: {
                    VStack{
                        if testCase == status {
                            Divider()
                                .background(.green)
                                .matchedGeometryEffect(id: "pagingAnimation", in: pagingAnimation)
                        }
                    }
                })
        }
    }
}
