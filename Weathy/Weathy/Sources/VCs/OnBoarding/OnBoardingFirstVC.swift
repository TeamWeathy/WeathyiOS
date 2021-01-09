//
//  OnBoardingFirstVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/07.
//

import UIKit

class OnBoardingFirstVC: UIViewController {
    
    //MARK: - Custom Variables
    var currentPage = 1
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet var gestureStart: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneImage.alpha = 0
        firstImage.alpha = 0
        secondImage.isHidden = true
        secondImage.alpha = 0
        thirdImage.isHidden = true
        thirdImage.alpha = 0
        startButton.isHidden = true
        startButton.alpha = 0
        
        //MARK: - LifeCycle Methods
        
        makeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstViewAnimate()
    }
    
    //MARK: - Custom Methods
    
    func makeGesture(){
        let right = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        left.direction = .left
        self.view.addGestureRecognizer(left)
    }
    
    /// firstView 움직임 넣기
    private func firstViewAnimate(){
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {self.phoneImage.alpha = 1;         self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10)}, completion: {(finish) in
            UIView.animate(withDuration: 1, animations: {
                            self.firstImage.alpha = 1;
                            self.firstImage.transform = CGAffineTransform(translationX: 0, y: -10)})
        })
    }
    
    /// firstView 원상 복귀
    private func firstRestoration(){
        phoneImage.alpha = 0
        firstImage.alpha = 0
        UIView.animate(withDuration: 0, animations: {self.phoneImage.transform = .identity;
            self.firstImage.transform = .identity
        })
    }
    
    /// secondView 움직임 넣기
    private func secondViewAnimate(){
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {self.phoneImage.alpha = 1;         self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10)}, completion: {(finish) in
            UIView.animate(withDuration: 1, animations: {
                            self.secondImage.alpha = 1;
                            self.secondImage.transform = CGAffineTransform(translationX: 0, y: 10)})
        })
    }
    
    /// secondView 원상 복귀
    private func secondRestoration(){
        phoneImage.alpha = 0
        secondImage.alpha = 0
        UIView.animate(withDuration: 0, animations: {self.phoneImage.transform = .identity;
            self.secondImage.transform = .identity
        })
    }
    
    /// thirdView 움직임 넣기
    private func thirdViewAnimate(){
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {self.phoneImage.alpha = 1;         self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10)}, completion: {(finish) in
            UIView.animate(withDuration: 1, animations: {
                            self.thirdImage.alpha = 1;
                            self.thirdImage.transform = CGAffineTransform(translationX: 0, y: -10)}, completion:{ (finish) in
                                UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {self.startButton.alpha = 1;         self.startButton.transform = CGAffineTransform(translationX: 0, y: -10)}, completion: nil)
                            })
        })
    }
    
    /// thirdView 원상 복귀
    private func thirdRestoration(){
        phoneImage.alpha = 0
        thirdImage.alpha = 0
        startButton.alpha = 0
        UIView.animate(withDuration: 0, animations: {self.phoneImage.transform = .identity;
            self.thirdImage.transform = .identity
        })
        UIView.animate(withDuration: 0, animations: {self.startButton.transform = .identity})
    }
    
    
    //MARK: - IBActions
    
    @IBAction func actGesture(_ sender: UISwipeGestureRecognizer) {
        
        if currentPage == 1 {
            /// 오른쪽 -> 왼쪽 스와이프
            if sender.direction == .left {
                print("left")
                
                phoneImage.image = UIImage(named: "onboarding_img_phone_2")
                
                firstImage.isHidden = true
                secondImage.isHidden = false
                thirdImage.isHidden = true

                /// 원상복귀
                firstRestoration()
                /// 에니메이션
                secondViewAnimate()

                self.currentPage = 2
            }
            
            /// 왼쪽 -> 오른쪽 스와이프
            if sender.direction == .right {
                print("안돼~")
            }
            
        }else if currentPage == 2{
            
            if currentPage == 2 {
                /// 오른쪽 -> 왼쪽 스와이프
                if sender.direction == .left {
                    print("left")
                    
                    phoneImage.image = UIImage(named: "onboarding_img_phone_3")
                    
                    firstImage.isHidden = true
                    secondImage.isHidden = true
                    thirdImage.isHidden = false
                    
                    startButton.isHidden = false
                    
                    ///원상복귀
                    secondRestoration()
                    /// 에니메이션
                    thirdViewAnimate()
                    
                    self.currentPage = 3
                }
                
                /// 왼쪽 -> 오른쪽 스와이프
                if sender.direction == .right {
                    print("안돼~")
                    
                    phoneImage.image = UIImage(named: "onboarding_img_phone_1")

                    firstImage.isHidden = false
                    secondImage.isHidden = true
                    thirdImage.isHidden = true
                    
                    ///원상복귀
                    secondRestoration()
                    /// 에니메이션
                    firstViewAnimate()
                    
                    self.currentPage = 1
                }
            }
        } else{
            
            if currentPage == 3 {
                /// 오른쪽 -> 왼쪽 스와이프
                if sender.direction == .left {
                    print("안돼~")
                }
                
                /// 왼쪽 -> 오른쪽 스와이프
                if sender.direction == .right {
                    print("안돼~")
                    
                    phoneImage.image = UIImage(named: "onboarding_img_phone_2")
                    
                    firstImage.isHidden = true
                    secondImage.isHidden = false
                    thirdImage.isHidden = true
                    startButton.isHidden = true
                    
                    ///원상복귀
                    thirdRestoration()
                    /// 에니메이션
                    secondViewAnimate()
                         
                    self.currentPage = 2

                }
            }
        }
    }
}


