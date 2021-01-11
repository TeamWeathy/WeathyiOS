//
//  CoverView.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/12.
//

//import UIKit
//
//class CoverView: UIView {
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        // 원래 hitTest 메서드로 현재 터치된 곳에서 가장 위에 올라와 있는 view를 가져옴
//        // 여기서는 cover view
//        var hitView = super.hitTest(point, with: event)
//        
//        // 특정 영역에서만 이벤트를 받도록 함
//        let touchRect = CGRect(x: 294, y: 277, width: 48, height: 48)
//        
//        // 해당 영역에서 발생한 touch에 대해 통과시킴
//        if touchRect.contains(point) {
//            hitView = nil
//        }
//        return hitView
//    }
//}
