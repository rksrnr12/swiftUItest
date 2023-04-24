//
//  DropGridViewModel.swift
//  test0708
//
//  Created by khg on 2023/03/17.
//

import Foundation
import SwiftUI

class DropGridViewModel: ObservableObject {
    @Published var gridItems:[Grid] = [Grid(gridText: "달력"),Grid(gridText: "제스쳐테스트"),Grid(gridText: "지도"),Grid(gridText: "카드게임"),Grid(gridText: "URL"),Grid(gridText: "햅틱"),Grid(gridText: "애니메이션"),Grid(gridText: "게이지테스트"),Grid(gridText: "아일랜드")]
    
    @Published var currentGrid:Grid?
}

struct Grid: Identifiable,Codable {
    var id = UUID()
    var gridText:String = ""
    var number:Double = .random(in: 0...1)
    var number2:Double = .random(in: 0...1)
    var number3:Double = .random(in: 0...1)
}

struct DropViewDelegate: DropDelegate {
    
    @AppStorage("arrayData") var arrayData:Data?
    var gird: Grid
    var gridData: DropGridViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        
        let fromIndex = gridData.gridItems.firstIndex {
            $0.id == gridData.currentGrid?.id
        } ?? 0
        
        let toIndex = gridData.gridItems.firstIndex {
            $0.id == self.gird.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation {
                let fromGrid = gridData.gridItems[fromIndex]
                gridData.gridItems[fromIndex] = gridData.gridItems[toIndex]
                gridData.gridItems[toIndex] = fromGrid
                guard let data = try? JSONEncoder().encode(gridData.gridItems) else { return }
                arrayData = data
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
