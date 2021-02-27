//
//  SearchTVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/12.
//

import UIKit

class SearchTVC: UITableViewCell {
    
    //MARK: - Custom Variables
    
    static let identifier = "SearchTVC"
    
    var leadingConstraint: NSLayoutConstraint!
    var deletTrailingConstraint: NSLayoutConstraint!

    //MARK: - IBOutlets
    
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weahterImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var slashLabel: UILabel!
    
    //MARK: - LifeCycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowSet()
        textColor()
        textFont()
    }

    //MARK: - @objc Methods
    
    func bind(weatherDate: String, weahterTime: String, location: String, weatherImage: String, currentTemper: String, highTemper: String, lowTemper: String){
        self.dateLabel.text = weatherDate
        self.weatherTimeLabel.text = weahterTime
        self.locationLabel.text = location
        self.weahterImageView.image = UIImage(named: weatherImage)
        self.currentTempLabel.text = currentTemper
        self.highTempLabel.text = highTemper
        self.lowTempLabel.text = " \(lowTemper)"
    }
    
    func shadowSet(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = .white
        radiusView.dropShadow(color: .gray, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 1.5)
    }
    
    func textFont(){
        dateLabel.font = UIFont.SDGothicRegular15
        dateLabel.textColor = UIColor.subGrey1
        locationLabel.font = UIFont.SDGothicSemiBold17
        locationLabel.textColor = UIColor.subGrey1
        weatherTimeLabel.font = UIFont.SDGothicRegular15
        currentTempLabel.font = UIFont.RobotoLight50
        highTempLabel.font = UIFont.RobotoLight23
        lowTempLabel.font = UIFont.RobotoLight23
    }
    
    func textColor(){
        highTempLabel.textColor = .redTemp
        lowTempLabel.textColor = .blueTemp
    }
    
    // MARK: - Action
    
}



