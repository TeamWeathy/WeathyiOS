//
//  TabbarVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/03.
//

import UIKit
import SystemConfiguration

class TabbarVC: UIViewController {
    static let identifier = "TabbarVC"
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if !isInternetAvailable() {
            self.showToast(message: "네트워크 연결을 확인해주세요!")
        }
    }
    
    @objc func recordSuccess(_ noti: Notification) {
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
        scrollView.isScrollEnabled = false
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
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // MARK: - IBActions
    
    /// Main 버튼
    @IBAction func mainButtonDidTap(_ sender: Any) {
        selectButton(buttonName: .mainButton)
        
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
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let _ = appDelegate.overviewData {
                let nextStoryboard = UIStoryboard(name: "RecordStart", bundle: nil)
                guard let vc = nextStoryboard.instantiateViewController(withIdentifier: RecordNVC.identifier) as? RecordNVC else { return }
                
                vc.origin = .plusRecord
                vc.modalPresentationStyle = .fullScreen
                
                present(vc, animated: true, completion: nil)
            } else {
                self.showToast(message: "네트워크 연결을 확인해주세요!")
            }
        }
    }

    /// Calendar 버튼
    @IBAction func calendarButtonDidTap(_ sender: Any) {
        selectButton(buttonName: .calendarButton)
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
        guard let calendarDetailVC = self.children[1] as? CalendarDetailVC else{ return }
        calendarDetailVC.viewWillAppear(true)
        calendarDetailVC.calendarVC.viewWillAppear(false)
    }
}

enum ButtonName{
    case mainButton
    case calendarButton
}
