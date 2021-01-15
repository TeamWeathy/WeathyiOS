//
//  Emoji.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/14.
//

import Foundation
import UIKit

struct Emoji{
    static let veryHot: Int = 1
    static let hot = 2
    static let good = 3
    static let cold = 4
    static let veryCold = 5
    
    static func getEmojiImageAsset(stampId: Int) -> String {
        switch (stampId) {
        case Emoji.veryHot:
            return "veryhot"
        case Emoji.hot:
            return "hot"
        case Emoji.good:
            return "good"
        case Emoji.cold:
            return "cold"
        case Emoji.veryCold:
            return "verycold"
        default:
            return "hot"
        }
    }
    
    static func getEmojiText(stampId: Int) -> String {
        switch (stampId) {
        case Emoji.veryHot:
            return "너무 더웠어요"
        case Emoji.hot:
            return "더웠어요"
        case Emoji.good:
            return "적당했어요"
        case Emoji.cold:
            return "추웠어요"
        case Emoji.veryCold:
            return "너무 추웠어요"
        default:
            return ""
        }
    }

    static func getEmojiTextColor(stampId: Int) -> UIColor {
        switch (stampId) {
        case Emoji.veryHot:
            return UIColor.imojiVeryHotText
        case Emoji.hot:
            return UIColor.imojiHotText
        case Emoji.good:
            return UIColor.imojiGootText
        case Emoji.cold:
            return UIColor.imojiColdText
        case Emoji.veryCold:
            return UIColor.imojiVeryColdText
        default:
            return UIColor.imojiGootText
        }
    }
}
