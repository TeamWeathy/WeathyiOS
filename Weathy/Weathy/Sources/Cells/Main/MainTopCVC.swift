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
    @IBOutlet weak var weathyHighTemperatureLabel: SpacedLabel!
    @IBOutlet weak var weathyLowTemperatureLabel: SpacedLabel!
    @IBOutlet weak var weathyStampImage: UIImageView!
    @IBOutlet weak var weathyStampLabel: SpacedLabel!
    @IBOutlet weak var closetTopLabel: SpacedLabel!
    @IBOutlet weak var closetBottomLabel: SpacedLabel!
    @IBOutlet weak var closetOuterLabel: SpacedLabel!
    @IBOutlet weak var closetEtcLabel: SpacedLabel!
    
    //MARK: - Custom Methods
    func setCell() {
        closetTopLabel.text = insertSeparatorInArray(closetTop)
        closetTopLabel.font = UIFont.SDGothicRegular13
        closetTopLabel.textColor = UIColor.black
        closetTopLabel.characterSpacing = -0.65
        
        closetOuterLabel.text = insertSeparatorInArray(closetOuter)
        closetOuterLabel.font = UIFont.SDGothicRegular13
        closetOuterLabel.textColor = UIColor.black
        closetOuterLabel.characterSpacing = -0.65
        
        closetBottomLabel.text = insertSeparatorInArray(closetBottom)
        closetBottomLabel.font = UIFont.SDGothicRegular13
        closetBottomLabel.textColor = UIColor.black
        closetBottomLabel.characterSpacing = -0.65

        closetEtcLabel.text = insertSeparatorInArray(closetEtc)
        closetEtcLabel.font = UIFont.SDGothicRegular13
        closetEtcLabel.textColor = UIColor.black
        closetEtcLabel.characterSpacing = -0.65

        todayWeathyNicknameTextLabel.font = UIFont.SDGothicRegular16
        todayWeathyNicknameTextLabel.text = "희지님이 기억하는"
        todayWeathyNicknameTextLabel.characterSpacing = -0.8
        
        todayWeathyView.makeRounded(cornerRadius: 35)
        todayWeathyView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.21, radius: 50)
        
        locationLabel.text = "서울 서대문구"
        locationLabel.font = UIFont.SDGothicSemiBold20
        locationLabel.textColor = UIColor.mainGrey
        locationLabel.characterSpacing = -1.0
        
        currTempLabel.text = "-2°"
        currTempLabel.font = UIFont.RobotoLight60
        currTempLabel.textColor = UIColor.subGrey1
        currTempLabel.characterSpacing = -3.0
        
        maxTempLabel.text = "24°"
        maxTempLabel.font = UIFont.RobotoLight25
        maxTempLabel.textColor = UIColor.redTemp
        maxTempLabel.characterSpacing = -1.25
        
        minTempLabel.text = "-14°"
        minTempLabel.font = UIFont.RobotoLight25
        minTempLabel.textColor = UIColor.blueTemp
        minTempLabel.characterSpacing = -1.25
        
        climateLabel.text = "겹겹이 입기 좋은 날씨"
        climateLabel.font = UIFont.SDGothicRegular16
        climateLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.58)
        climateLabel.characterSpacing = -0.8
        
        weathyDateLabel.text = "2020년 12월 1일"
        weathyDateLabel.font = UIFont.SDGothicRegular13
        weathyDateLabel.textColor = UIColor.subGrey6
        weathyDateLabel.characterSpacing = -0.65
        
        weathyClimateImage.image = UIImage(named: "ic_fewclouds_day")
        
        weathyClimateLabel.text = "구름조금"
        weathyClimateLabel.font = UIFont.SDGothicMedium15
        weathyClimateLabel.textColor = UIColor.subGrey1
        weathyClimateLabel.characterSpacing = -1.15
        
        weathyHighTemperatureLabel.text = "4°"
        weathyHighTemperatureLabel.textColor = UIColor.redTemp
        weathyHighTemperatureLabel.font = UIFont.RobotoLight30
        weathyHighTemperatureLabel.characterSpacing = -1.75
        
        weathyLowTemperatureLabel.text = "-4°"
        weathyLowTemperatureLabel.textColor = UIColor.blueTemp
        weathyLowTemperatureLabel.font = UIFont.RobotoLight30
        weathyLowTemperatureLabel.characterSpacing = -1.75
        
        
//        weathyStampImage.image = UIImage(named: <#T##String#>)
        weathyStampLabel.text = "추워요"
        weathyStampLabel.font = UIFont.SDGothicSemiBold23
        weathyStampLabel.textColor = UIColor.imojiColdText
        weathyStampLabel.characterSpacing = -1.15
    }
    
    func insertSeparatorInArray(_ arr: [String]) -> String {
        return arr.joined(separator: "  ・  ")
    }
}
