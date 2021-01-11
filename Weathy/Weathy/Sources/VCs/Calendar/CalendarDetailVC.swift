//
//  CalendarVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarDetailVC: UIViewController,WeekCellDelegate,MonthCellDelegate {
    func selectedWeekDateDidChange(_ selectedDate: Date) {
        print()
    }
    
    func selectedMonthDateDidChange(_ selectedDate: Date) {
        print()
    }
    
    
    //MARK: - Custom Properties
    
    let screen = UIScreen.main.bounds
    
    var clothesTopList = ["기모맨투맨","히트텍","폴로니트","메종 마르지엘라 사줘","이인애"]
    var clothesBottomList = ["기모맨투맨","히트텍","폴로니트","메종 마르지엘라 사줘","이인애"]
    var clothesOuterList = ["기모맨투맨","히트텍","마","메종 마르지엘라 사줘","이인애"]
    var clothesEtcList = ["기모맨투맨","히트텍","폴로니트","메종 ","이인애"]
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var detailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var climateImageView: UIImageView!
    @IBOutlet weak var detailEmptyImageView: UIImageView!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var emojiLabel: SpacedLabel!
    @IBOutlet weak var dateLabel: SpacedLabel!
    @IBOutlet weak var locationLabel: SpacedLabel!
    @IBOutlet weak var climateLabel: SpacedLabel!
    @IBOutlet weak var temperatureHighLabel: SpacedLabel!
    @IBOutlet weak var temperatureLowLabel: SpacedLabel!
    @IBOutlet var clothesTagLabels: [SpacedLabel]!
    @IBOutlet var clothesTagTitleLabels: [SpacedLabel]!
    @IBOutlet weak var moreMenuView: UIView!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let calendarVC = self.storyboard?.instantiateViewController(identifier: "CalendarVC") as? CalendarVC else{
            return
        }
        self.addChild(calendarVC)
        self.view.addSubview(calendarVC.view)
        calendarVC.didMove(toParent: self)
        calendarVC.view.backgroundColor = .clear
        detailTopConstraint.constant = self.screen.height*213/812
        let height = view.frame.height
        let width = view.frame.width
        calendarVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        setStyle()
        setData()

    }
    
    //MARK: - Custom Methods
    
    func setStyle(){
        dateLabel.textColor = .subGrey1
        dateLabel.font = .SDGothicRegular15
        
        locationLabel.textColor = .mainGrey
        locationLabel.font = .SDGothicMedium15
        
        climateLabel.textColor = .mainGrey
        climateLabel.font = .SDGothicMedium15
        
        temperatureHighLabel.textColor = .redTemp
        temperatureHighLabel.font = UIFont(name: "Roboto-Light", size: 35)
        
        temperatureLowLabel.textColor = .blueTemp
        temperatureLowLabel.font = UIFont(name: "Roboto-Light", size: 35)
        
        emojiLabel.textColor = .imojiGootText
        emojiLabel.font = .SDGothicSemiBold23
        
        for titleLabel in clothesTagTitleLabels{
            titleLabel.font = .SDGothicRegular13
            titleLabel.characterSpacing = -0.65
            titleLabel.textColor = .subGrey6
        }
        for tagLabel in clothesTagLabels{
            tagLabel.font = .SDGothicRegular13
            tagLabel.characterSpacing = -0.65
        }
        
        moreMenuView.layer.cornerRadius = 10
        moreMenuView.dropShadow(color: UIColor(red: 0.184, green: 0.325, blue: 0.486, alpha: 1), offSet: CGSize(width: 0, height: 0), opacity: 0.13, radius: 15)
        
        moreMenuView.isHidden = true
        moreViewHeightConstraint.constant = 0
        
    }
    
    func setData(){
        clothesTagLabels[0].text = insertSeparatorInArray(clothesTopList)
        clothesTagLabels[1].text = insertSeparatorInArray(clothesBottomList)
        clothesTagLabels[2].text = insertSeparatorInArray(clothesOuterList)
        clothesTagLabels[3].text = insertSeparatorInArray(clothesEtcList)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moreBtn.isSelected{
            UIView.animate(withDuration: 0.3){
                self.moreViewHeightConstraint.constant = 0
                self.moreMenuView.isHidden = true
                self.moreBtn.isSelected = false
            }
        }
    }
    
    func insertSeparatorInArray(_ arr: [String]) -> String {
            return arr.joined(separator: "  ・  ")
        }
    
    //MARK: - IBActions
    
    @IBAction func moreBtnDidTap(_ sender: UIButton) {
        sender.isSelected = true
        UIView.animate(withDuration: 0.3){
            self.moreMenuView.isHidden = false
            self.moreViewHeightConstraint.constant = 90
        }
    }
    @IBAction func editBtnDidTap(_ sender: Any) {
    }
    @IBAction func deleteBtnDidTap(_ sender: Any) {
    }
    
}
