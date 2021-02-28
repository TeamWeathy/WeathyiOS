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
    @IBOutlet weak var dateLabel: SpacedLabel!
    @IBOutlet weak var weatherTimeLabel: SpacedLabel!
    @IBOutlet weak var locationLabel: SpacedLabel!
    @IBOutlet weak var weahterImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: SpacedLabel!
    @IBOutlet weak var maxTempLabel: SpacedLabel!
    @IBOutlet weak var minTempLabel: SpacedLabel!
    @IBOutlet weak var slashLabel: UILabel!
    
    //MARK: - LifeCycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRadiusView()
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
        self.maxTempLabel.text = highTemper
        self.minTempLabel.text = " \(lowTemper)"
    }
    
    func setRadiusView(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = UIColor.white.withAlphaComponent(0.75)
        radiusView.setBorder(borderColor: .subGrey7, borderWidth: 1)
    }
    
    func textFont(){
        dateLabel.font = UIFont.SDGothicRegular15
        dateLabel.characterSpacing = -0.75
        locationLabel.font = UIFont.SDGothicSemiBold17
        locationLabel.characterSpacing = -0.85
        weatherTimeLabel.font = UIFont.SDGothicRegular15
        weatherTimeLabel.characterSpacing = -0.75
        currentTempLabel.font = UIFont.RobotoLight50
        maxTempLabel.font = UIFont.RobotoLight23
        minTempLabel.font = UIFont.RobotoLight23
    }
    
    func textColor(){
        dateLabel.textColor = .subGrey1
        locationLabel.textColor = .mainGrey
        weatherTimeLabel.textColor = .subGrey1
        currentTempLabel.textColor = .subGrey1
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        maxTempLabel.textColor = .redTemp
        minTempLabel.textColor = .blueTemp
    }
    
    // MARK: - Action
    
}



