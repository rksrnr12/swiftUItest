//
//  testView2.swift
//  test0708
//
//  Created by khg on 2023/03/15.
//

import SwiftUI

struct testView2: View {
    
    @State private var selection = 1
    @Namespace private var sale
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators:false) {
            HStack(spacing:0) {
                ForEach(1...5,id: \.self) { num in
                    Button {
                        withAnimation {
                            selection = num
                        }
                    } label: {
                        
                        if num == 3 {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 2, height: 50)
                        }else {
                            Rectangle()
                                .frame(width: 2, height: 50)
                                .hidden()
                        }
                        
                        VStack(spacing:-2) {
                            
                            if num == 3 {
                                Text("1234")
                            }else {
                                Text("1234").hidden()
                            }
//                            ZStack(alignment:.leading) {
                                Text("\(num)")
                                    .padding(.all,50)
                                    .background(Color.green)
                                
//                                if num == 3 {
//                                    Rectangle()
//                                        .fill(Color.white)
//                                        .frame(width: 2, height: 50)
//                                }
//                            }
                            
                            if selection == num {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.green)
                                    .matchedGeometryEffect(id: "report", in: sale)
                            }else {
                                Image(systemName: "arrowtriangle.down.fill").hidden()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct testView2_Previews: PreviewProvider {
    static var previews: some View {
        testView2()
    }
}
