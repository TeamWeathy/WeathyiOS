//
//  MonthlyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class MonthlyCalendarCVC: UICollectionViewCell {
    
    @IBOutlet weak var climateIconImageView: UIImageView!
    @IBOutlet weak var temperatureView: UIView!
    static let identifier = "MonthlyCalendarCVC"
    var isToday = false
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
    
    
    @IBOutlet weak var dayLabel: SpacedLabel!
    @IBOutlet weak var highLabel: SpacedLabel!
    @IBOutlet weak var lowLabel: SpacedLabel!
    @IBOutlet weak var dividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.backgroundColor = .clear
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        dayLabel.clipsToBounds = true
        dayLabel.layer.cornerRadius = 11.5
        dayLabel.textColor = .mainGrey
        
        highLabel.text = ""
        highLabel.textColor = .redTemp
        lowLabel.text = ""
        highLabel.alpha = 0
        lowLabel.textColor = .blueTemp
        lowLabel.alpha = 0
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isToday = false
        dividerView.alpha = 1
        dayLabel.backgroundColor = .clear
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        dayLabel.clipsToBounds = true
        dayLabel.layer.cornerRadius = 11.5
        dayLabel.textColor = .mainGrey
        highLabel.text = ""
        lowLabel.text = ""
        highLabel.alpha = 0
        
        lowLabel.alpha = 0
        
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

        dayLabel.textColor = .subGrey3

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
    }
    
    
}
