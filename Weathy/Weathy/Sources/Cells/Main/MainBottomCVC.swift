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
    @IBOutlet weak var timeZoneCenterY: NSLayoutConstraint!
    
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
//        timeZoneCenterY.constant = 21
        
//        UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveLinear], animations: {
//            self.timeZoneWeatherView.transform = CGAffineTransform(translationX: 0, y: 100)
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneCenterY.constant = 250
            self.timeZoneWeatherView.alpha = 0
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewScrollDown() {
//        self.timeZoneCenterY.constant = 300
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneCenterY.constant = 21
            self.timeZoneWeatherView.alpha = 1
            
            self.layoutIfNeeded()
        }, completion: nil)
//        UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveLinear], animations: {
//            self.timeZoneWeatherView.transform = CGAffineTransform(translationX: 0, y: 0)
//        }, completion: nil)
    }
}
