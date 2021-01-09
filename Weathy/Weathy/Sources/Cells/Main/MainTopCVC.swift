//
//  MainTopCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainTopCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    @IBOutlet weak var todayWeathyNicknameTextLabel: UILabel!
    @IBOutlet weak var todayWeathyView: UIView!
    @IBOutlet weak var currTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: - Custom Methods
    func setCell() {
        todayWeathyNicknameTextLabel.font = UIFont.SDGothicRegular16
        todayWeathyNicknameTextLabel.text = "희지님이 기억하는"
        
        todayWeathyView.makeRounded(cornerRadius: 35)
        todayWeathyView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.21, radius: 50)
        
        locationLabel.text = "서울 서대문구"
        locationLabel.font = UIFont.SDGothicSemiBold20
        locationLabel.textColor = UIColor.mainGrey
        
        currTemperatureLabel.text = "2°"
        currTemperatureLabel.font = UIFont.RobotoLight60
        currTemperatureLabel.textColor = UIColor.subGrey1
        
        highTemperatureLabel.text = "4°"
        highTemperatureLabel.font = UIFont.RobotoLight25
        highTemperatureLabel.textColor = UIColor.redTemp
        
        lowTemperatureLabel.text = "-4°"
        lowTemperatureLabel.font = UIFont.RobotoLight25
        lowTemperatureLabel.textColor = UIColor.blueTemp
        
        climateLabel.text = "조금 흐리지만\n햇살이 따스해요 :)"
        climateLabel.font = UIFont.SDGothicRegular16
        climateLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.58)
    }
}
