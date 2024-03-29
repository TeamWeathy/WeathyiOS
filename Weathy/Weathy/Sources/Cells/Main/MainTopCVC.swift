//
//  MainTopCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainTopCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    var closetTop: [String] = ["기모 맨투맨", "히트텍", "폴로니트", "메종 마르지엘라"]
    var closetOuter: [String] = ["청바지", "청바지","청바지","청바지","청바지"]
    var closetBottom: [String] = ["롱패딩","루리스"]
    var closetEtc: [String] = ["목도리","장갑","귀마개","수면양말", "어쩌라","마마무"]
    var defaultLocationFlag: Bool = true {
        didSet {
            // 값이 바뀔 때
            if (defaultLocationFlag) {
                // 위치정보로
            } else {
                //
            }
        }
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var todayWeathyNicknameTextLabel: SpacedLabel!
    @IBOutlet weak var todayWeathyView: UIView!
    @IBOutlet weak var currTempLabel: SpacedLabel!
    @IBOutlet weak var maxTempLabel: SpacedLabel!
    @IBOutlet weak var minTempLabel: SpacedLabel!
    @IBOutlet weak var climateLabel: SpacedLabel!
    @IBOutlet weak var locationLabel: SpacedLabel!
    @IBOutlet weak var weathyDateLabel: SpacedLabel!
    @IBOutlet weak var weathyClimateImage: UIImageView!
    @IBOutlet weak var weathyClimateLabel: SpacedLabel!
    @IBOutlet weak var weathyMaxTempLabel: SpacedLabel!
    @IBOutlet weak var weathyMinTempLabel: SpacedLabel!
    @IBOutlet weak var weathyStampImage: UIImageView!
    @IBOutlet weak var weathyStampLabel: SpacedLabel!
    @IBOutlet weak var closetTopLabel: SpacedLabel!
    @IBOutlet weak var closetBottomLabel: SpacedLabel!
    @IBOutlet weak var closetOuterLabel: SpacedLabel!
    @IBOutlet weak var closetEtcLabel: SpacedLabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var hourlyClimateImage: UIImageView!
    @IBOutlet weak var gpsButton: UIButton!
    
    //MARK: - Custom Methods
    func changeWeatherViewData(data: LocationWeatherData!) {
        locationLabel.text = "\(data.overviewWeather.region.name)"
        currTempLabel.text = "\(data.overviewWeather.hourlyWeather.temperature!)°"
        maxTempLabel.text = "\(data.overviewWeather.dailyWeather.temperature.maxTemp)°"
        minTempLabel.text = "\(data.overviewWeather.dailyWeather.temperature.minTemp)°"
        hourlyClimateImage.image = UIImage(named: ClimateImage.getClimateMainIllust(data.overviewWeather.hourlyWeather.climate.iconId))
        
        if let desc = data.overviewWeather.hourlyWeather.climate.description {
            climateLabel.text = "\(desc)"
        }
    }
    
    func changeWeatherViewBySearchData(data: OverviewWeather) {
        locationLabel.text = "\(data.region.name)"
        currTempLabel.text = "\(data.hourlyWeather.temperature)°"
        maxTempLabel.text = "\(data.dailyWeather.temperature.maxTemp)°"
        minTempLabel.text = "\(data.dailyWeather.temperature.minTemp)°"
        hourlyClimateImage.image = UIImage(named: ClimateImage.getClimateMainIllust(data.hourlyWeather.climate.iconId))
        climateLabel.text = "\(data.hourlyWeather.climate.description)"
    }
    
    func changeWeathyViewData(data: RecommendedWeathyData) {
//        print(data.weathy)
        if (data.weathy == nil) {
            showEmptyView()
            return
        }
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            todayWeathyNicknameTextLabel.text = "\(nickname)님이 기억하는"
        }

//        closetTopLabel.text = insertSeparatorInArray(data.weathy.closet.top.clothes)
//        closetOuterLabel.text = insertSeparatorInArray(data.weathy.closet.outer.clothes)
//        closetBottomLabel.text = insertSeparatorInArray(data.weathy.closet.bottom.clothes)
//        closetEtcLabel.text = insertSeparatorInArray(data.weathy.closet.etc.clothes)
        
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
    }
            
    func blankDownImage() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.downImage.alpha = 0
            self.downImage.alpha = 1
        }, completion: nil)
    }
    
    func showEmptyView() {
        emptyImage.image = UIImage(named: "main_img_empty")
        emptyImage.alpha = 1
    }

    func setCell() {
        blankDownImage()

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

        todayWeathyNicknameTextLabel.font = UIFont.SDGothicRegular16
        todayWeathyNicknameTextLabel.characterSpacing = -0.8

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
        climateLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.58)
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
        weathyStampLabel.textColor = UIColor.imojiColdText
        weathyStampLabel.characterSpacing = -1.15
        
        gpsButton.contentMode = .scaleAspectFit
    }

    //MARK: - IBActions
    
        
    @IBAction func touchUpGpsButton(_ sender: Any) {
        print("gps")
        
        if (self.defaultLocationFlag) {
            print("default true")
        } else {
            print("default false ")
            
        }
        
    }
}
