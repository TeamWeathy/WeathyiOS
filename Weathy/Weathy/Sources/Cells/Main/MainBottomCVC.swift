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
    @IBOutlet weak var WeeklyCenterY: NSLayoutConstraint!
    @IBOutlet weak var mainBottomScrollView: UIScrollView!
    
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
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.alpha = 0
            self.weeklyWeatherView.alpha = 0
                        
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewScrollDown() {
        self.timeZoneCenterY.constant = 21
        self.WeeklyCenterY.constant = 24
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.overrideInheritedCurve],animations: {
            self.timeZoneWeatherView.alpha = 1
            self.weeklyWeatherView.alpha = 1
            
            self.layoutIfNeeded()
        })
    }
    
    //MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height

        self.layoutIfNeeded()
    }
}
