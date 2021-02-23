//
//  WeathyLoadingView.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/23.
//

import UIKit
import Lottie

class WeathyLoadingView: UIView{
    let screen = UIScreen.main.bounds
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLoadingView()
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return background
    }()
    var animationView: AnimationView = {
        let aniView = AnimationView()
        aniView.animation = Animation.named("스플래시")
        aniView.contentMode = .scaleAspectFit
        aniView.loopMode = .loop
        aniView.play()
        return aniView
    }()
    
    func setLoadingView(){
        backgroundView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        self.addSubview(backgroundView)
        
        animationView.frame = CGRect(x: 0, y: 0, width: screen.width*0.5, height: screen.width*0.5)
        animationView.center = self.center
        backgroundView.addSubview(animationView)
        
    }
    
}
