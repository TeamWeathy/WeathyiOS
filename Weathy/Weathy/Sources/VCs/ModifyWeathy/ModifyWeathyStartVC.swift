//
//  RecordStartVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class ModifyWeathyStartVC: UIViewController {

    //MARK: - Custom Variables
    
    var weathyData: WeathyClass?
    var dateString: String = "0000-00-00"
    
    var todayMonth: Int = 0
    var todayDate: Int = 0
    
    var month: Int = 0
    var date: Int = 0
    var day: String = "땡"
    var location: String = "땡땡시 땡땡구"
    var currentTemp: Int = 0
    var maxTemp: Int = 0
    var minTemp: Int = 0
    
    var visitedFlag: Bool = false
    var dvc = ModifyWeathyTagVC()
    
    var selectedTag: [Int] = []
    
    var locationCode: CLong = 1100000000
    
    var selectedImage : UIImage?
    
    
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
        
        /// 구조체 안에 담긴 옷 태그 데이터를 배열로 변환하는 함수
        getClothesArray()
        
        locationCode = weathyData?.region.code ?? 1141000000
        
        print(">>>>>", selectedImage)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        self.fullDate = dateFormatter.date(from: "2021-01-25")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animationPrac()
        NotificationCenter.default.addObserver(self, selector: #selector(SearchInfo), name: .init("record"), object: nil)
    }
    
    @objc func SearchInfo(_ notification: Notification){
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let searchInfo = userInfo["mainDeliverSearchInfo"] as? OverviewWeather else { return}
        
        locationCode = searchInfo.region.code

        boxTimeLabel.text = "\(searchInfo.dailyWeather.date.month)월 \(searchInfo.dailyWeather.date.day)일 \(searchInfo.dailyWeather.date.dayOfWeek)"
        boxLocationLabel.text = searchInfo.region.name
        boxWeatherImageView.image = UIImage(named:   ClimateImage.getClimateSearchIllust(searchInfo.hourlyWeather.climate.iconId))
        maxTempLabel.text = "\(searchInfo.dailyWeather.temperature.maxTemp)°"
        minTempLabel.text = "\(searchInfo.dailyWeather.temperature.minTemp)°"
        print("---> 뭐야 \(searchInfo)")
    }
    
    //MARK: - IBActions
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        if visitedFlag == false {
            let nextStoryboard = UIStoryboard(name: "ModifyWeathyTag", bundle: nil)
            self.dvc = ((nextStoryboard.instantiateViewController(identifier: "ModifyWeathyTagVC") as? ModifyWeathyTagVC)!)
            
            visitedFlag = true
        }
        
        dvc.weathyData = weathyData
        dvc.dateString = dateString
        dvc.locationCode = locationCode
        
        dvc.selectedImage = selectedImage
        
        self.navigationController?.pushViewController(dvc, animated: false)
    }
    
    @IBAction func modifyBtnDidTap(_ sender: Any) {
        let searchStoryBoard = UIStoryboard.init(name: "MainSearch", bundle: nil)
        
        guard let searchVC = searchStoryBoard.instantiateViewController(withIdentifier: MainSearchVC.identifier) as? MainSearchVC else {return}
        
        searchVC.isFromRecord = true
        searchVC.dateFromRecord = dateString
        searchVC.modalPresentationStyle = .fullScreen
        
        present(searchVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishBtnDidTap(_ sender: Any) {
        callModifyWeathyService()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Style

extension ModifyWeathyStartVC {
    func setAboveBox() {
        dismissBtn.tintColor = UIColor(red: 86/255, green: 109/255, blue: 106/255, alpha: 1)
        
//        titleLabel.text = "\(todayMonth)월 \(todayDate)일의 웨디를\n기록해볼까요?"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = .mainGrey
        titleLabel.text = "\(weathyData?.dailyWeather.date.month ?? 0)월 \(weathyData?.dailyWeather.date.day ?? 0)일의 웨디를\n수정해볼까요?"
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
        
        boxTimeLabel.text = "\(weathyData?.dailyWeather.date.month ?? 0)월 \(weathyData?.dailyWeather.date.day ?? 0)일 \(weathyData?.dailyWeather.date.dayOfWeek ?? "땡요일")"
        boxTimeLabel.font = UIFont.SDGothicRegular15
        boxTimeLabel.textColor = UIColor.subGrey1
        
        boxLocationLabel.text = "\(weathyData?.region.name ?? "땡땡시 땡땡구")"
        boxLocationLabel.font = UIFont.SDGothicSemiBold17
        boxLocationLabel.textColor = UIColor.subGrey1
        
        boxWeatherImageView.image = UIImage(named: ClimateImage.getClimateSearchIllust(weathyData?.hourlyWeather.climate.iconId ?? -1))
        boxWeatherImageView.contentMode = .scaleAspectFit
        
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
        self.view.layoutIfNeeded()
        modifyBtn.layer.cornerRadius = modifyBtn.frame.height / 2
        
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.mintIcon, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
        nextBtn.setBorder(borderColor: .mintMain, borderWidth: 1)
        
        finishBtn.backgroundColor = .mintMain
        finishBtn.setTitle("수정완료", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        finishBtn.layer.cornerRadius = finishBtn.frame.height / 2
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
    
    func callModifyWeathyService() {
        ModifyWeathyService.shared.modifyWeathy(userId: UserDefaults.standard.integer(forKey: "userId"), token: UserDefaults.standard.string(forKey: "token") ?? "", date: dateString, code: locationCode, clothArray: selectedTag, stampId: weathyData?.stampId ?? -1, feedback: weathyData?.feedback ?? "", img: nil, isDelete: false, weathyId: weathyData?.weathyId ?? -1) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? RecordWeathyData {
                    print(loadData)
                }
        
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecordUpdated"), object: 1)
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    print(message)
                    self.showToast(message: message)
                }
                
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func getClothesArray() {
        var currentTag: Int = -1
        
        if weathyData?.closet.top.clothes.count != 0 {
            for i in 0...(weathyData?.closet.top.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.top.clothes[i].id)!
                
                selectedTag.append(currentTag)
            }
        }
        
        if weathyData?.closet.bottom.clothes.count != 0 {
            for i in 0...(weathyData?.closet.bottom.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.bottom.clothes[i].id)!
                
                selectedTag.append(currentTag)
            }
        }
        
        if weathyData?.closet.outer.clothes.count != 0 {
            for i in 0...(weathyData?.closet.outer.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.outer.clothes[i].id)!
                
                selectedTag.append(currentTag)
            }
        }
        
        if weathyData?.closet.etc.clothes.count != 0 {
            for i in 0...(weathyData?.closet.etc.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.etc.clothes[i].id)!
                
                selectedTag.append(currentTag)
            }
        }
        
        print(">>>>>", selectedTag)
        
    }
    
    
}


//MARK: - UIGestureRecognizerDelegate

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true
    }
}

