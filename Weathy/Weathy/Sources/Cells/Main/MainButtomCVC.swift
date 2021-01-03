//
//  MainButtomCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainButtomCVC: UICollectionViewCell {
    //MARK: - IBOutlet
    
    @IBOutlet weak var timeZoneWeatherView: UIView!
    @IBOutlet weak var weeklyWeatherView: UIView!
    @IBOutlet weak var detailWeatherView: UIView!
    
    //MARK: - Life Cycle
    
    
    
    //MARK: - Custom Methods
    func setCell() {
        timeZoneWeatherView.backgroundColor = .white
        timeZoneWeatherView.makeRounded(cornerRadius: 35)
        timeZoneWeatherView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        weeklyWeatherView.backgroundColor = .white
        weeklyWeatherView.makeRounded(cornerRadius: 35)
        weeklyWeatherView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        detailWeatherView.backgroundColor = .white
        detailWeatherView.makeRounded(cornerRadius: 35)
        detailWeatherView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
    }
}
