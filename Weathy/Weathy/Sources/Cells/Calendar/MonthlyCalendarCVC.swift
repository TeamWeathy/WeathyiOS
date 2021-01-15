//
//  MonthlyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class MonthlyCalendarCVC: UICollectionViewCell {
    
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
    @IBOutlet weak var highImageView: UIImageView!
    @IBOutlet weak var lowImageView: UIImageView!
    @IBOutlet weak var highLabel: SpacedLabel!
    @IBOutlet weak var lowLabel: SpacedLabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var layoutTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.backgroundColor = .clear
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        dayLabel.clipsToBounds = true
        dayLabel.layer.cornerRadius = 11.5
        dayLabel.textColor = .mainGrey
        
        highLabel.text = ""
        highLabel.textColor = .white
        lowLabel.text = ""
        highLabel.alpha = 0
        lowLabel.textColor = .white
        lowLabel.alpha = 0
        
        highImageView.alpha = 0
        highImageView.image = UIImage(named:"calendarImgHigh")
        
        lowImageView.alpha = 0
        lowImageView.image = UIImage(named: "calendarImgLow")
        
        
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
        
        highImageView.alpha = 0
        highImageView.image = UIImage(named:"calendarImgHigh")
        
        lowImageView.alpha = 0
        lowImageView.image = UIImage(named: "calendarImgLow")
        
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
        highImageView.image = UIImage(named: "calendarImgHighWhite")
        lowImageView.image = UIImage(named: "calendarImgLowWhite")

    }
    
    func setDay(){
        dayLabel.textColor = .mainGrey
        highImageView.image = UIImage(named:"calendarImgHigh")
        lowImageView.image = UIImage(named: "calendarImgLow")
        highImageView.alpha = 0
        lowImageView.alpha = 0
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
        highImageView.alpha = 1
        lowImageView.alpha = 1
        highLabel.alpha = 1
        lowLabel.alpha = 1
        highLabel.text = "\(high)°"
        lowLabel.text = "\(low)°"
    }
    
    
}
