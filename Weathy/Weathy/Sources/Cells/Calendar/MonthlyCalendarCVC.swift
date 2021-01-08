//
//  MonthlyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class MonthlyCalendarCVC: UICollectionViewCell {
    
    static let identifier = "MonthlyCalendarCVC"
    
    @IBOutlet weak var dayLabel: SpacedLabel!
    @IBOutlet weak var highImageView: UIImageView!
    @IBOutlet weak var lowImageView: UIImageView!
    @IBOutlet weak var highLabel: SpacedLabel!
    @IBOutlet weak var lowLabel: SpacedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.backgroundColor = .clear
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        highLabel.alpha = 0
        lowLabel.alpha = 0
        highImageView.alpha = 0
        lowImageView.alpha = 0
        
    }

    
    func setToday(){
        dayLabel.clipsToBounds = true
        dayLabel.backgroundColor = .mintMain
        dayLabel.layer.cornerRadius = 13.5
        dayLabel.textColor = .white
    }
    
    func setNonCurrent(){

        dayLabel.textColor = .subGrey3
        highImageView.image = UIImage(named: "calendarImgHighWhite")
        lowImageView.image = UIImage(named: "calendarImgLowWhite")

    }
    
    func setDay(){
        dayLabel.textColor = .mainGrey
        highImageView.image = UIImage(named:"calendarImgHigh")
        lowImageView.image = UIImage(named: "calendarImgLow")
    }
    
    func setData(_ high: Int, _ low: Int){
        highImageView.alpha = 1
        lowImageView.alpha = 1
        highLabel.alpha = 1
        lowLabel.alpha = 1
        highLabel.text = "\(high)º"
        lowLabel.text = "\(low)º"
    }
}
