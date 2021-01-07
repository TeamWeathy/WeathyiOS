//
//  MonthlyCalendarCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class MonthlyCalendarCVC: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: SpacedLabel!
    @IBOutlet weak var highImageView: UIImageView!
    @IBOutlet weak var lowImageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setStyle(){
        dayLabel.font = UIFont(name: "Roboto-Medium", size: 16)
    }
}
