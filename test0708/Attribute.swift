//
//  Attribute.swift
//  test0708
//
//  Created by khg on 2022/10/07.
//

import SwiftUI
import ActivityKit


struct Attributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var testname:String
        var testnum:Int
    }
    
    var number:Int
    var total: String
}
