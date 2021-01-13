//
//  CalendarVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarDetailVC: UIViewController {
    func selectedWeekDateDidChange(_ selectedDate: Date) {
        print("week")
        self.selectedDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "MM월 dd일 eeee"
        dateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    func selectedMonthDateDidChange(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "MM월 dd일 eeee"
        dateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    
    //MARK: - Custom Properties
    
    let screen = UIScreen.main.bounds
    let dateFormatter = DateFormatter()
    var clothesTopList = ["기모맨투맨투맨","히트텍하트","폴로니트니트니","메종 마르지엘라 사줘","이인애바보"]
    var clothesBottomList = ["기모맨투맨","히트텍","폴로니트","메종 마르지엘라 사줘","이인애요지랄"]
    var clothesOuterList = ["기모맨투맨","히트텍","마","메종 마르지엘라 사줘","이인애"]
    var clothesEtcList = ["기모맨투맨","히트텍","폴로니트","메종 ","이인애"]
    var blurView = UIView()
    var selectedDate = Date()
    var calendarVC: CalendarVC!
    
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
    @IBOutlet weak var commentLabel: SpacedLabel!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarVC = self.storyboard?.instantiateViewController(identifier: "CalendarVC") as? CalendarVC
        self.addChild(calendarVC)
        self.view.addSubview(calendarVC.view)
        calendarVC.didMove(toParent: self)
        calendarVC.view.backgroundColor = .clear
        detailTopConstraint.constant = self.screen.height*213/812
        let height = view.frame.height
        let width = view.frame.width
        calendarVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //        if let weekCell = calendarVC.infiniteWeeklyCV.cellForItem(at: [0,selectedDate.weekday]) as? InfiniteWeeklyCVC{
        //            weekCell.weekCellDelegate = self
        //            DispatchQueue.main.async {
        //
        //            }
        //        }
        setStyle()
        setData()
        setPopup()
        NotificationCenter.default.addObserver(self, selector: #selector(selectedDateDidChange(_:)), name: NSNotification.Name(rawValue: "ChangeDate"), object: nil)
//        initGestureRecognizer()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeMoreMenu(nil)
    }
    //MARK: - Custom Methods
    func initGestureRecognizer() {
        let moreBtnTap = UITapGestureRecognizer(target: self, action: #selector(closeMoreMenu(_:)))
        moreBtnTap.delegate = self
        self.view.addGestureRecognizer(moreBtnTap)
    }
    
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
        
        moreMenuView.alpha = 0
        moreViewHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
        
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "MM월 dd일 eeee"
        
        commentLabel.font = .SDGothicRegular15
        commentLabel.lineSetting(kernValue: -0.75, lineSpacing: 0, lineHeightMultiple: 1.17)
        commentLabel.textAlignment = .left
        
    }
    
    func setData(){
        clothesTagLabels[0].text = insertSeparatorInArray(clothesTopList)
        clothesTagLabels[1].text = insertSeparatorInArray(clothesBottomList)
        clothesTagLabels[2].text = insertSeparatorInArray(clothesOuterList)
        clothesTagLabels[3].text = insertSeparatorInArray(clothesEtcList)
        
        dateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    
    func insertSeparatorInArray(_ arr: [String]) -> String {
        return arr.joined(separator: "  ・  ")
    }
    
    func setPopup(){
        
        blurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        blurView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        
        let width = 309*screen.width/375
        let height = width/309*195
        
        let popupView = UIView()
        popupView.frame = CGRect(x: (screen.width-width)/2, y: (screen.height-height)/2, width: width, height: height)
        popupView.backgroundColor = .white
        popupView.makeRounded(cornerRadius: 15)
        popupView.dropShadow(color: UIColor(white: 39/255, alpha: 1), offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        
        blurView.addSubview(popupView)
        
        let titleLabel = SpacedLabel()
        titleLabel.text = "이 날의 웨디를 삭제할까요?"
        titleLabel.textColor = UIColor(red: 243.0 / 255.0, green: 113.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)
        titleLabel.font = .SDGothicSemiBold20
        titleLabel.characterSpacing = -1
        titleLabel.frame = CGRect(x: (popupView.frame.width-202)/2, y: 39*screen.width/375, width: 202, height: 28)
        
        popupView.addSubview(titleLabel)
        
        let warningLabel = SpacedLabel()
        warningLabel.text = "삭제하면 되돌릴 수 없어요."
        warningLabel.textColor = .subGrey6
        warningLabel.font = .SDGothicRegular16
        warningLabel.characterSpacing = -0.8
        warningLabel.frame = CGRect(x: (popupView.frame.width-158)/2, y: 73*screen.width/375, width: 158, height: 21)
        
        popupView.addSubview(warningLabel)
        
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "calendarFrameBack"), for: .normal)
        cancelButton.frame = CGRect(x: 29*screen.width/375, y: 121*screen.width/375, width: 119*screen.width/375, height: 47*screen.width/375)
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "calendarFrameDelete"), for: .normal)
        deleteButton.frame = CGRect(x: 161*screen.width/375, y: 121*screen.width/375, width: 119*screen.width/375, height: 47*screen.width/375)
        deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        popupView.addSubview(cancelButton)
        popupView.addSubview(deleteButton)
        
        
    }
    
    //MARK: - @objc methods
    
    @objc func closeMoreMenu(_ sender: UITapGestureRecognizer?){
        self.moreViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.2){
            self.view.layoutIfNeeded()
            self.moreMenuView.alpha = 0
        }
    }
    
    @objc func cancelAction(_ sender: Any){
        self.blurView.removeFromSuperview()
    }
    
    @objc func deleteAction(_ sender: Any){
        self.parent?.view.addSubview(self.blurView)
    }
    
    @objc func selectedDateDidChange(_ notification: NSNotification){
        selectedDate = notification.object as! Date
        dateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    //MARK: - IBActions
    
    @IBAction func moreBtnDidTap(_ sender: UIButton) {
        self.moreViewHeightConstraint.constant = 90
        UIView.animate(withDuration: 0.3){
            self.moreMenuView.alpha = 1
            self.view.layoutIfNeeded()
            
        }
    }
    @IBAction func editBtnDidTap(_ sender: Any) {
        
        //        guard let recordEdit = UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(identifier: "RecordVC") as? RecordVC else{ return }
        //        self.navigationController?.pushViewController(recordEdit, animated: true)
        
    }
    @IBAction func deleteBtnDidTap(_ sender: Any) {
        closeMoreMenu(nil)
        self.parent?.view.addSubview(blurView)
        
    }
    
}

extension CalendarDetailVC{
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.moreMenuView))! {
            
            return true
        }
        if (touch.view?.isDescendant(of: self.calendarVC.calendarDrawerView))!{
            return true
        }
        return false
    }
}
