//
//  WeeklyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class WeeklyCalendarCVC: UICollectionViewCell {
    static let identifier = "WeeklyCalendarCVC"
    override var isSelected: Bool{
        didSet{
            if isSelected{
                setSelectedDay()
            }
            else{
                selectedView.alpha = 0
            }
        }
    }
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: SpacedLabel!
    @IBOutlet weak var emotionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        dayLabel.textColor = .mainGrey
        selectedView.clipsToBounds = true
        selectedView.layer.cornerRadius = 21
        emotionView.clipsToBounds = true
        emotionView.layer.cornerRadius = 7.5
        selectedView.alpha = 0
        
    }
    
    func setGreyDay(){
        dayLabel.textColor = .subGrey3
    }
    func setToday(){
        selectedView.backgroundColor = .mintMain
        selectedView.setBorder(borderColor: .mintBorder, borderWidth: 1)
        dayLabel.textColor = .white
        selectedView.alpha = 1
    }
    func setSelectedDay(){
        selectedView.alpha = 1
        selectedView.backgroundColor = .subGrey5
        selectedView.setBorder(borderColor: .greyBorder, borderWidth: 1)
    }
    func setRedDay(){
        dayLabel.textColor = .dateRedday
    }
    func setSaturday(){
        dayLabel.textColor = .dateSaturday
    }
}
