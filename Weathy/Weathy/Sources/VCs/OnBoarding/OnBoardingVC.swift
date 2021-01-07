//
//  OnBoardingVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/07.
//

import UIKit

class OnBoardingVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isPagingEnabled = true
        viewcontrollerSetting()
    }
    


    /// Tabbar를 통한 화면 전환
    func viewcontrollerSetting(){
       self.scrollView.contentSize.width = self.view.frame.width * 3
       
        /// ExampleFirstVC 생성
        guard let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "firstViewController") as? firstViewController else { return }
        /// ExampleFirstVC를 Child View Controller로 지정
        self.addChild(firstVC)
       
        /// ExampleFirstVC의 View만 가져오기
        guard let firstView = firstVC.view else { return }
       
        /// ExampleFirstVC View의 Frame 지정
        firstView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
       
        /// Scroll View에 ExampleFirstVC의 View 넣기
        self.scrollView.addSubview(firstView)
       
        /// 이제 leftVC가 Container View Controller 앞으로 올라왔기 때문에 didmove(toParent:)를 실행
        firstVC.didMove(toParent: self)
        
        /// ExampleThirdVC도 동일.
        guard let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "secondViewController") as? secondViewController else { return }
        self.addChild(secondVC)
        guard let secondView = secondVC.view else { return }
        secondView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(secondView)
        secondVC.didMove(toParent: self)
        
        
        /// ExampleThirdVC도 동일.
        guard let ThirdVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else { return }
        self.addChild(ThirdVC)
        guard let ThirdView = ThirdVC.view else { return }
        ThirdView.frame = CGRect(x: self.view.frame.width*2, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(ThirdView)
        ThirdVC.didMove(toParent: self)
        
   }
}
