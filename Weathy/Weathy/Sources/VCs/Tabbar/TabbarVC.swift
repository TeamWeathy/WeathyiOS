//
//  TabbarVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/03.
//

import UIKit

class TabbarVC: UIViewController {
    static let identifier = "TabbarVC"
    
    // MARK: - Custom Variables
    
    var mainButtonBool = true
    var calendarButtonBool = false
    
    // MARK: - IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var tabbarView: UIView!
    @IBOutlet weak var tabbarViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        
        plusButton.dropShadow(color: UIColor.mintIcon, offSet: CGSize(width: 0, height: 3), opacity: 0.6, radius: 6)

        setViewControllers()
        initButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(recordSuccess(_:)), name: NSNotification.Name("RecordUpdated"), object: 0)
        
        ///노치유무에 따라 탭바 위치 조절
        if UIScreen.main.hasNotch{
            tabbarViewBottomConstraint.constant = -15
        }
        else{
            tabbarViewBottomConstraint.constant = 0
        }
    }
    
    @objc func recordSuccess(_ noti: Notification) {
//        calendarButtonBool = true
//        mainButtonBool = false
        selectButton(buttonName: .calendarButton)
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
    }
    
    // MARK: - Custom Methods

    /// Tabbar를 통한 화면 전환
    func setViewControllers() {
        scrollView.contentSize.width = view.frame.width * 2
       
        guard let MainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
        addChild(MainVC)
       
        guard let leftVCView = MainVC.view else { return }
        leftVCView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(leftVCView)

        guard let rightVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarDetailVC") as? CalendarDetailVC else { return }
        addChild(rightVC)
        
        guard let rightVCView = rightVC.view else { return }
        rightVCView.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(rightVCView)
        rightVC.didMove(toParent: self)
    }
    
    func initButton(){
        mainButton.setImage(UIImage(named: "ic_weather_unselected"), for: .normal)
        mainButton.setImage(UIImage(named: "ic_weather_selected"), for: .selected)
        calendarButton.setImage(UIImage(named: "ic_weather_unselected_2"), for: .normal)
        calendarButton.setImage(UIImage(named:"ic_calendar_selected"), for: .selected)
        
        mainButton.isSelected = true
    }
    
    func selectButton(buttonName: ButtonName){
        switch buttonName{
            case .mainButton:
                mainButton.isSelected = true
                calendarButton.isSelected = false
            case .calendarButton:
                mainButton.isSelected = false
                calendarButton.isSelected = true
        }
        
    }
    
    // MARK: - IBActions
    
    /// Main 버튼
    @IBAction func mainButtonDidTap(_ sender: Any) {
        selectButton(buttonName: .mainButton)
        
//        if calendarButtonBool == true {
//            mainButton.setImage(UIImage(named: "ic_weather_selected"), for: .normal)
//            calendarButton.setImage(UIImage(named: "ic_weather_unselected_2"), for: .normal)
//            calendarButtonBool = false
//            mainButtonBool = true
//        }
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        
        if let mainVC = children[0] as? MainVC {
            mainVC.checkLocationAndGetWeatherData()
        }
    }

    /// Plus 버튼
    @IBAction func plusButtonDidTap(_ sender: Any) {
        let recentRecordDateString = UserDefaults.standard.string(forKey: "recentRecordDate")
        if recentRecordDateString == Date().getDateToString(format: "yyyy-MM-dd", date: Date()){
            self.showToast(message: "웨디는 하루에 하나만 기록할 수 있어요.")
        }
        else{
            let nextStoryboard = UIStoryboard(name: "RecordStart", bundle: nil)
            guard let vc = nextStoryboard.instantiateViewController(withIdentifier: RecordNVC.identifier) as? RecordNVC else { return }
            
            vc.origin = .plusRecord
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: true, completion: nil)
        }
    }

    /// Calendar 버튼
    @IBAction func calendarButtonDidTap(_ sender: Any) {
        selectButton(buttonName: .calendarButton)
//        /// image 변경을 위한 코드
//        if mainButtonBool == true {
//            mainButton.setImage(UIImage(named: "ic_weather_unselected"), for: .normal)
//            calendarButton.setImage(UIImage(named: "ic_calendar_selected"), for: .normal)
//
//            calendarButtonBool = true
//            mainButtonBool = false
//        }
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
    }
}

enum ButtonName{
    case mainButton
    case calendarButton
}
