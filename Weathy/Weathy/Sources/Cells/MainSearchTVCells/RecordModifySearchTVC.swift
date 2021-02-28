//
//  RecordModifySearchCell.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/02/27.
//

import UIKit

class RecordModifySearchTVC: UITableViewCell {
    
    //MARK: - Custom Variables
    static let identifier = "RecordModifySearchTVC"
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var weatherDateLabel: SpacedLabel!
    @IBOutlet weak var locationLabel: SpacedLabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var maxTempLabel: SpacedLabel!
    @IBOutlet weak var minTempLabel: SpacedLabel!
    @IBOutlet weak var slashLabel: UILabel!
    
    //MARK: - LifeCycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setRadiusView()
        textColor()
        textFont()
        setSlashLabel()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecordModifySearchTVC {
    func bind(weatherDate: String, location: String, weatherImage: String, highTemper: String, lowTemper: String){
        self.weatherDateLabel.text = weatherDate
        self.locationLabel.text = location
        self.weatherImageView.image = UIImage(named: weatherImage)
        self.maxTempLabel.text = highTemper
        self.minTempLabel.text = "\(lowTemper)"
    }
    
    func setRadiusView(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = UIColor.white.withAlphaComponent(0.75)
        radiusView.setBorder(borderColor: .subGrey7, borderWidth: 1)
        
    }
    
    func textFont(){
        weatherDateLabel.font = UIFont.SDGothicRegular15
        weatherDateLabel.characterSpacing = -0.75
        locationLabel.font = UIFont.SDGothicSemiBold17
        locationLabel.characterSpacing = -0.85
        maxTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        maxTempLabel.characterSpacing = -2.0
        minTempLabel.font = UIFont(name: "Roboto-Light", size: 40)
        maxTempLabel.characterSpacing = -2.0
    }
    
    func textColor(){
        locationLabel.textColor = UIColor.subGrey1
        weatherDateLabel.textColor = .subGrey1
        maxTempLabel.textColor = .redTemp
        minTempLabel.textColor = .blueTemp
    }
    
    func setSlashLabel() {
        slashLabel.text = "/"
        slashLabel.font = UIFont(name: "Roboto-Regular", size: 23)
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        slashLabel.baselineAdjustment = .alignBaselines
    }
}
