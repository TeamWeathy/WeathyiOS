//
//  TabbarVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/03.
//

import UIKit

class TabbarVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var mainButtonBool = true
    var calendarButtonBool = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var tabbarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        
        /// plusButton 그림자 주기
        plusButton.dropShadow(color: UIColor.mintIcon, offSet: CGSize(width: 0, height: 3), opacity: 0.6, radius: 6)
        
        //MARK: - LifeCycle Methods

        viewcontrollerSetting()
    }
    
    //MARK: - Custom Methods

    /// Tabbar를 통한 화면 전환
    func viewcontrollerSetting(){
       self.scrollView.contentSize.width = self.view.frame.width * 2
       
        /// ExampleFirstVC 생성
        guard let leftVC = self.storyboard?.instantiateViewController(withIdentifier: ExampleFirstVC.identifier) as? ExampleFirstVC else { return }
        /// ExampleFirstVC를 Child View Controller로 지정
        self.addChild(leftVC)
       
        /// ExampleFirstVC의 View만 가져오기
        guard let leftVCView = leftVC.view else { return }
       
        /// ExampleFirstVC View의 Frame 지정
        leftVCView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
       
        /// Scroll View에 ExampleFirstVC의 View 넣기
        self.scrollView.addSubview(leftVCView)
       
        /// 이제 leftVC가 Container View Controller 앞으로 올라왔기 때문에 didmove(toParent:)를 실행
        leftVC.didMove(toParent: self)
        
        /// ExampleThirdVC도 동일.
        guard let rightVC = self.storyboard?.instantiateViewController(withIdentifier: ExampleThirdVC.identifier) as? ExampleThirdVC else { return }
        self.addChild(rightVC)
        guard let rightVCView = rightVC.view else { return }
        rightVCView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(rightVCView)
        rightVC.didMove(toParent: self)
   }
    
    //MARK: - @objc Methods
    
    
    //MARK: - IBActions
    
    /// Main 버튼
    @IBAction func mainButtonDidTap(_ sender: Any) {
        
        /// image 변경을 위한 코드
        if calendarButtonBool == true{
            mainButton.setImage(UIImage(named: "ic_weather_selected"), for: .normal)
            calendarButton.setImage(UIImage(named: "ic_weather_unselected_2"), for: .normal)
            
            calendarButtonBool = false
            mainButtonBool = true
        } else {
            
        }
        
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    /// Plus 버튼
    @IBAction func plusButtonDidTap(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ExampleSecondVC.identifier) as? ExampleSecondVC else {return}
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    /// Calendar 버튼
    @IBAction func calendarButtonDidTap(_ sender: Any) {
        /// image 변경을 위한 코드
        if mainButtonBool == true{
            mainButton.setImage(UIImage(named: "ic_weather_unselected"), for: .normal)
            calendarButton.setImage(UIImage(named: "ic_calendar_selected"), for: .normal)
            
            calendarButtonBool = true
            mainButtonBool = false
        } else {
            
        }
        
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width, y: 0), animated: true)
    }
}

//MARK: - UITableViewDelegate


//MARK: - UITableViewDatasource
