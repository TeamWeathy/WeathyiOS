//
//  Emoji.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/14.
//

import UIKit

struct Emoji {
    static let veryHot: Int = 1
    static let hot = 2
    static let good = 3
    static let cold = 4
    static let veryCold = 5
    
    static func getEmojiImageAsset(stampId: Int) -> String {
        switch (stampId) {
        case Emoji.veryHot:
            return "veryHot"
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
            return "좋았어요"
        case Emoji.cold:
            return "추웠어요"
        case Emoji.veryCold:
            return "엄청 추웠어요"
        default:
            return "모르겠어요"
        }
    }

    static func getEmojiTextColor(stampId: Int) -> UIColor {
        switch (stampId) {
        case Emoji.veryHot:
            return UIColor.imojiVeryHot
        case Emoji.hot:
            return UIColor.imojiHot
        case Emoji.good:
            return UIColor.imojiGood
        case Emoji.cold:
            return UIColor.imojiCold
        case Emoji.veryCold:
            return UIColor.imojiVeryCold
        default:
            return UIColor.imojiGood
        }
    }
}

