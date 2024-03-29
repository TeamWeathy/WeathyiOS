//
//  MainVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainVC: UIViewController {
    // MARK: - Custom Variables
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var lastContentOffset: CGFloat = 0.0
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        return refresh
    }()
    
    // gps 버튼 활성화 여부
    var isOnGPS: Bool = false {
        didSet {
            if isOnGPS {
                gpsButton.setImage(UIImage(named: "ic_gps_shadow"), for: .normal)
            } else {
                gpsButton.setImage(UIImage(named: "ic_otherplace_shadow"), for: .normal)
            }
        }
    }
    
    var locationWeatherData: LocationWeatherData?
    var recommenedWeathyData: RecommendedWeathyData?
    var hourlyWeatherData: HourlyWeatherData?
    var dailyWeatherData: DailyWeatherData?
    var extraWeatherData: ExtraWeatherData?
    
    // search - main
    var mainDeliverSearchInfo: OverviewWeather?
    var deliveredSearchData: OverviewWeather?
    var searchImage: String?
    var searchGradient: String?

    var safeInsetTop: CGFloat = 0
    var safeInsetBottom: CGFloat = 0
    
    // MARK: - IBOutlets
    
    // main
    @IBOutlet var mainBackgroundImage: UIImageView!
    @IBOutlet var topBlurView: UIImageView!
    @IBOutlet var topBlurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var todayDateTimeLabel: SpacedLabel!
    @IBOutlet var mainNaviBarView: UIView!
    @IBOutlet var mainTopView: UIView!
    @IBOutlet var mainBottomView: UIView!
    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var mainTopScrollView: UIScrollView!
    @IBOutlet var mainBottomScrollView: UIScrollView!
    @IBOutlet var mainViewHeightConstraint: NSLayoutConstraint!
    
    // main top view
    @IBOutlet var hourlyClimateImage: UIImageView!
    @IBOutlet var gpsButton: UIButton!
    @IBOutlet var currTempLabel: SpacedLabel!
    @IBOutlet var maxTempLabel: SpacedLabel!
    @IBOutlet var minTempLabel: SpacedLabel!
    @IBOutlet var climateLabel: SpacedLabel!
    @IBOutlet var locationLabel: SpacedLabel!
    
    // today weathy view
    @IBOutlet var todayWeathyNicknameLabel: SpacedLabel!
    @IBOutlet var helpButton: UIButton!
    @IBOutlet var todayWeathyView: UIView!
    @IBOutlet var weathyDateLabel: SpacedLabel!
    @IBOutlet var weathyClimateImage: UIImageView!
    @IBOutlet var weathyClimateLabel: SpacedLabel!
    @IBOutlet var weathyMaxTempLabel: SpacedLabel!
    @IBOutlet var weathyMinTempLabel: SpacedLabel!
    @IBOutlet var weathyStampImage: UIImageView!
    @IBOutlet var weathyStampLabel: SpacedLabel!
    @IBOutlet var closetTopLabel: SpacedLabel!
    @IBOutlet var closetBottomLabel: SpacedLabel!
    @IBOutlet var closetOuterLabel: SpacedLabel!
    @IBOutlet var weathyTextImage: UIImageView!
    @IBOutlet var weathyPhotoImage: UIImageView!
    @IBOutlet var closetEtcLabel: SpacedLabel!
    @IBOutlet var emptyImage: UIImageView!
    @IBOutlet var downImage: UIImageView!
    
    // main bottom view
    @IBOutlet var timeZoneWeatherView: UIView!
    @IBOutlet var weeklyWeatherView: UIView!
    @IBOutlet var extraWeatherView: UIView!
    @IBOutlet var timeZoneCenterY: NSLayoutConstraint!
    @IBOutlet var weeklyCenterY: NSLayoutConstraint!
    @IBOutlet var extraCenterY: NSLayoutConstraint!
    @IBOutlet var timeZoneWeatherCollectionView: UICollectionView!
    @IBOutlet var weeklyWeatherCollectionView: UICollectionView!
    @IBOutlet var extraWeatherCollectionView: UICollectionView!
    @IBOutlet var timeZoneLeftBlurImage: UIImageView!
    @IBOutlet var timeZoneRightBlurImage: UIImageView!
    
    // MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.shared.startUpdateLocation()
        checkLocationAndGetWeatherData()
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            todayWeathyNicknameLabel.text = "\(nickname)님이 기억하는"
        }
        
        blankDownImage()
        moveWeatherImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMainTopView()
        initMainBottomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSearchData), name: NSNotification.Name(rawValue: "search"), object: nil)
        
        mainScrollView.refreshControl = refreshControl
    }
        
    override func viewDidAppear(_ animated: Bool) {
        refreshControl.didMoveToSuperview()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        safeInsetTop = view.safeAreaInsets.top
        safeInsetBottom = view.safeAreaInsets.bottom
        
        let tabbarHeight: CGFloat = {
            if UIScreen.main.hasNotch {
                return 92
            } else {
                return 73
            }
        }()
        
        let mainHeight = UIScreen.main.bounds.height
        let viewHeight = mainHeight - (safeInsetTop + safeInsetBottom + mainNaviBarView.bounds.height) - tabbarHeight

        mainViewHeightConstraint.constant = viewHeight
    }
    
    // MARK: - Custom Method
    
    func initMainTopView() {
        // main top view
        mainScrollView.isPagingEnabled = true
        mainScrollView.backgroundColor = .clear
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.delegate = self
        mainTopScrollView.showsVerticalScrollIndicator = false
        mainTopScrollView.delegate = self
        
        logoImage.frame.origin.y += 100
        logoImage.alpha = 0
        
        topBlurView.frame.origin.y -= topBlurView.bounds.height
        topBlurView.alpha = 0
        
        let topBlurViewHeight = topBlurViewHeightConstraint.constant
        topBlurViewHeightConstraint.constant = UIScreen.main.hasNotch ? topBlurViewHeight : topBlurViewHeight - 44
        
        todayDateTimeLabel.font = UIFont.SDGothicRegular15
        todayDateTimeLabel.textColor = UIColor.subGrey1
        todayDateTimeLabel.characterSpacing = -0.75
        todayDateTimeLabel.text = "\(Date().getDateToString(format: "M월 dd일 EEEE • a h시", date: Date()))"

        // top weathy view
        let weathyViewTabGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpTodayWeathyView))
        todayWeathyView.addGestureRecognizer(weathyViewTabGesture)

        closetTopLabel.font = UIFont.SDGothicRegular13
        closetTopLabel.textColor = UIColor.black
        closetTopLabel.characterSpacing = -0.65

        closetOuterLabel.font = UIFont.SDGothicRegular13
        closetOuterLabel.textColor = UIColor.black
        closetOuterLabel.characterSpacing = -0.65

        closetBottomLabel.font = UIFont.SDGothicRegular13
        closetBottomLabel.textColor = UIColor.black
        closetBottomLabel.characterSpacing = -0.65
        
        closetEtcLabel.font = UIFont.SDGothicRegular13
        closetEtcLabel.textColor = UIColor.black
        closetEtcLabel.characterSpacing = -0.65

        todayWeathyNicknameLabel.font = UIFont.SDGothicRegular16
        todayWeathyNicknameLabel.characterSpacing = -0.8
        todayWeathyNicknameLabel.textColor = UIColor.mainGrey
        todayWeathyNicknameLabel.text = "님이 기억하는"

        todayWeathyView.makeRounded(cornerRadius: 35)
        todayWeathyView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.21, radius: 50)

        locationLabel.font = UIFont.SDGothicSemiBold20
        locationLabel.textColor = UIColor.mainGrey
        locationLabel.characterSpacing = -1.0

        currTempLabel.font = UIFont.RobotoLight50
        currTempLabel.textColor = UIColor.subGrey1
        currTempLabel.characterSpacing = -2.5

        maxTempLabel.font = UIFont.RobotoLight23
        maxTempLabel.textColor = UIColor.redTemp
        maxTempLabel.characterSpacing = -1.15
        
        minTempLabel.font = UIFont.RobotoLight23
        minTempLabel.textColor = UIColor.blueTemp
        minTempLabel.characterSpacing = -1.15

        climateLabel.font = UIFont.SDGothicRegular16
        climateLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.58)
        climateLabel.characterSpacing = -0.8
        
        weathyDateLabel.font = UIFont.SDGothicRegular13
        weathyDateLabel.textColor = UIColor.subGrey6
        weathyDateLabel.characterSpacing = -0.65
        
        weathyClimateLabel.font = UIFont.SDGothicMedium15
        weathyClimateLabel.textColor = UIColor.subGrey1
        weathyClimateLabel.characterSpacing = -0.75

        weathyMaxTempLabel.textColor = UIColor.redTemp
        weathyMaxTempLabel.font = UIFont.RobotoLight30
        weathyMaxTempLabel.characterSpacing = -1.5

        weathyMinTempLabel.textColor = UIColor.blueTemp
        weathyMinTempLabel.font = UIFont.RobotoLight30
        weathyMinTempLabel.characterSpacing = -1.5

        weathyStampLabel.font = UIFont.SDGothicSemiBold23
        weathyStampLabel.characterSpacing = -1.15
        
        weathyTextImage.isHidden = false
        weathyPhotoImage.isHidden = false
        
        gpsButton.contentMode = .scaleAspectFit
        
        // main bottom view
        timeZoneWeatherView.backgroundColor = .white
        timeZoneWeatherView.makeRounded(cornerRadius: 35)
        timeZoneWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        weeklyWeatherView.backgroundColor = .white
        weeklyWeatherView.makeRounded(cornerRadius: 35)
        weeklyWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        extraWeatherView.backgroundColor = .white
        extraWeatherView.makeRounded(cornerRadius: 35)
        extraWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
    }
    
    func initMainBottomView() {
        timeZoneWeatherCollectionView.delegate = self
        timeZoneWeatherCollectionView.dataSource = self
        weeklyWeatherCollectionView.delegate = self
        weeklyWeatherCollectionView.dataSource = self
        extraWeatherCollectionView.delegate = self
        extraWeatherCollectionView.dataSource = self
        
        mainScrollView.delegate = self
        
        timeZoneCenterY.constant = UIScreen.main.bounds.height
        weeklyCenterY.constant = UIScreen.main.bounds.height
        extraCenterY.constant = UIScreen.main.bounds.height

        mainBottomView.layoutIfNeeded()
        
        // blur image (이미지 에셋 좌우 반전)
        timeZoneLeftBlurImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        timeZoneLeftBlurImage.alpha = 0
    }
    
    func changeMainTopWeatherData(data: LocationWeatherData) {
        // background 설정
        let iconId = data.overviewWeather.hourlyWeather.climate.iconId
        mainBackgroundImage.image = UIImage(named: ClimateImage.getClimateMainBgName(iconId))
        topBlurView.image = UIImage(named: ClimateImage.getClimateMainBlurBarName(iconId))

        searchImage = ClimateImage.getClimateSearchBgName(iconId)
        searchGradient = ClimateImage.getClimateSearchBlurBarName(iconId)
        
        removeFlakeEmitterCell()
        switch iconId % 100 {
        case 9, 10, 11:
            fallingRain()
        case 13:
            fallingSnow()
        default:
            break
        }
        
        hourlyClimateImage.image = UIImage(named: ClimateImage.getClimateMainIllust(iconId))

        // navigation bar
        todayDateTimeLabel.font = UIFont.SDGothicRegular15
        todayDateTimeLabel.textColor = UIColor.subGrey1
        todayDateTimeLabel.text = "\(data.overviewWeather.dailyWeather.date.month)월 \(data.overviewWeather.dailyWeather.date.day)일 \(data.overviewWeather.dailyWeather.date.dayOfWeek) • \(data.overviewWeather.hourlyWeather.time!)"
        todayDateTimeLabel.characterSpacing = -0.75
        
        locationLabel.text = "\(data.overviewWeather.region.name)"
        currTempLabel.text = "\(data.overviewWeather.hourlyWeather.temperature!)°"
        maxTempLabel.text = "\(data.overviewWeather.dailyWeather.temperature.maxTemp)°"
        minTempLabel.text = "\(data.overviewWeather.dailyWeather.temperature.minTemp)°"
        
        if let desc = data.overviewWeather.hourlyWeather.climate.description {
            climateLabel.text = "\(desc)"
        }
    }
    
    func changeWeathyViewData(data: RecommendedWeathyData) {
        emptyImage.alpha = 0
        
        closetTopLabel.text = insertSeparatorInArray(data.weathy.closet.top.clothes)
        closetOuterLabel.text = insertSeparatorInArray(data.weathy.closet.outer.clothes)
        closetBottomLabel.text = insertSeparatorInArray(data.weathy.closet.bottom.clothes)
        closetEtcLabel.text = insertSeparatorInArray(data.weathy.closet.etc.clothes)
        
        if let year: Int = data.weathy.dailyWeather.date.year {
            let month: Int = data.weathy.dailyWeather.date.month
            let day: Int = data.weathy.dailyWeather.date.day
            weathyDateLabel.text = "\(year)년 \(month)월 \(day)일"
        }
        
        weathyClimateImage.image = UIImage(named: ClimateImage.getClimateIconName(data.weathy.hourlyWeather.climate.iconId))
        if let climateDesc = data.weathy.hourlyWeather.climate.description {
            weathyClimateLabel.text = "\(climateDesc)"
        }
        weathyMaxTempLabel.text = "\(data.weathy.dailyWeather.temperature.maxTemp)°"
        weathyMinTempLabel.text = "\(data.weathy.dailyWeather.temperature.minTemp)°"
        
        weathyStampImage.image = UIImage(named: Emoji.getEmojiImageAsset(stampId: data.weathy.stampId))
        weathyStampLabel.text = Emoji.getEmojiText(stampId: data.weathy.stampId)
        weathyStampLabel.textColor = Emoji.getEmojiTextColor(stampId: data.weathy.stampId)
        
        if data.weathy.imgUrl == nil {
            weathyPhotoImage.isHidden = true
        } else {
            weathyPhotoImage.isHidden = false
        }
        
        if data.weathy.feedback == nil {
            weathyTextImage.isHidden = true
        } else {
            weathyTextImage.isHidden = false
        }
    }
    
    func checkLocationAndGetWeatherData() {
        if UserDefaults().isExistUserDefaults("searchLocationCode") {
            // 검색 데이터 있음
            isOnGPS = false
            getLocationWeather(isDefault: true)
        } else {
            // 검색 데이터 없음
            let locationAuth = UserDefaults.standard.bool(forKey: "locationAuth")
            
            switch locationAuth {
            case true:
                // 위치 허용
                print("현재 위치")
                getLocationWeather(isDefault: false)
                isOnGPS = true
            case false:
                // 위치 미허용
                print("디폴트 위치")
                getLocationWeather(isDefault: true)
                isOnGPS = false
            }
        }
    }

    // MARK: - Network

    // FIXME: - code로 API 호출 시 code type Int로 수정
    func getLocationWeather(isDefault: Bool) {
        MainService.shared.getWeatherByLocation(isCode: isDefault) { (result) -> Void in
            switch result {
            case .success(let data):
                if let response = data as? LocationWeatherData {
                    self.locationWeatherData = response
                    self.appDelegate?.overviewData = response.overviewWeather
                    let regionCode = response.overviewWeather.region.code
                    
                    self.changeMainTopWeatherData(data: response)
                    
                    self.getRecommendedWeathy(code: regionCode)
                    self.getHourlyWeather(code: regionCode)
                    self.getDailyWeather(code: regionCode)
                    self.getExtraWeather(code: regionCode)
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
    
    func getRecommendedWeathy(code: Int) {
        let userId: Int = UserDefaults.standard.integer(forKey: "userId")
        
        MainService.shared.getRecommendedWeathy(userId: userId, code: code) { (result) -> Void in
            switch result {
            case .success(let data):
                if let response = data as? RecommendedWeathyData {
                    self.recommenedWeathyData = response
                    self.changeWeathyViewData(data: response)
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr, .serverErr, .networkFail:
                print("No Recommended Data")
                self.showEmptyView()
            }
        }
    }
    
    func getHourlyWeather(code: Int) {
        MainService.shared.getHourlyWeather(code: code) { (result) -> Void in
            switch result {
            case .success(let data):
                if let response = data as? HourlyWeatherData {
                    self.hourlyWeatherData = response
                    self.timeZoneWeatherCollectionView.reloadData()
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
    
    func getDailyWeather(code: Int) {
        MainService.shared.getDailyWeather(code: code) { (result) -> Void in
            switch result {
            case .success(let data):
                if let response = data as? DailyWeatherData {
                    self.dailyWeatherData = response
                    self.weeklyWeatherCollectionView.reloadData()
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
    
    func getExtraWeather(code: Int) {
        MainService.shared.getExtraWeather(code: code) { (result) -> Void in
            switch result {
            case .success(let data):
                if let response = data as? ExtraWeatherData {
                    self.extraWeatherData = response
                    self.extraWeatherCollectionView.reloadData()
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
    
    func fallingSnow() {
        let flakeEmitterCell = CAEmitterCell()
        flakeEmitterCell.contents = UIImage(named: "snow")?.cgImage
        flakeEmitterCell.alphaRange = 0.5
        flakeEmitterCell.alphaSpeed = -0.1
        flakeEmitterCell.scale = 0.3
        flakeEmitterCell.scaleRange = 0.6
        flakeEmitterCell.emissionRange = .pi * 2
        flakeEmitterCell.lifetime = 20.0
        flakeEmitterCell.birthRate = 10
        flakeEmitterCell.velocity = 50
        flakeEmitterCell.velocityRange = 20
        flakeEmitterCell.yAcceleration = 10
        flakeEmitterCell.xAcceleration = 5
        flakeEmitterCell.spin = -0.5
        flakeEmitterCell.spinRange = 1.0
        
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width/2.0, y: -50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 30
        snowEmitterLayer.emitterCells = [flakeEmitterCell]
        snowEmitterLayer.zPosition = 1
        mainBackgroundImage.layer.addSublayer(snowEmitterLayer)
    }
    
    func fallingRain() {
        let flakeEmitterCell = CAEmitterCell()
        flakeEmitterCell.contents = UIImage(named: "rain")?.cgImage
        flakeEmitterCell.alphaRange = 0.5
        flakeEmitterCell.alphaSpeed = -0.1
        flakeEmitterCell.scale = 0.3
        flakeEmitterCell.scaleRange = 0.3
        flakeEmitterCell.lifetime = 20.0
        flakeEmitterCell.birthRate = 20
        flakeEmitterCell.velocity = 200
        flakeEmitterCell.velocityRange = 20
        flakeEmitterCell.yAcceleration = 300
        flakeEmitterCell.xAcceleration = 5
        
        let rainEmitterLayer = CAEmitterLayer()
        rainEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width/2, y: -300)
        rainEmitterLayer.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
        rainEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        rainEmitterLayer.beginTime = CACurrentMediaTime()
        rainEmitterLayer.timeOffset = 30
        rainEmitterLayer.emitterCells = [flakeEmitterCell]
        
        rainEmitterLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi/24))
        rainEmitterLayer.opacity = 0.9
        
        mainBackgroundImage.layer.addSublayer(rainEmitterLayer)
    }
    
    func removeFlakeEmitterCell() {
        if var subLayers = mainBackgroundImage.layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
            
            subLayers.removeAll()
        }
    }
    
    func insertSeparatorInArray(_ arr: [Clothes]) -> String {
        arr.map { (val) -> String in
            "\(val.name)"
        }.joined(separator: " ・ ")
    }

    func showEmptyView() {
        emptyImage.image = UIImage(named: "main_img_empty")
        emptyImage.alpha = 1
    }

    func viewScrollUp() {
        timeZoneCenterY.constant = UIScreen.main.bounds.height
        weeklyCenterY.constant = UIScreen.main.bounds.height
        extraCenterY.constant = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.alpha = 0
            self.weeklyWeatherView.alpha = 0
            self.extraWeatherView.alpha = 0
                        
            self.mainBottomView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewScrollDown() {
        timeZoneCenterY.constant = 21
        weeklyCenterY.constant = 24
        extraCenterY.constant = 24
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.overrideInheritedCurve], animations: {
            self.timeZoneWeatherView.alpha = 1
            self.weeklyWeatherView.alpha = 1
            self.extraWeatherView.alpha = 1
            
            self.mainBottomView.layoutIfNeeded()
        })
    }
    
    func blankDownImage() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.downImage.alpha = 0
            self.downImage.alpha = 1
        })
    }
    
    func moveWeatherImage() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.hourlyClimateImage.transform = CGAffineTransform(translationX: 0, y: 3)
            self.hourlyClimateImage.transform = CGAffineTransform(translationX: 0, y: -6)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func touchUpSearch(_ sender: Any) {
        let mainSearchStoryboard = UIStoryboard(name: "MainSearch", bundle: nil)
        guard let mainSearchVC = mainSearchStoryboard.instantiateViewController(withIdentifier: MainSearchVC.identifier) as? MainSearchVC else { return }
        
        if let image = searchImage,
           let gradient = searchGradient
        {
            mainSearchVC.backImage = image
            mainSearchVC.gradient = gradient
        }
        
        mainSearchVC.modalPresentationStyle = .fullScreen
        present(mainSearchVC, animated: true, completion: nil)
    }
    
    @IBAction func touchUpSetting(_ sender: Any) {
        let settingStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        
        guard let settingNVC = settingStoryboard.instantiateViewController(withIdentifier: "SettingNVC") as? SettingNVC else { return }

        settingNVC.modalPresentationStyle = .fullScreen
        present(settingNVC, animated: true, completion: nil)
    }
    
    @IBAction func touchUpGPSButton(_ sender: Any) {
        if !isOnGPS {
            let locationAuth = UserDefaults.standard.bool(forKey: "locationAuth")
            
            if locationAuth {
                // 현재 위치 받아오기
                getLocationWeather(isDefault: false)
                UserDefaults.standard.removeObject(forKey: "searchLocationCode")
                isOnGPS = true
            } else {
                // 팝업 띄우기
                guard let popUpVC = storyboard?.instantiateViewController(withIdentifier: "MainGPSPopupVC") as? MainGPSPopupVC else { return }
                
                popUpVC.modalTransitionStyle = .crossDissolve
                popUpVC.modalPresentationStyle = .overCurrentContext
                
                present(popUpVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func touchUpHelpButton(_ sender: UIButton) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let helpViewWidth: CGFloat = screenWidth * (286/375)
        let helpViewHeight: CGFloat = 216 * (helpViewWidth/286)
        let topMargin: CGFloat = 8
        let helpBoxImageXpos: CGFloat = helpButton.frame.origin.x - (screenWidth * (86/375))
        let helpBoxImageYpos: CGFloat = helpButton.frame.origin.y + helpButton.bounds.height + topMargin + safeInsetTop + safeInsetBottom + 48 - mainTopScrollView.contentOffset.y
        
        let helpBackgroundImage = UIImageView(image: UIImage(named: "main_help_bg_grey"))
        helpBackgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        helpBackgroundImage.contentMode = .scaleToFill
        helpBackgroundImage.tag = 101
            
        let helpBoxImage = UIImageView(image: UIImage(named: "main_help_box_help"))
        helpBoxImage.frame = CGRect(x: helpBoxImageXpos, y: helpBoxImageYpos, width: helpViewWidth, height: helpViewHeight)
        helpBoxImage.contentMode = .scaleToFill
        helpBoxImage.tag = 102
        
        let closeButton = UIButton(frame: CGRect(x: helpBoxImage.frame.width + helpBoxImage.frame.origin.x - 48, y: helpBoxImage.frame.origin.y + 8, width: 48, height: 48))
        closeButton.setImage(UIImage(named: "ic_close"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 19, bottom: 17, right: 18)
        closeButton.tag = 103
        
        closeButton.addTarget(self, action: #selector(touchUpCloseHelpButton(_:)), for: .touchUpInside)
        
        if let superview = view.superview?.superview {
            superview.addSubview(helpBackgroundImage)
            superview.addSubview(helpBoxImage)
            superview.addSubview(closeButton)
        }

        helpBackgroundImage.isUserInteractionEnabled = true
        helpButton.isUserInteractionEnabled = false
    }
        
    @objc func touchUpCloseHelpButton(_ sender: Any) {
        guard let superView = view.superview?.superview else { return }

        if let helpBackgroundImage = superView.viewWithTag(101),
           let helpBoxImage = superView.viewWithTag(102),
           let closeButton = superView.viewWithTag(103)
        {
            helpBackgroundImage.removeFromSuperview()
            helpBoxImage.removeFromSuperview()
            closeButton.removeFromSuperview()
        }
  
        mainScrollView.isScrollEnabled = true
        mainTopScrollView.isScrollEnabled = true

        helpButton.isUserInteractionEnabled = true
    }

    // MARK: - objc func
    
    @objc func touchUpTodayWeathyView() {
        if let data = recommenedWeathyData {
            guard let tabBarVC = parent as? TabbarVC else { return }
            guard let calendarDetailVC = tabBarVC.children[1] as? CalendarDetailVC else { return }
            
            let dailyWeathyDate: DateClass = data.weathy.dailyWeather.date
            guard let dailyWeathyYear = dailyWeathyDate.year else { return }
            
            let weathyDate = "\(dailyWeathyYear)-\(dailyWeathyDate.month)-\(dailyWeathyDate.day)" // YYYY-MM-DD
            calendarDetailVC.todayWeathyFlag = true
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "ChangeDate"), object: Date().getStringToDate(format: "yyyy-MM-dd", dateString: weathyDate))
            
            tabBarVC.selectButton(buttonName: .calendarButton)
                
            tabBarVC.scrollView.setContentOffset(CGPoint(x: tabBarVC.scrollView.frame.width, y: 0), animated: false)
        }
    }
    
    @objc func appMovedToForeground() {
        moveWeatherImage()
        blankDownImage()
    }
    
    @objc func receiveSearchData(_notification: NSNotification) {
        let isRefreshSearch: Bool = (_notification.object != nil)
        
        if isRefreshSearch {
            let width_variable: CGFloat = 33
            let toastLabel = UILabel(frame: CGRect(x: width_variable, y: UIScreen.main.bounds.height - 165, width: view.frame.size.width - 2 * width_variable, height: 50))
            
            toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
            toastLabel.textColor = UIColor.mainGrey
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.SDGothicRegular16
            toastLabel.lineSetting(kernValue: -0.8)
            toastLabel.text = "변경된 위치의 날씨를 확인해보세요!"
            toastLabel.alpha = 1
            toastLabel.layer.cornerRadius = 25
            toastLabel.clipsToBounds = true
            
            view.addSubview(toastLabel)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            }
        }
    }
    
    @objc func pullToRefresh(_ sender: UIRefreshControl) {
        checkLocationAndGetWeatherData()
        
        sender.endRefreshing()
    }
}

// MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case timeZoneWeatherCollectionView:
            return hourlyWeatherData?.hourlyWeatherList.count ?? 0
        case weeklyWeatherCollectionView:
            return 7
        case extraWeatherCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case timeZoneWeatherCollectionView:
            guard let cell = timeZoneWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: TimezoneWeatherCVC.idenfier, for: indexPath) as? TimezoneWeatherCVC else { return UICollectionViewCell() }
            cell.setCell()
            
            if let hourly = hourlyWeatherData?.hourlyWeatherList {
                cell.setTimezoneWeatherData(hourlyData: hourly[indexPath.row], idx: indexPath.row)
            }
            
            return cell
        case weeklyWeatherCollectionView:
            guard let cell = weeklyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCVC.identifier, for: indexPath) as? WeeklyWeatherCVC else { return UICollectionViewCell() }
            cell.setCell()
            
            if let daily = dailyWeatherData {
                cell.setWeeklyWeatherData(data: daily.dailyWeatherList[indexPath.row], idx: indexPath.row)
            }
            
            return cell
        case extraWeatherCollectionView:
            guard let cell = extraWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: ExtraWeatherCVC.identifier, for: indexPath) as? ExtraWeatherCVC else { return UICollectionViewCell() }
            cell.setCell()
            
            if let extra = extraWeatherData {
                switch indexPath.row {
                case 0:
                    cell.setExtraWeatherData(data: extra.extraWeather.rain, type: ExtraType.rain)
                case 1:
                    cell.setExtraWeatherData(data: extra.extraWeather.humidity, type: ExtraType.humidity)
                case 2:
                    cell.setExtraWeatherData(data: extra.extraWeather.wind, type: ExtraType.wind)
                default:
                    break
                }
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case timeZoneWeatherCollectionView, weeklyWeatherCollectionView:
            return CGSize(width: collectionView.bounds.size.width/7, height: collectionView.bounds.size.height)
        case extraWeatherCollectionView:
            return CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func initScrollView() {
        mainBottomScrollView.contentOffset.y = 0
        
        timeZoneCenterY.constant = UIScreen.main.bounds.height
        weeklyCenterY.constant = UIScreen.main.bounds.height
        extraCenterY.constant = UIScreen.main.bounds.height
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        initScrollView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            if lastContentOffset < scrollView.contentOffset.y, scrollView.contentOffset.y >= 200 {
                viewScrollDown()
            } else if lastContentOffset > scrollView.contentOffset.y, scrollView.contentOffset.y <= 500 {
                viewScrollUp()
            }
            
            if scrollView.contentOffset.y >= 400 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.logoImage.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.todayDateTimeLabel.transform = CGAffineTransform(translationX: 0, y: -100)
                })
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.logoImage.alpha = 1
                    self.todayDateTimeLabel.alpha = 0
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.logoImage.transform = CGAffineTransform(translationX: 0, y: 100)
                    self.todayDateTimeLabel.transform = .identity
                })
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.logoImage.alpha = 0
                    self.todayDateTimeLabel.alpha = 1
                })
            }
        }
        
        if scrollView == timeZoneWeatherCollectionView {
            let maxScroll: CGFloat = scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right
            let contentOffset: CGFloat = scrollView.contentOffset.x
            let blurWidth: CGFloat = timeZoneLeftBlurImage.bounds.width
            
            if contentOffset < blurWidth/3 {
                UIView.animate(withDuration: 0.5) {
                    self.timeZoneLeftBlurImage.alpha = 0
                }
            } else if contentOffset > maxScroll - (blurWidth/3) {
                UIView.animate(withDuration: 0.5) {
                    self.timeZoneRightBlurImage.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.timeZoneLeftBlurImage.alpha = 1
                    self.timeZoneRightBlurImage.alpha = 1
                }
            }
        }
        
        if scrollView == mainScrollView || scrollView == mainTopScrollView {
            let mainScrollContentOffset = mainScrollView.contentOffset.y
            let mainTopScrollContentOffset = mainTopScrollView.contentOffset.y
            
            if mainScrollContentOffset > 10 || mainTopScrollContentOffset > 10 {
                UIView.animate(withDuration: 0.5) {
                    self.topBlurView.alpha = 1
                }
            }
            
            if mainScrollContentOffset < 10 && mainTopScrollContentOffset < 10 {
                UIView.animate(withDuration: 0.3) {
                    self.topBlurView.alpha = 0
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
}
