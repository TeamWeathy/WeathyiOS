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
    
    //MARK: - Custom Methods
    func setCell() {
        todayWeathyNicknameTextLabel.font = UIFont.SDGothicRegular20
        todayWeathyNicknameTextLabel.text = "희지님이 기억하는"
        
        todayWeathyView.makeRounded(cornerRadius: 35)
        todayWeathyView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.21, radius: 50)
    }
}
