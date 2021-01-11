//
//  UIViewController+Extensions.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/07.
//

import UIKit

extension UIViewController {
    
    /// 뒤 배경에 그라데이션을 넣기 위한 메소드
    func setGradientView(){
        var gradientLayer: CAGradientLayer!
        
        /// View 생성
        let gradientView = UIView()
        self.view.addSubview(gradientView)

        /// View에 대한 size를 정의 해줘야만 가능!!
        gradientView.frame.size = .init(width: self.view.frame.width, height: 54)
        gradientView.backgroundColor = UIColor.clear

        /// View에 그라데이션 추가
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.white.cgColor]
        gradientView.layer.addSublayer(gradientLayer)

        /// grandientView 레이아웃 잡기
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        /// grandientView size 설정
        gradientView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        gradientView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true


        /// gradient 위에서 아래로 주기
        gradientLayer.locations = [0.43, 0.57]

        ///gradient를 가로로 만들어주는 시작점과 끝점 포인트
//        self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
