//
//  MonthlyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class MonthlyCalendarCVC: UICollectionViewCell {
    
    static let identifier = "MonthlyCalendarCVC"
    var isToday: Bool = false
    override var isSelected: Bool{
        didSet{
            if isSelected{
                if isToday{
                    setToday()
                }
                else{
                    setSelectedDay()
                }
                
            }
            else{
                dayLabel.backgroundColor = .white
                dayLabel.setBorder(borderColor: .clear, borderWidth: 0)
            }
        }
    }
    
    
    @IBOutlet weak var climateIconImageView: UIImageView!
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var dayLabel: SpacedLabel!
    @IBOutlet weak var highLabel: SpacedLabel!
    @IBOutlet weak var lowLabel: SpacedLabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dayLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureDividerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureDividerView: UIImageView!
    @IBOutlet weak var climateIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var climateIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isToday = false
        climateIconImageView.image = nil
    }
    func setClimate(_ climateId: Int){
        climateIconImageView.alpha = 1
        climateIconImageView.image = UIImage(named: ClimateImage.getClimateAssetName(climateId))
    }
    func setStyle(monthlyLines: Int, hasNotch: Bool){
        self.contentView.alpha = 1
        
        dividerView.alpha = 1
        temperatureView.alpha = 0
        temperatureDividerView.alpha = 0
        
        dayLabel.backgroundColor = .clear
        dayLabel.clipsToBounds = true
        dayLabel.layer.cornerRadius = dayLabel.frame.height / 2
        dayLabel.textColor = .mainGrey
        dayLabel.alpha = 1
        
        highLabel.text = ""
        highLabel.textColor = .redTemp
        highLabel.characterSpacing = -0.6
        
        lowLabel.text = ""
        lowLabel.textColor = .blueTemp
        lowLabel.characterSpacing = -0.6
        
        climateIconImageView.image = nil
        
        if hasNotch{
            temperatureDividerWidthConstraint.constant = 14
            
            dayLabel.font = UIFont(name: "Roboto-Medium", size: 13)
            highLabel.font = .RobotoRegular12
            lowLabel.font = .RobotoRegular12
            climateIconWidthConstraint.constant = 25
            temperatureWidthConstraint.constant = 30
            dayLabelWidthConstraint.constant = 23
            if monthlyLines == 4{
                climateIconTopConstraint.constant = 3
                temperatureViewTopConstraint.constant = 7
            }
            else if monthlyLines == 5{
                climateIconTopConstraint.constant = 2
                temperatureViewTopConstraint.constant = 6.5
                temperatureWidthConstraint.constant = 30
            }
            else if monthlyLines == 6{
                climateIconTopConstraint.constant = 2
                temperatureViewTopConstraint.constant = 1.6
            }
            
        }
        ///아이폰8 , 아이폰 SE
        else{
            temperatureDividerWidthConstraint.constant = 9
            
            dayLabel.font = UIFont(name: "Roboto-Medium", size: 11)
            highLabel.font = UIFont(name: "Roboto-Regular", size: 9)
            lowLabel.font = UIFont(name: "Roboto-Regular", size: 9)
            climateIconWidthConstraint.constant = 19
            dayLabelWidthConstraint.constant = 17
            temperatureViewTopConstraint.constant = 2.6
            if monthlyLines == 4{
                climateIconTopConstraint.constant = 6
            }
            else if monthlyLines == 5{
                climateIconTopConstraint.constant = 5
            }
            else if monthlyLines == 6{
                climateIconTopConstraint.constant = 1
            }
        }
        
    }
    func setSelectedDay(){
        dayLabel.backgroundColor = .subGrey5
        dayLabel.setBorder(borderColor: .greyBorder, borderWidth: 1)
    }
    func setToday(){
        dayLabel.backgroundColor = .mintMain
        dayLabel.setBorder(borderColor: .mintBorder, borderWidth: 1)
        dayLabel.textColor = .white
        dayLabel.alpha = 1
    }
    
    func setNonCurrent(){
        
//        dayLabel.textColor = .subGrey3
        dayLabel.alpha = 0.4
        climateIconImageView.alpha = 0.4
        temperatureView.alpha = 0.4
    }
    
    func setDay(){
        dayLabel.textColor = .mainGrey
        highLabel.text = ""
        lowLabel.text = ""
    }
    
    func setRedday(){
        dayLabel.textColor = .dateRedday
    }
    
    func setSaturday(){
        dayLabel.textColor = .dateSaturday
    }
    
    func setData(high: Int, low: Int){
        highLabel.text = "\(high)°"
        lowLabel.text = "\(low)°"
        climateIconImageView.alpha = 1
        temperatureView.alpha = 1
        temperatureDividerView.alpha = 1
    }
    
    
}
