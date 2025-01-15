//
//  memoTest.swift
//  test0708
//
//  Created by khg on 6/24/24.
//

import SwiftUI

struct memoTest: View {
    
    @State private var test = ""
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            TextEditor(text: $test)
            Button("test") {
                makeLabel()
            }
        }
        
    }
    
    func makeLabel() {
        let word = "하이"
        let leadingIcon = UIImage.add
        
        let attributeString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment(image: leadingIcon)
        imageAttachment.bounds = .init(x: 0, y: -1, width: 14, height: 14)
        attributeString.append(NSAttributedString(attachment: imageAttachment))
        attributeString.append(NSAttributedString(string: word))
        
        test = attributeString.string
        
    }
}

#Preview {
    memoTest()
}
