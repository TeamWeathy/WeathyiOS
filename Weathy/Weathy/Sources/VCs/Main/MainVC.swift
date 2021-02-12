//
//  MainVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainVC: UIViewController {
    //MARK: - Custom Variables
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var lastContentOffset: CGFloat = 0.0
    var mainDeliverSearchInfo : OverviewWeatherList?
    var locationWeatherData: LocationWeatherData?
    var recommenedWeathyData: RecommendedWeathyData?
    var hourlyWeatherData: HourlyWeatherData?
    var dailyWeatherData: DailyWeatherData?
    var extraWeatherData: ExtraWeatherData?
    var searchImage: String?
    var searchGradient: String?
    var deliveredSearchData: OverviewWeatherList?
    var defaultLocationFlag: Bool = true{
        didSet {
            // 값이 바뀔 때
            if (defaultLocationFlag) {
                // 위치정보로
                print("true")
            } else {
                print("false")
            }
        }
    }
    var safeInsetTop: CGFloat = 0
    var safeInsetBottom: CGFloat = 0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainBackgroundImage: UIImageView!
    @IBOutlet weak var topBlurView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var todayDateTimeLabel: SpacedLabel!
    @IBOutlet weak var mainNaviBarView: UIView!
    @IBOutlet weak var mainTopView: UIView!
    @IBOutlet weak var mainBottomView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
    // fix: 닉네임 뷰에서 처리할 로직

        
        UserDefaults.standard.setValue("1141000000", forKey: "locationCode")
        print(UserDefaults.standard.value(forKey: "token"))
        
//        if let location = UserDefaults.standard.string(forKey: "locationCode") {
//            // search에서 넘어온 데이터가 없는 경우에만 서버 통신
//            if (self.deliveredSearchData == nil) {
//                getLocationWeather(code: location)
//            } else {
//                print("#")
//                defaultLocationFlag = false
//            }
//        }
//        if let topCVC = weatherCollectionView.cellForItem(at: [0,0]) as? MainTopCVC{
//            topCVC.todayWeathyNicknameTextLabel.text = "\(UserDefaults.standard.string(forKey: "nickname")!)님이 기억하는"
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
//        weatherCollectionView.dataSource = self
//        weatherCollectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(setSearchData), name: NSNotification.Name("DeliverSearchData"), object: nil)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        safeInsetTop = view.safeAreaInsets.top
        safeInsetBottom = view.safeAreaInsets.bottom

        let mainHeight = UIScreen.main.bounds.height
        let viewHeight = mainHeight - (safeInsetTop + safeInsetBottom + mainNaviBarView.bounds.height) - 92
        // 92: 하단 탭 바 높이

        mainViewHeightConstraint.constant = viewHeight
    }
    
    //MARK: - Custom Method
    
    func setView() {
        mainScrollView.isPagingEnabled = true
        mainScrollView.backgroundColor = .clear
        mainScrollView.showsVerticalScrollIndicator = false
    }
    
    func setViewByData(data: LocationWeatherData) {
        // background 설정
        let iconId = data.overviewWeather.hourlyWeather.climate.iconID
        mainBackgroundImage.image = UIImage(named: ClimateImage.getClimateMainBgName(iconId))
        topBlurView.image = UIImage(named: ClimateImage.getClimateMainBlurBarName(iconId))

        searchImage = ClimateImage.getClimateMainBgName(iconId)
        searchGradient = ClimateImage.getSearchClimateMainBlurBarName(iconId)
        
        if (iconId % 100 == 13) {
            fallingSnow()
        } else if (iconId % 100 == 10) {
            fallingRain()
        }
        
        topBlurView.frame.origin.y -= topBlurView.bounds.height
        topBlurView.alpha = 0
        
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.isPagingEnabled = true
        weatherCollectionView.decelerationRate = .fast
        
        // navigation bar
        todayDateTimeLabel.font = UIFont.SDGothicRegular15
        todayDateTimeLabel.textColor = UIColor.subGrey1
        todayDateTimeLabel.text = "\(data.overviewWeather.dailyWeather.date.month)월 \(data.overviewWeather.dailyWeather.date.day)일 \(data.overviewWeather.dailyWeather.date.dayOfWeek) • \(data.overviewWeather.hourlyWeather.time!)"
        todayDateTimeLabel.characterSpacing = -0.75
        
        logoImage.frame.origin.y -= 100
        logoImage.alpha = 0
    }
    
    func getLocationWeather(code: String) {
        MainService.shared.getWeatherByLocation(code: code) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? LocationWeatherData {
                    self.locationWeatherData = response
                    self.setViewByData(data: response)
                    self.appDelegate?.overviewData = response.overviewWeather
                    if let topCVC = self.weatherCollectionView.cellForItem(at: [0, 0]) as? MainTopCVC {
                        topCVC.changeWeatherViewData(data: self.locationWeatherData!)
                    }

                    UserDefaults.standard.setValue(response.overviewWeather.region.code, forKey: "locationCode")
                    
                    self.getRecommendedWeathy(code: String(response.overviewWeather.region.code))
                    self.getHourlyWeather(code: String(response.overviewWeather.region.code))
                    self.getDailyWeather(code: String(response.overviewWeather.region.code))
                    self.getExtraWeather(code: String(response.overviewWeather.region.code))
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
    
    func getRecommendedWeathy(code: String) {
        let userId: Int = UserDefaults.standard.integer(forKey: "userId")
        
        MainService.shared.getRecommendedWeathy(userId: userId, code: code) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? RecommendedWeathyData {
                    self.recommenedWeathyData = response
                    
                    if let topCVC = self.weatherCollectionView.cellForItem(at: [0, 0]) as? MainTopCVC {
                        topCVC.changeWeathyViewData(data: self.recommenedWeathyData!)
                    }
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr, .serverErr, .networkFail:
                print("No Recommended Data")
                if let topCVC = self.weatherCollectionView.cellForItem(at: [0, 0]) as? MainTopCVC {
                    topCVC.showEmptyView()
                }
            }
        }
    }
    
    func getHourlyWeather(code: String) {
        MainService.shared.getHourlyWeather(code: code) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? HourlyWeatherData {
                    self.hourlyWeatherData = response
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
    
    func getDailyWeather(code: String) {
        MainService.shared.getDailyWeather(code: code) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? DailyWeatherData {
                    self.dailyWeatherData = response
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
    
    func getExtraWeather(code: String) {
        MainService.shared.getExtraWeather(code: code) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? ExtraWeatherData {
                    self.extraWeatherData = response
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
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
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
        
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -300)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 30
        snowEmitterLayer.emitterCells = [flakeEmitterCell]
        
        snowEmitterLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi/24))
        snowEmitterLayer.opacity = 0.9
        
        mainBackgroundImage.layer.addSublayer(snowEmitterLayer)
    }
    
    @objc func setSearchData(_ notiData: NSNotification) {
        if let hourlyData = notiData.object as? OverviewWeatherList {
            self.deliveredSearchData = hourlyData
            
            let iconId: Int = hourlyData.hourlyWeather.climate.iconID
            let locationCode: String = String(hourlyData.region.code)
            
            self.mainBackgroundImage.image = UIImage(named: ClimateImage.getClimateMainBgName(iconId))
            self.topBlurView.image = UIImage(named: ClimateImage.getClimateMainBlurBarName(iconId))
            
            if (iconId % 100 == 13) {
                fallingSnow()
            } else if (iconId % 100 == 10) {
                fallingRain()
            }
            
//            self.getRecommendedWeathy(code: locationCode)
//            self.getHourlyWeather(code: locationCode)
//            self.getDailyWeather(code: locationCode
//            self.getExtraWeather(code: locationCode)
            
            if let topCVC = self.weatherCollectionView.cellForItem(at: [0, 0]) as? MainTopCVC {
                topCVC.locationLabel.text = hourlyData.region.name
//                topCVC.changeWeatherViewData(data: self.locationWeatherData!)
                topCVC.changeWeatherViewBySearchData(data: hourlyData)
                topCVC.gpsButton.setImage(UIImage(named: "ic_otherplace_shadow"), for: .normal)
//                topCVC.defaultLocationFlag = false
            }
            
//            self.weatherCollectionView.reloadData()
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func touchUpSearch(_ sender: Any) {
        print("search")
        let mainSearchStoryboard = UIStoryboard.init(name: "MainSearch", bundle: nil)
        guard let mainSearchVC = mainSearchStoryboard.instantiateViewController(withIdentifier: MainSearchVC.identifier) as? MainSearchVC else { return }
        
        if let image = self.searchImage,
           let gradient = self.searchGradient {
            mainSearchVC.backImage = image
            mainSearchVC.gradient = gradient
        }
        
        mainSearchVC.modalPresentationStyle = .fullScreen
        self.present(mainSearchVC, animated: true, completion: nil)
    }
    
    @IBAction func touchUpSetting(_ sender: Any) {
        print("setting")
        let settingStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        
        guard let settingNVC = settingStoryboard.instantiateViewController(withIdentifier: "SettingNVC") as? SettingNVC else {return}

        settingNVC.modalPresentationStyle = .fullScreen
        self.present(settingNVC, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let bottomCVC = weatherCollectionView.cellForItem(at: [1, 0]) as? MainBottomCVC {
            if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y >= 200) {
                bottomCVC.viewScrollDown()
            }
            
            else if (lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y <= 500){
                bottomCVC.viewScrollUp()
            }
        }

        if (scrollView.contentOffset.y >= 400) {
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImage.transform = CGAffineTransform(translationX: 0, y: 0)
                self.todayDateTimeLabel.transform = CGAffineTransform(translationX: 0, y: -100)
            })
            
            UIView.animate(withDuration: 0.3, animations: {
                self.logoImage.alpha = 1
                self.topBlurView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImage.transform = CGAffineTransform(translationX: 0, y: 100)
                self.todayDateTimeLabel.transform = .identity
            })
            
            UIView.animate(withDuration: 0.3, animations: {
                self.logoImage.alpha = 0
                self.topBlurView.alpha = 0
            })
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
}


//MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "MainTopCVC", for: indexPath) as? MainTopCVC else {return UICollectionViewCell()}
            if let recommend = recommenedWeathyData,
               let location = locationWeatherData {
                cell.changeWeathyViewData(data: recommend)
                cell.changeWeatherViewData(data: location)
            }
            cell.todayWeathyNicknameTextLabel.text = "\(UserDefaults.standard.string(forKey: "nickname")!)님이 기억하는"
            cell.setCell()
            return cell
        case 1:
            guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "MainBottomCVC", for: indexPath) as? MainBottomCVC else {return UICollectionViewCell()}
            if let hourly = hourlyWeatherData {
                cell.changeHourlyViewData(data: hourly)
            }
            
            if let daily = dailyWeatherData {
                cell.changeDailyViewData(data: daily)
            }
            
            if let extra = extraWeatherData {
                cell.changeExtraViewData(data: extra)
            }
            
            cell.setCell()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
