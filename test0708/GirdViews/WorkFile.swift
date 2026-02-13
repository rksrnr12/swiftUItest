//
//  WorkFile.swift
//  test0708
//
//  Created by khg on 4/2/25.
//

import Foundation
import SwiftUI

struct TodayWork:Codable,Identifiable,Equatable {
    
    var steps = ""
    var totalPrice:Int = 0
    var savedDate = Date()
    var workList:[WorkType:Int] = [:]
    
    var id = UUID()
    
}

enum WorkType:String,CaseIterable,Identifiable,Codable {
    case toss = "토스"
    case kakaoBank = "카카오뱅크"
    case kBank = "케이뱅크"
    case naverPay = "네이버페이"
    case shinhanSol = "신한쏠"
    case shinhanCard = "신한카드"
    case kakaoPay = "카카오페이"
    case hanaCard = "하나카드"
    case wooriWon = "우리원"
    case cashWalk = "캐시워크"
    case hanaMoney = "하나머니"
    case seoul9988 = "손목닥터9988"
    case payBooc = "페이북"
    case IBK = "IBK"
    case olacker = "오락"
    case okCashBag = "OK캐시백"
    case NHAllOne = "NH올원뱅크"
    case Karrot = "당근마켓"
    case tmoneyGo = "티머니고"
    case tmoneyPay = "모바일티머니"
    case none = ""
        
    var id: String { rawValue }
    
    var scheme:String {
        switch self {
        case .toss:
            "supertoss://"
        case .kakaoBank:
            "kakaobank://"
        case .kBank:
            "ukbanksmartbankweb://"
        case .naverPay:
            //shortcuts://run-shortcut?name=[이름]&input=[입력]&text=[텍스트]
            //"shortcuts://run-shortcut?name=네이버페이"
            "naverpayapp://"
        case .shinhanSol:
            "smailapp://"
        case .shinhanCard:
            "shinhan-sr-ansimclick://"
        case .kakaoPay:
            "kakaopay://"
        case .hanaCard:
//            "shortcuts://run-shortcut?name=하나카드"
            "cloudpay://"
        case .wooriWon:
            "wooribank://"
        case .cashWalk:
            "cashwalkapp://"
        case .hanaMoney:
            "hanawalletmembers://"
        case .seoul9988:
            "shortcuts://run-shortcut?name=손목닥터"
        case .payBooc:
            "ispmobile://"
        case .IBK:
//            "shortcuts://run-shortcut?name=ibk"
            "ibkcard://"
        case .olacker:
            "olocker://"
        case .okCashBag:
            "ocbtapp://"
        case .NHAllOne:
            "shortcuts://run-shortcut?name=nh"
        case .Karrot:
            "Karrot://"
        case .tmoneyGo:
            "tmoneytia://"
        case .tmoneyPay:
            "tmoneypay://"
        default:
            ""
        }
    }
    
    static let attendanceList:[WorkType] = [.kBank,.naverPay,.shinhanSol,.shinhanCard,.hanaCard,.wooriWon,.payBooc,.IBK,.okCashBag,.tmoneyGo,.tmoneyPay]
    static let pedometerList:[WorkType] = [.toss,.kakaoBank,.kakaoPay,.hanaMoney,.cashWalk,.seoul9988,.olacker,.NHAllOne,.Karrot]
    
}

final class CustomNumberFormatter: NumberFormatter, @unchecked Sendable {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        
        let number = string.components(separatedBy: ",").joined()
        
        if number.isEmpty {
            obj?.pointee = NSNumber(value: 0)
            return
        }
        
        // 숫자 파싱
        if let doubleValue = Double(number) {
            if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                obj?.pointee = NSNumber(value: Int(doubleValue))  // 정수 처리
            } else {
                obj?.pointee = NSNumber(value: doubleValue)       // 실수 처리
            }
        } else {
            obj?.pointee = NSNumber(value: 0) // 잘못된 입력도 0 처리
        }
    }
}

