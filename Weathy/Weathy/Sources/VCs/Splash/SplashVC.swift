//
//  SplashVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/13.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displaySplash()
    }
    
    func displaySplash() {
        animationView.animation = Animation.named("스플래시.json")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }

}
