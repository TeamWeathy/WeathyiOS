//
//  MainVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainVC: UIViewController {
    //MARK: - Custom Variables
    var lastContentOffset: CGFloat = 0.0
    let dateFormatter = DateFormatter()
    var currDate: Date = Date()
    var lat: Double?
    var lon: Double?
    var locationWeatherData: LocationWeatherData?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainBackgroundImage: UIImageView!
    @IBOutlet weak var topBlurView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var settingIconImage: UIImageView!
    @IBOutlet weak var searchIconImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var todayDateTimeLabel: SpacedLabel!
    
    //MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        currDate = Date()
        
        lat = 37.59311236609
        lon = 126.9501814612
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        
        UserDefaults.standard.setValue("62:p5RMVC9Z6Vpy82nLmV9ZDt2u1gDy15", forKey: "token")
        UserDefaults.standard.setValue("이내옹", forKey: "nickname")
        
        MainService.shared.getWeatherByLocation(token: UserDefaults.standard.string(forKey: "token")!, lat: lat ?? 0, lon: lon ?? 0, date: dateFormatter.string(from: currDate)) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? LocationWeatherData {
                    self.setViewByData(data: response)
                }
                
                self.weatherCollectionView.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fallingRain()
        fallingSnow()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
    }
    
    //MARK: - Custom Method
    
    func setViewByData(data: LocationWeatherData) {
        // background 설정
        mainBackgroundImage.image = UIImage(named: "main_bg_snowrain")
        
        topBlurView.image = UIImage(named: "mainscroll_box_topblur_snowrain")
        topBlurView.frame.origin.y -= topBlurView.bounds.height
        topBlurView.alpha = 0
        
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.isPagingEnabled = true
        weatherCollectionView.decelerationRate = .fast
        
        // navigation bar
        todayDateTimeLabel.font = UIFont.SDGothicRegular15
        todayDateTimeLabel.textColor = UIColor.subGrey1
        todayDateTimeLabel.text = "\(data.overviewWeather.dailyWeather.date.month)월 \(data.overviewWeather.dailyWeather.date.day)일 \(data.overviewWeather.dailyWeather.date.dayOfWeek) • \(data.overviewWeather.hourlyWeather.time)"
        todayDateTimeLabel.characterSpacing = -0.75
        
        logoImage.frame.origin.y -= 100
        logoImage.alpha = 0
        
        if let topCVC = weatherCollectionView.cellForItem(at: [0, 0]) as? MainTopCVC {
            topCVC.setCell(data: data)
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
    
    //MARK: - IBActions
    
    @IBAction func touchUpSetting(_ sender: Any) {
        print("setting")
    }
    
    @IBAction func touchUpSearch(_ sender: Any) {
        print("search")
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
            
//            cell.setCell()
            return cell
        case 1:
            guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "MainBottomCVC", for: indexPath) as? MainBottomCVC else {return UICollectionViewCell()}
            
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
