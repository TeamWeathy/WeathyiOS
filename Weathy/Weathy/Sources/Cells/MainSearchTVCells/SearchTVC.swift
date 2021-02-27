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
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var weatherTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weahterImage: UIImageView!
    @IBOutlet weak var currentTemper: UILabel!
    @IBOutlet weak var highTemper: UILabel!
    @IBOutlet weak var lowTemper: UILabel!
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
        self.weatherDate.text = weatherDate
        self.weatherTime.text = weahterTime
        self.location.text = location
        self.weahterImage.image = UIImage(named: weatherImage)
        self.currentTemper.text = currentTemper
        self.highTemper.text = highTemper
        self.lowTemper.text = " \(lowTemper)"
    }
    
    func shadowSet(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = .white
        radiusView.dropShadow(color: .gray, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 1.5)
    }
    
    func textFont(){
        weatherDate.font = UIFont.SDGothicRegular15
        weatherDate.textColor = UIColor.subGrey1
        location.font = UIFont.SDGothicSemiBold17
        location.textColor = UIColor.subGrey1
        weatherTime.font = UIFont.SDGothicRegular15
        currentTemper.font = UIFont.RobotoLight50
        highTemper.font = UIFont.RobotoLight23
        lowTemper.font = UIFont.RobotoLight23
    }
    
    func textColor(){
        highTemper.textColor = .redTemp
        lowTemper.textColor = .blueTemp
    }
    
    // MARK: - Action
    
}



