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
        setStyle()
        
    }
    func setClimate(_ climateId: Int){
        climateIconImageView.alpha = 1
        climateIconImageView.image = UIImage(named: ClimateImage.getClimateAssetName(climateId))
    }
    func setStyle(){
        self.contentView.alpha = 1
        
        dividerView.alpha = 1
        
        temperatureDividerView.alpha = 0
        
        dayLabel.backgroundColor = .clear
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        dayLabel.clipsToBounds = true
        dayLabel.layer.cornerRadius = dayLabel.frame.height / 2
        dayLabel.textColor = .mainGrey
        
        highLabel.text = ""
        highLabel.alpha = 0
        highLabel.textColor = .redTemp
        highLabel.font = .RobotoRegular12
        highLabel.characterSpacing = -0.6
        
        lowLabel.text = ""
        lowLabel.alpha = 0
        lowLabel.textColor = .blueTemp
        lowLabel.font = .RobotoRegular12
        lowLabel.characterSpacing = -0.6
        
        climateIconImageView.alpha = 0
    }
    func setSelectedDay(){
        dayLabel.backgroundColor = .subGrey5
        dayLabel.setBorder(borderColor: .greyBorder, borderWidth: 1)
    }
    func setToday(){
        dayLabel.backgroundColor = .mintMain
        dayLabel.setBorder(borderColor: .mintBorder, borderWidth: 1)
        dayLabel.textColor = .white
    }
    
    func setNonCurrent(){
        
//        dayLabel.textColor = .subGrey3
        self.contentView.alpha = 0.4

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
        highLabel.alpha = 1
        lowLabel.alpha = 1
        highLabel.text = "\(high)°"
        lowLabel.text = "\(low)°"
        
        temperatureDividerView.alpha = 1
    }
    
    
}
