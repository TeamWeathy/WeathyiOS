//
//  DetailWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/10.
//

import UIKit

class ExtraWeatherCVC: UICollectionViewCell {
    //MARK: - local Variables
    static let identifier = "ExtraWeatherCVC"
    
    //MARK: - IBOutlets
    @IBOutlet weak var detailPropertyImage: UIImageView!
    @IBOutlet weak var detailPropertyLabel: SpacedLabel!
    @IBOutlet weak var detailValueLabel: SpacedLabel!
    @IBOutlet weak var detailRatingLabel: SpacedLabel!
    
    //MARK: - Custom Methods
    func setCell() {
        detailPropertyLabel.font = UIFont.SDGothicSemiBold13
        detailPropertyLabel.textColor = UIColor.subGrey6
        detailPropertyLabel.characterSpacing = -0.65
        
        detailValueLabel.font = UIFont.SDGothicMedium15
        detailValueLabel.textColor = UIColor.subGrey1
        detailValueLabel.characterSpacing = -0.75
        
        detailRatingLabel.font = UIFont.RobotoRegular11
        detailRatingLabel.textColor = UIColor.subGrey6
        detailRatingLabel.characterSpacing = -0.55
    }
    
    func setExtraWeatherData(data: ExtraData, type: ExtraType) {
        switch type {
        case .rain:
            detailRatingLabel.text = "\(data.value)mm"
            detailPropertyLabel.text = "강수량"
            detailPropertyImage.image = UIImage(named: "icRainfall")
        case .wind:
            detailRatingLabel.text = "\(data.value)m/s"
            detailPropertyLabel.text = "풍속"
            detailPropertyImage.image = UIImage(named: "icWiindspeed")
        case .humidity:
            detailRatingLabel.text = "\(data.value)%"
            detailPropertyLabel.text = "습도"
            detailPropertyImage.image = UIImage(named: "icHumidity")
        }
        
        detailValueLabel.text = getWeatherDegree(rating: data.rating, type: type)
    }
    
    func getWeatherDegree(rating: Int, type: ExtraType) -> String {
        switch type {
        case .rain:
            switch rating {
            case 1:
                return "매우 조금"
            case 2:
                return "조금"
            case 3:
                return "보통"
            case 4:
                return "다소 많음"
            case 5:
                return "많음"
            case 6:
                return "매우 많음"
            default:
                return ""
            }
        case .wind:
            switch rating {
            case 1:
                return "매우 약함"
            case 2:
                return "약함"
            case 3:
                return "보통"
            case 4:
                return "다소 강함"
            case 5:
                return "강함"
            case 6:
                return "매우 강함"
            default:
                return ""
            }
        case .humidity:
            switch rating {
            case 1:
                return "매우 건조"
            case 2:
                return "건조"
            case 3:
                return "적정"
            case 4:
                return "습함"
            case 5:
                return "매우 습함"
            default:
                return ""
            }
        }
    }
}
