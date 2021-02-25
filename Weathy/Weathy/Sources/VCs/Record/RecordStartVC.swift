//
//  RecordStartVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

import Alamofire

class RecordStartVC: UIViewController {

    //MARK: - Custom Variables
    
    var dateToday: Date?
    var dateString: String = "2021-01-16"

    var todayMonth: Int = 1
    var todayDate: Int = 1
    
    var month: Int = 12
    var date: Int = 20
    var day: String = "월"
    var location: String = "서울시 종로구"
    var currentTemp: Int = -2
    var maxTemp: Int = 0
    var minTemp: Int = 0
    
    var visitedFlag: Bool = false
    var dvc = RecordTagVC()
    
    var recordDeliverSearchInfo: OverviewWeatherList?
    
    var locationWeatherData: LocationWeatherData?
    
    var locationCode: CLong = 1141000000
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - IBOutlets
    
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var indicatorCircle: [UIView]!
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var boxTimeLabel: UILabel!
    @IBOutlet var boxLocationLabel: UILabel!
    @IBOutlet var boxWeatherImageView: UIImageView!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var slashLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var modifyBtn: UIButton!
    @IBOutlet var startBtn: UIButton!
    
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        getLocationWeather()
        
        setAboveBox()
        setBox()
        setBelowBox()
        
        setTitleLabel()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleAnimation()
        NotificationCenter.default.addObserver(self, selector: #selector(SearchInfo), name: .init("record"), object: nil)
    }
    
    @objc func SearchInfo(_ notification: Notification){
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let searchInfo = userInfo["mainDeliverSearchInfo"] as? OverviewWeatherList else { return}
        
        locationCode = searchInfo.region.code

        boxTimeLabel.text = "\(searchInfo.dailyWeather.date.month)월 \(searchInfo.dailyWeather.date.day)일 \(searchInfo.dailyWeather.date.dayOfWeek)"
        boxLocationLabel.text = searchInfo.region.name
        boxWeatherImageView.image = UIImage(named: ClimateImage.getClimateSearchIllust(searchInfo.hourlyWeather.climate.iconId))
        maxTempLabel.text = "\(searchInfo.dailyWeather.temperature.maxTemp)°"
        minTempLabel.text = "\(searchInfo.dailyWeather.temperature.minTemp)°"
    }
    
    //MARK: - IBActions
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        if visitedFlag == false {
            let nextStoryboard = UIStoryboard(name: "RecordTag", bundle: nil)
            self.dvc = (nextStoryboard.instantiateViewController(identifier: "RecordTagVC") as? RecordTagVC)!
            
            visitedFlag = true
        }
        
        dvc.dateToday = dateToday
        dvc.dateString = dateString
        dvc.locationCode = locationCode
        
        self.navigationController?.pushViewController(dvc, animated: false)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "RecordStartPopUpVC") as? RecordStartPopUpVC else {
            return
        }
        
        dvc.modalPresentationStyle = .overCurrentContext
        
        self.present(dvc, animated: false, completion: nil)
    }
    
    @IBAction func searchButtonDidTap(_ sender: Any) {
        let searchStoryBoard = UIStoryboard.init(name: "MainSearch", bundle: nil)
        
        guard let searchVC = searchStoryBoard.instantiateViewController(withIdentifier: MainSearchVC.identifier) as? MainSearchVC else {return}
        
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.isFromRecord = true
        
        present(searchVC, animated: true, completion: nil)
    }
    
    
}

//MARK: - Style

extension RecordStartVC {

    func setAboveBox() {
        dismissBtn.tintColor = UIColor(red: 86/255, green: 109/255, blue: 106/255, alpha: 1)
        
        titleLabel.text = "\(dateToday?.month ?? 0)월 \(dateToday?.day ?? 0)일의 웨디를\n기록해볼까요?"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = .mainGrey
        
        subTitleLabel.text = "기록할 위치와 날씨를 확인해 주세요."
        subTitleLabel.font = UIFont.SDGothicRegular16
        subTitleLabel.textColor = UIColor.subGrey6
        
        indicatorCircle[0].layer.cornerRadius = 6.5
        indicatorCircle[0].backgroundColor = UIColor.mintMain
        
        indicatorCircle[1].layer.cornerRadius = 4.5
        indicatorCircle[1].backgroundColor = UIColor.subGrey7
        
        indicatorCircle[2].layer.cornerRadius = 4.5
        indicatorCircle[2].backgroundColor = UIColor.subGrey7
    }
    
    func setTitleLabel() {
        /// 기본 설정
        let attributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                      value: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!, range: (titleLabel.text! as NSString).range(of: "웨디"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.mintIcon, range: (titleLabel.text! as NSString).range(of: "웨디"))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        titleLabel.attributedText = attributedString
    }
    
    func setBox() {
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.subGrey7.cgColor
        boxView.layer.cornerRadius = 35
        
        boxTimeLabel.text = "\(dateToday?.month ?? 0)월 \(dateToday?.day ?? 0)일 \(getDayStringFromInt(dayInt: dateToday?.weekday ?? 6))"
        boxTimeLabel.font = UIFont.SDGothicRegular15
        boxTimeLabel.textColor = UIColor.subGrey1
        
        boxLocationLabel.text = "\(appDelegate.overviewData?.region.name ?? "땡땡시 땡땡구")"
        boxLocationLabel.font = UIFont.SDGothicSemiBold17
        boxLocationLabel.textColor = UIColor.subGrey1
        
        maxTempLabel.text = "\(maxTemp)°"
        maxTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        maxTempLabel.textColor = UIColor.redTemp
        maxTempLabel.baselineAdjustment = .alignBaselines
        
        slashLabel.text = "/"
        slashLabel.font = UIFont(name: "Roboto-Regular", size: 23)
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        slashLabel.baselineAdjustment = .alignBaselines
        
        minTempLabel.text = "\(minTemp)°"
        minTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        minTempLabel.textColor = UIColor.blueTemp
        minTempLabel.baselineAdjustment = .alignBaselines
    }
    
    func setBelowBox() {
        modifyBtn.backgroundColor = UIColor.subGrey5
        modifyBtn.setTitle("변경하기", for: .normal)
        modifyBtn.setTitleColor(.black, for: .normal)
        modifyBtn.titleLabel?.font = UIFont.SDGothicRegular13
        modifyBtn.layer.cornerRadius = modifyBtn.frame.height / 2
        
        startBtn.backgroundColor = UIColor.mintMain
        startBtn.setTitle("다음", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        /// 송편 되는 문제 해결 - 레이아웃이 변경 됐을 때 반영
        self.view.layoutIfNeeded()
        startBtn.layer.cornerRadius = startBtn.frame.height / 2
        
    }
    
    func initPosition() {
        
        titleLabel.alpha = 0
        titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y-10, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        subTitleLabel.alpha = 0
        subTitleLabel.frame = CGRect(x: subTitleLabel.frame.origin.x, y: subTitleLabel.frame.origin.y-10, width: subTitleLabel.frame.width, height: subTitleLabel.frame.height)
        
    }
    
    func titleAnimation() {
        self.initPosition()
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y+10, width: self.titleLabel.frame.width, height: self.titleLabel.frame.height)
        })
        
        UIView.animate(withDuration: 1, delay: 0.5, animations: {
            self.subTitleLabel.alpha = 1
            self.subTitleLabel.frame = CGRect(x: self.subTitleLabel.frame.origin.x, y: self.subTitleLabel.frame.origin.y+10, width: self.subTitleLabel.frame.width, height: self.subTitleLabel.frame.height)
        })
    }
    
    func getLocationWeather() {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        locationCode = appDelegate.overviewData?.region.code ?? 1100000000
        
        RecordWeathyService.shared.getWeatherByLocation(dateString: dateString, regionCode: locationCode) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? LocationWeatherData {
                    self.locationWeatherData = response
                    
                    self.maxTempLabel.text = "\(self.locationWeatherData!.overviewWeather.dailyWeather.temperature.maxTemp)°"
                    self.minTempLabel.text = "\(self.locationWeatherData!.overviewWeather.dailyWeather.temperature.minTemp)°"
                    
                    self.boxWeatherImageView.image = UIImage(named: ClimateImage.getClimateSearchIllust(self.locationWeatherData!.overviewWeather.hourlyWeather.climate.iconId))
                    
                    self.viewWillAppear(false)
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("path Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                print("network Fail")
            }
        }
    }
    
    func getDayStringFromInt(dayInt: Int) -> String {
        if dayInt == 0 {
            return "일요일"
        }
        if dayInt == 1 {
            return "월요일"
        }
        if dayInt == 2 {
            return "화요일"
        }
        if dayInt == 3 {
            return "수요일"
        }
        if dayInt == 4 {
            return "목요일"
        }
        if dayInt == 5 {
            return "금요일"
        }
        if dayInt == 6 {
            return "토요일"
        }
        return "땡요일"
    }
    
}


