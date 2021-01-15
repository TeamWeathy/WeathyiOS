//
//  RecordStartVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class ModifyWeathyStartVC: UIViewController {

    //MARK: - Custom Variables
    
    var weathyData: CalendarWeathy?
    
    var todayMonth: Int = 1
    var todayDate: Int = 1
    
    var fullDate: String = "2021-01-13"
    var month: Int = 12
    var date: Int = 20
    var day: String = "월"
    var location: String = "서울시 서초구"
    var currentTemp: Int = -2
    var maxTemp: Int = 20
    var minTemp: Int = -20
    
    var visitedFlag: Bool = false
    var dvc = ModifyWeathyTagVC()
    
    
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
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var finishBtn: UIButton!
    
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAboveBox()
        setBox()
        setBelowBox()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setTitleLabel()
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        self.fullDate = dateFormatter.date(from: "2021-01-25")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animationPrac()
    }
    
    //MARK: - IBActions
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        if visitedFlag == false {
            let nextStoryboard = UIStoryboard(name: "ModifyWeathyTag", bundle: nil)
            self.dvc = ((nextStoryboard.instantiateViewController(identifier: "ModifyWeathyTagVC") as? ModifyWeathyTagVC)!)
            
            visitedFlag = true
        }
        
        dvc.weathyData = weathyData
        
        self.navigationController?.pushViewController(dvc, animated: false)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishBtnDidTap(_ sender: Any) {
        // 서버 처리
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Style

extension ModifyWeathyStartVC {
    func setAboveBox() {
        dismissBtn.tintColor = UIColor(red: 86/255, green: 109/255, blue: 106/255, alpha: 1)
        
//        titleLabel.text = "\(todayMonth)월 \(todayDate)일의 웨디를\n기록해볼까요?"
        titleLabel.numberOfLines = 2
//        titleLabel.font = UIFont.RobotoRegular25
        
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
        let attributedString = NSMutableAttributedString(string: "\(weathyData?.dailyWeather.date.month ?? 0)월 \(weathyData?.dailyWeather.date.day ?? 0)일의 웨디를\n기록해볼까요?", attributes: [
            .font: UIFont(name: "AppleSDGothicNeoR00", size: 25.0)!,
            .foregroundColor: UIColor.mainGrey,
            .kern: -1.25
        ])
        
        /// 행간 조정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        /// 볼드 처리
        attributedString.addAttributes([
            .font: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!,
            .foregroundColor: UIColor.mintIcon
        ], range: NSRange(location: 7, length: 2))
        
        /// 스타일 적용
        titleLabel.attributedText = attributedString
    }
    
    func setBox() {
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.subGrey7.cgColor
        boxView.layer.cornerRadius = 35
        
        boxTimeLabel.text = "\(weathyData?.dailyWeather.date.month ?? 0)월 \(weathyData?.dailyWeather.date.day ?? 0)일 \(weathyData?.dailyWeather.date.dayOfWeek ?? "땡요일")"
        boxTimeLabel.font = UIFont.SDGothicRegular15
        boxTimeLabel.textColor = UIColor.subGrey1
        
        boxLocationLabel.text = "\(weathyData?.region.name ?? "땡땡시 땡땡구")"
        boxLocationLabel.font = UIFont.SDGothicSemiBold17
        boxLocationLabel.textColor = UIColor.subGrey1
        
        boxWeatherImageView.image = UIImage(named: ClimateImage.getClimateAssetName(weathyData?.hourlyWeather.climate.iconId ?? -1))
        
        maxTempLabel.text = "\(weathyData?.dailyWeather.temperature.maxTemp ?? 0)°"
        maxTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        maxTempLabel.textColor = UIColor.redTemp
        maxTempLabel.baselineAdjustment = .alignBaselines
        
        slashLabel.text = "/"
        slashLabel.font = UIFont(name: "Roboto-Regular", size: 23)
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        slashLabel.baselineAdjustment = .alignBaselines
        
        minTempLabel.text = "\(weathyData?.dailyWeather.temperature.minTemp ?? 0)°"
        minTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        minTempLabel.textColor = UIColor.blueTemp
        minTempLabel.baselineAdjustment = .alignBaselines
    }
    
    func setBelowBox() {
        modifyBtn.backgroundColor = .subGrey5
        modifyBtn.setTitle("변경하기", for: .normal)
        modifyBtn.setTitleColor(.black, for: .normal)
        modifyBtn.titleLabel?.font = UIFont.SDGothicRegular13
        modifyBtn.layer.cornerRadius = 18
        
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.mintIcon, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        nextBtn.setBorder(borderColor: .mintMain, borderWidth: 1)
        
        finishBtn.backgroundColor = .mintMain
        finishBtn.setTitle("수정완료", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        finishBtn.layer.cornerRadius = 30
    }
    
    func initPosition() {
        
        titleLabel.alpha = 0
        titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y-10, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        subTitleLabel.alpha = 0
        subTitleLabel.frame = CGRect(x: subTitleLabel.frame.origin.x, y: subTitleLabel.frame.origin.y-10, width: subTitleLabel.frame.width, height: subTitleLabel.frame.height)
        
    }
    
    func animationPrac() {
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
}


//MARK: - UIGestureRecognizerDelegate

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true
    }
}

