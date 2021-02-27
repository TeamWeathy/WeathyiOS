//
//  OnBoardingFirstVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/07.
//

import Lottie
import UIKit

class OnBoardingFirstVC: UIViewController {
    // MARK: - Custom Variables

    var currentPage = 1
    let animationView = AnimationView()
    
    // MARK: - IBOutlets
    
    @IBOutlet var blindView: UIView!
    /// label
    @IBOutlet var lodingCloudView: UIView!
    @IBOutlet var firstWord: UILabel!
    @IBOutlet var secondWord: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    /// dot
    @IBOutlet var firstDot: UIImageView!
    @IBOutlet var secondDot: UIImageView!
    @IBOutlet var thridDot: UIImageView!
    
    /// image
    @IBOutlet var phoneImage: UIImageView!
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet var thirdImage: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var gestureStart: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneImage.alpha = 0

        firstImage.alpha = 0
        firstDot.image = UIImage(named: "onboarding_ic_circle_now")
        displayFirstSplash()
        
        secondImage.isHidden = true
        secondImage.alpha = 0
        
        thirdImage.isHidden = true
        thirdImage.alpha = 0
        
        startButton.isHidden = true
        startButton.alpha = 0
        
        /// OnBoarding 한번만 띄우기 위한 방법
        let isUser = UserDefaults.standard.bool(forKey: "onboarding")
        blindView.isHidden = isUser ? false : true

        // MARK: - LifeCycle Methods
        
        labelFont()
        makeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstLabelAnimate()
        firstViewAnimate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isUser = UserDefaults.standard.bool(forKey: "onboarding")
        
        if isUser {
            guard let uuid = UserDefaults.standard.string(forKey: "UUID")
            else { return }
            
            LoginService.shared.postLogin(uuid: uuid) { (NetworkResult) -> Void in
                switch NetworkResult {
                case .success:
                    let story = UIStoryboard(name: "Tabbar", bundle: nil)
                    
                    guard let vc = story.instantiateViewController(withIdentifier: TabbarVC.identifier) as? TabbarVC else { return }
                    
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                    print("success")
                case .requestErr:
                    print("requestErr")
                case .pathErr:
                    print("---> pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
    }
    
    // MARK: - Custom Methods

    func displayFirstSplash() {
        lodingCloudView.addSubview(animationView)
        animationView.animation = Animation.named("온보딩_1")
        animationView.frame = CGRect(x: -lodingCloudView.frame.width/2, y: -lodingCloudView.frame.height/2, width: lodingCloudView.frame.width*2, height: lodingCloudView.frame.height*2)
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: lodingCloudView.leadingAnchor), animationView.trailingAnchor.constraint(equalTo: lodingCloudView.trailingAnchor), animationView.topAnchor.constraint(equalTo: lodingCloudView.topAnchor), animationView.bottomAnchor.constraint(equalTo: lodingCloudView.bottomAnchor),
        ])
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func displaySecondSplash() {
        lodingCloudView.addSubview(animationView)
        animationView.animation = Animation.named("온보딩_2")
        animationView.frame = CGRect(x: -lodingCloudView.frame.width/2, y: -lodingCloudView.frame.height/2, width: lodingCloudView.frame.width*2, height: lodingCloudView.frame.height*2)
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: lodingCloudView.leadingAnchor), animationView.trailingAnchor.constraint(equalTo: lodingCloudView.trailingAnchor), animationView.topAnchor.constraint(equalTo: lodingCloudView.topAnchor), animationView.bottomAnchor.constraint(equalTo: lodingCloudView.bottomAnchor),
        ])
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func displayThirdSplash() {
        lodingCloudView.addSubview(animationView)
        animationView.animation = Animation.named("온보딩_3")
        animationView.frame = CGRect(x: -lodingCloudView.frame.width/2, y: -lodingCloudView.frame.height/2, width: lodingCloudView.frame.width*2, height: lodingCloudView.frame.height*2)
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: lodingCloudView.leadingAnchor), animationView.trailingAnchor.constraint(equalTo: lodingCloudView.trailingAnchor), animationView.topAnchor.constraint(equalTo: lodingCloudView.topAnchor), animationView.bottomAnchor.constraint(equalTo: lodingCloudView.bottomAnchor),
        ])
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func makeGesture() {
        let right = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        right.direction = .right
        view.addGestureRecognizer(right)
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        left.direction = .left
        view.addGestureRecognizer(left)
    }
    
    /// Font 및 색상 설정
    private func labelFont() {
        firstWord.font = UIFont.SDGothicSemiBold23
        secondWord.font = UIFont.SDGothicSemiBold23
        secondWord.textColor = .mintIcon
        subLabel.font = UIFont.SDGothicRegular16
        subLabel.textColor = .subGrey6
    }
    
    /// firstView -  Label & cloud Image 바꾸기
    private func firstLabelAnimate() {
        firstDot.image = UIImage(named: "onboarding_ic_circle_now")
        secondDot.image = UIImage(named: "onboarding_ic_circle")
        thridDot.image = UIImage(named: "onboarding_ic_circle")

        displayFirstSplash()
        firstWord.text = "날씨를"
        secondWord.text = "기록해요"
        subLabel.text = "오늘 날씨에 대한 옷차림과 상태를 기록해요"
    }
    
    /// secondView -  Label & cloud Image 바꾸기
    private func secondLabelAnimate() {
        firstDot.image = UIImage(named: "onboarding_ic_circle")
        secondDot.image = UIImage(named: "onboarding_ic_circle_now")
        thridDot.image = UIImage(named: "onboarding_ic_circle")
        displaySecondSplash()
        firstWord.text = "기록을"
        secondWord.text = "모아봐요"
        subLabel.text = "캘린더에서 날씨 기록을 모아볼 수 있어요"
    }
    
    /// thirdView -  Label & cloud Image 바꾸기
    private func thirdLabelAnimate() {
        firstDot.image = UIImage(named: "onboarding_ic_circle")
        secondDot.image = UIImage(named: "onboarding_ic_circle")
        thridDot.image = UIImage(named: "onboarding_ic_circle_now")
        displayThirdSplash()
        firstWord.text = "나에게"
        secondWord.text = "돌아와요"
        subLabel.text = "기록한 날씨는 비슷한 날에 돌아와요"
    }
    
    /// firstView 움직임 넣기
    private func firstViewAnimate() {
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { self.phoneImage.alpha = 1; self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10) }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.firstImage.alpha = 1
                self.firstImage.transform = CGAffineTransform(translationX: 0, y: -10)
            })
        })
    }
    
    /// firstView 원상 복귀
    private func firstRestoration() {
        phoneImage.alpha = 0
        firstImage.alpha = 0
        UIView.animate(withDuration: 0, animations: { self.phoneImage.transform = .identity
            self.firstImage.transform = .identity
        })
    }
    
    /// secondView 움직임 넣기
    private func secondViewAnimate() {
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { self.phoneImage.alpha = 1; self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10) }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.secondImage.alpha = 1
                self.secondImage.transform = CGAffineTransform(translationX: 0, y: 10)
            })
        })
    }
    
    /// secondView 원상 복귀
    private func secondRestoration() {
        phoneImage.alpha = 0
        secondImage.alpha = 0
        UIView.animate(withDuration: 0, animations: { self.phoneImage.transform = .identity
            self.secondImage.transform = .identity
        })
    }
    
    /// thirdView 움직임 넣기
    private func thirdViewAnimate() {
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: { self.phoneImage.alpha = 1; self.phoneImage.transform = CGAffineTransform(translationX: 0, y: -10) }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.thirdImage.alpha = 1
                self.thirdImage.transform = CGAffineTransform(translationX: 0, y: -10)
            }, completion: { _ in
                UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: { self.startButton.alpha = 1; self.startButton.transform = CGAffineTransform(translationX: 0, y: -10) }, completion: nil)
            })
        })
    }
    
    /// thirdView 원상 복귀
    private func thirdRestoration() {
        phoneImage.alpha = 0
        thirdImage.alpha = 0
        startButton.alpha = 0
        UIView.animate(withDuration: 0, animations: { self.phoneImage.transform = .identity
            self.thirdImage.transform = .identity
        })
        UIView.animate(withDuration: 0, animations: { self.startButton.transform = .identity })
    }
    
    // MARK: - IBActions
    
    @IBAction func actGesture(_ sender: UISwipeGestureRecognizer) {
        if currentPage == 1 {
            /// 오른쪽 -> 왼쪽 스와이프
            if sender.direction == .left {
                phoneImage.image = UIImage(named: "onboarding_img_phone_2")
                
                firstImage.isHidden = true
                secondImage.isHidden = false
                thirdImage.isHidden = true

                /// 원상복귀
                firstRestoration()
                /// 에니메이션
                secondLabelAnimate()
                secondViewAnimate()

                currentPage = 2
            }
        } else if currentPage == 2 {
            if currentPage == 2 {
                /// 오른쪽 -> 왼쪽 스와이프 (3번째 장으로 넘어갈 때)
                if sender.direction == .left {
                    phoneImage.image = UIImage(named: "onboarding_img_phone_3")
                    
                    firstImage.isHidden = true
                    secondImage.isHidden = true
                    thirdImage.isHidden = false
                    
                    startButton.isHidden = false
                    
                    /// 원상복귀
                    secondRestoration()
                    /// 에니메이션
                    thirdLabelAnimate()
                    thirdViewAnimate()
                    
                    currentPage = 3
                }
                
                /// 왼쪽 -> 오른쪽 스와이프 (1번째 장으로 돌아갈 때)
                if sender.direction == .right {
                    phoneImage.image = UIImage(named: "onboarding_img_phone_1")

                    firstImage.isHidden = false
                    secondImage.isHidden = true
                    thirdImage.isHidden = true
                    
                    /// 원상복귀
                    secondRestoration()
                    /// 에니메이션
                    firstLabelAnimate()
                    firstViewAnimate()
                    
                    currentPage = 1
                }
            }
        } else {
            if currentPage == 3 {
                /// 왼쪽 -> 오른쪽 스와이프
                if sender.direction == .right {
                    phoneImage.image = UIImage(named: "onboarding_img_phone_2")
                    
                    firstImage.isHidden = true
                    secondImage.isHidden = false
                    thirdImage.isHidden = true
                    startButton.isHidden = true
                    
                    /// 원상복귀
                    thirdRestoration()
                    /// 에니메이션
                    secondLabelAnimate()
                    secondViewAnimate()
                         
                    currentPage = 2
                }
            }
        }
    }
    
    /// 닉네임 설정하기 화면으로 이동
    @IBAction func startButtonDidTap(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NickNameVC") as? NickNameVC else { return }
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}
