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
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var highTemper: UILabel!
    @IBOutlet weak var lowTemper: UILabel!
    @IBOutlet weak var slashLabel: UILabel!
    
    //MARK: - LifeCycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowSet()
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
        self.weatherDate.text = weatherDate
        self.location.text = location
        self.weatherImage.image = UIImage(named: weatherImage)
        self.highTemper.text = highTemper
        self.lowTemper.text = "\(lowTemper)"
    }
    
    func shadowSet(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = .white
        radiusView.setBorder(borderColor: .subGrey7, borderWidth: 1)
    }
    
    func textFont(){
        weatherDate.font = UIFont.SDGothicRegular15
        weatherDate.textColor = UIColor.subGrey1
        location.font = UIFont.SDGothicSemiBold17
        location.textColor = UIColor.subGrey1
        highTemper.font = UIFont(name: "Roboto-Light", size: 40)
        lowTemper.font = UIFont(name: "Roboto-Light", size: 40)
    }
    
    func textColor(){
        highTemper.textColor = .redTemp
        lowTemper.textColor = .blueTemp
    }
    
    func setSlashLabel() {
        slashLabel.text = "/"
        slashLabel.font = UIFont(name: "Roboto-Regular", size: 23)
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        slashLabel.baselineAdjustment = .alignBaselines
    }
}
