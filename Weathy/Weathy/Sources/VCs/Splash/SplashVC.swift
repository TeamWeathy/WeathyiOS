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
    
    override func viewDidAppear(_ animated: Bool) {
        displaySplash()
    }
    
    @objc func nextView() {
        
        //FIXME: - 테스트 후 주석 제거
        
//        if UserDefaults.standard.integer(forKey: "userId") != 0{
//            let nextStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
//            LoginService.shared.postLogin(uuid: UserDefaults.standard.string(forKey: "UUID") ?? ""){ (networkResult) -> (Void) in
//                switch networkResult{
//                    case .success(let data):
//                        if let loginData = data as? UserData{
//                            print("Token is renewed")
//                            UserDefaults.standard.setValue(loginData.token, forKey: "token")
//                        }
//                    case .requestErr(let message):
//                        print("[Login] requestErr", message)
//                    case .pathErr:
//                        print("[Login] pathErr")
//                    case .serverErr:
//                        print("[Login] serverErr")
//                    case .networkFail:
//                        print("[Login] networkFail")
//                }
//            }
//            UIView.animate(withDuration: 0.2,animations: {self.animationView.alpha = 0},completion:{ _ in
//        let nextStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
//        if let dvc = nextStoryboard.instantiateViewController(identifier: "TabbarVC") as TabbarVC? {
//            dvc.modalTransitionStyle = .crossDissolve
//            dvc.modalPresentationStyle = .overCurrentContext
//            self.present(dvc,animated: true)}
//    })
//        }
//        else{
//            UIView.animate(withDuration: 0.2,animations: {self.animationView.alpha = 0},completion:{ _ in
//        let nextStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
//        if let dvc = nextStoryboard.instantiateViewController(identifier: "OnBoardingVC") as UIViewController? {
//            dvc.modalTransitionStyle = .crossDissolve
//            dvc.modalPresentationStyle = .overCurrentContext
//            self.present(dvc,animated: true)}
//    })
//        }
        
        //FIXME: - 테스트 후 코드 제거
        
        ///무조건 스플래시 재생 후 온보딩을 띄우도록 함
        UIView.animate(withDuration: 0.3,animations: {self.animationView.alpha = 0},completion:{ _ in
            let nextStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            if let dvc = nextStoryboard.instantiateViewController(identifier: "OnBoardingVC") as UIViewController? {
                dvc.modalTransitionStyle = .crossDissolve
                dvc.modalPresentationStyle = .overCurrentContext
                self.present(dvc,animated: true)}

        })
        
    }
    
    func displaySplash() {
        animationView.animation = Animation.named("스플래시")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.8, height: view.frame.width*0.8)
        animationView.contentMode = .scaleAspectFit
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.play()
        self.view.addSubview(animationView)
        
        Timer.scheduledTimer(timeInterval: 2.9, target: self, selector: #selector(self.nextView), userInfo: nil, repeats: false)
    }
}
