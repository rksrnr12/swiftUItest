//
//  NotificationView.swift
//  WatchTest0708 Watch App
//
//  Created by khg on 2023/05/03.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
            Text("Hello, World!")
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
