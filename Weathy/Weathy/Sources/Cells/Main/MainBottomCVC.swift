//
//  MainBottomCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainBottomCVC: UICollectionViewCell {
    //MARK: - IBOutlet
    
    @IBOutlet weak var timeZoneWeatherView: UIView!
    @IBOutlet weak var weeklyWeatherView: UIView!
    @IBOutlet weak var detailWeatherView: UIView!
    
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
    
    func viewScrollUp() {
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: nil)
    }
    
    func viewScrollDown() {
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}
