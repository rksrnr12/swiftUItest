//
//  testModel.swift
//  test0708
//
//  Created by khg on 12/5/24.
//

import Foundation
import SwiftUI

@MainActor
final class CoreViewModel:ObservableObject {
    
    //초기선언 후 수정하면 동기화 됨
    @AppStorage("myDayOff") var test = 20.0
    @Published var naviStack = NavigationPath()
    
}
