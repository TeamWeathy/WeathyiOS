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
        animationView.animation = Animation.named("스플래시")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.8, height: view.frame.width*0.8)
        animationView.contentMode = .scaleAspectFit
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.play()
        self.view.addSubview(animationView)
    }
}
