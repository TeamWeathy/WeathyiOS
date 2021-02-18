//
//  CalendarPartialVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarVC: UIViewController,WeekCellDelegate,MonthCellDelegate{
    
    //MARK: - Custom Properties
    let screen = UIScreen.main.bounds
    let calendarWidth = 308*UIScreen.main.bounds.width/375
    let calendarHeight = 522*UIScreen.main.bounds.width/375
    let weeklyHeight = UIScreen.main.bounds.height*257/812 + 30
    let monthlyHeight = UIScreen.main.bounds.height*704/812 + 30
    var isCovered = false
    var panGesture = UIPanGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    var picker = UIDatePicker()
    var pickerSelectedYear: Int!
    var pickerSelectedMonth: Int!
    var pickerSelectedDay: Int!
    var selectedDate = Date()
    var infiniteScrollIdx = 1
    var infiniteMonthList: [Date] = []
    var infiniteWeekList: [Date] = []
    let dayList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let monthList = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    let numberOfMonthList = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    var lastlastMonthDate: Date!
    var lastMonthDate: Date!
    var nextMonthDate: Date!
    var lastWeekDate: Date!
    var nextWeekDate: Date!
    var isFromBatch: Bool = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var infiniteMonthlyCV: UICollectionView!
    @IBOutlet weak var infiniteWeeklyCV: UICollectionView!
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    @IBOutlet var weekdayLabelCollection: [UILabel]!


    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDate()
        initPicker()
        initCollectionView()
        initCollectionViewOffset()
        setGesture()
        setStyle()
        addNotificationObserver()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3){
            let frame = self.view.frame
            let heightComponent = self.weeklyHeight
            print(heightComponent)
            self.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: heightComponent)
        }
        self.infiniteMonthlyCV.alpha = 0
        self.infiniteWeeklyCV.alpha = 1
        
    }

    //MARK: - Custom Methods
    
    func setStyle(){
        yearMonthTextView.font = UIFont(name: "Roboto-Medium", size: 25)
        yearMonthTextView.textColor = .mainGrey
        
        calendarDrawerView.clipsToBounds = true
        calendarDrawerView.layer.cornerRadius = 35
        calendarDrawerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        calendarDrawerView.backgroundColor = .systemBackground
        
        shadowView.dropShadow(
            color: UIColor(red: 47/255, green: 83/255, blue: 124/255, alpha: 0.2),
            offSet: CGSize(width: 0, height: -4), opacity: 1, radius: 30)
        shadowView.layer.cornerRadius = 35
        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        for label in weekdayLabelCollection{
            label.font = UIFont(name:"AppleSDGothicNeoM00",size: 13)
        }
        
        infiniteMonthlyCV.clipsToBounds = true
    }
    func setWeekdayColor(){
        for i in 0...6{
            if i == 0{
                weekdayLabelCollection[i].textColor = .dateRedday
            }
            else if i == 6{
                weekdayLabelCollection[i].textColor = .dateSaturday
            }
            else{
                weekdayLabelCollection[i].textColor = .mainGrey
            }
        }
    }
    func setGesture(){
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandler))
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureHandler))
//        tapGesture.delegate = self
        self.calendarDrawerView.addGestureRecognizer(panGesture)
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    ///initPicker
    func initPicker(){
        
        picker =  UIDatePicker(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.locale = Locale(identifier: "ko-KR")
        picker.backgroundColor = .white
//        picker.addTarget(self, action: #selector(pickerValueDidChange), for: .valueChanged)
        
        ///피커뷰를 열었을때 선택된 날짜가 나오도록
        picker.date = selectedDate
        picker.subviews[0].subviews[1].backgroundColor = UIColor(
            red: 0.506, green: 0.886, blue: 0.824, alpha: 0.15)
        
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        shadowView.frame = CGRect(x: -100, y: 0, width: screen.width, height: screen.height)
        let shadowView2 = UIView()
        shadowView2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        shadowView2.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        
        let topView = UIView()
        topView.clipsToBounds = true
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 20
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topView.frame = CGRect(x: 0, y: shadowView.frame.maxY-40, width: screen.width, height: 40)
        shadowView.addSubview(topView)
        
        let doneBTN = UIButton(frame: CGRect(x: screen.width-57,y: 8,width: 48,height: 48))
        doneBTN.setImage(UIImage(named: "calendarFrameCheck"), for: .normal)
        
        let closeBTN = UIButton(frame: CGRect(x: 9,y: 8 ,width: 48,height: 48))
        closeBTN.setImage(UIImage(named:"calendarFrameCancel"), for: .normal)
        doneBTN.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
        closeBTN.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        topView.addSubview(doneBTN)
        topView.addSubview(closeBTN)
        yearMonthTextView.inputView = picker
        yearMonthTextView.inputAccessoryView = shadowView
        yearMonthTextView.inputView?.translatesAutoresizingMaskIntoConstraints = false
        yearMonthTextView.inputView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        yearMonthTextView.inputView?.layoutSubviews()
        yearMonthTextView.inputView?.layoutIfNeeded()
        
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
        }
        
    }
    func initCollectionView(){
        infiniteMonthlyCV.delegate = self
        infiniteMonthlyCV.dataSource = self
        infiniteWeeklyCV.delegate = self
        infiniteWeeklyCV.dataSource = self
    }
    func initCollectionViewOffset(){
        DispatchQueue.main.async(execute: { [self] in
            self.infiniteMonthlyCV.contentOffset.x = calendarWidth*2
            self.infiniteWeeklyCV.contentOffset.x = calendarWidth
        })
    }
    
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(setSelected(_:)), name: NSNotification.Name("ChangeData"), object: nil)
    }
    
    
    
    //MARK: - Custom Methods - Calendar
    
    func selectedDateDidChange(){
        picker.date = selectedDate
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "ChangeDate"),object: selectedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "yyyy.MM"
        yearMonthTextView.text = dateFormatter.string(from: selectedDate)
        var nextComponent = DateComponents()
        nextComponent.day = 7
        var lastComponent = DateComponents()
        lastComponent.day = -7
        nextWeekDate = Calendar.current.date(byAdding: nextComponent, to: selectedDate)
        lastWeekDate = Calendar.current.date(byAdding: lastComponent, to: selectedDate)
        nextMonthDate = dateFormatter.date(from: selectedDate.nextYearMonth)
        lastMonthDate = dateFormatter.date(from:selectedDate.lastYearMonth)!
        lastlastMonthDate = dateFormatter.date(from:lastMonthDate.lastYearMonth)!
        
        ///컬렉션뷰 리로드 할 때 0번 인덱스 다녀오지 않도록
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        infiniteMonthList.insert(lastlastMonthDate, at: 0)
        isFromBatch = true
        infiniteMonthlyCV.performBatchUpdates({infiniteMonthlyCV.insertItems(at: [[0,0]])}, completion: {_ in self.infiniteMonthlyCV.contentOffset.x = self.infiniteMonthlyCV.frame.width*2
            CATransaction.commit()
        })
        infiniteWeekList = [lastWeekDate,selectedDate,nextWeekDate]

//            self.infiniteMonthlyCV.reloadData()
            self.infiniteWeeklyCV.reloadData()
        DispatchQueue.main.async(execute: { [self] in
//            self.infiniteMonthlyCV.contentOffset.x = calendarWidth
            self.infiniteWeeklyCV.contentOffset.x = calendarWidth
//            CATransaction.commit()
        })
//        infiniteMonthlyCV.performBatchUpdates({self.infiniteMonthlyCV.reloadItems(at: [[0,1]])
//            self.infiniteMonthlyCV.contentOffset.x = calendarWidth
//        }, completion: nil)
//        infiniteWeeklyCV.performBatchUpdates({self.infiniteWeeklyCV.reloadItems(at: [[0,1]])
//            self.infiniteWeeklyCV.contentOffset.x = calendarWidth
//        }, completion: nil)
    }
    
    func initDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "yyyy.MM"
        yearMonthTextView.text = dateFormatter.string(from: selectedDate)
        var nextComponent = DateComponents()
        nextComponent.day = 7
        var lastComponent = DateComponents()
        lastComponent.day = -7
        nextWeekDate = Calendar.current.date(byAdding: nextComponent, to: selectedDate)
        lastWeekDate = Calendar.current.date(byAdding: lastComponent, to: selectedDate)
        nextMonthDate = dateFormatter.date(from: selectedDate.nextYearMonth)
        lastMonthDate = dateFormatter.date(from: selectedDate.lastYearMonth)!
        lastlastMonthDate = dateFormatter.date(from: lastMonthDate.lastYearMonth)!
        infiniteMonthList = [lastlastMonthDate,lastMonthDate,selectedDate]
        infiniteWeekList = [lastWeekDate,selectedDate,nextWeekDate]
    }
    
    func openDrawer(){
        infiniteMonthlyCV.performBatchUpdates({self.infiniteMonthlyCV.reloadData()}, completion: {_ in
                                                self.infiniteMonthlyCV.contentOffset.x = self.calendarWidth*2})
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: monthlyHeight)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()})
        UIView.animate(withDuration: 0.3){
            self.infiniteMonthlyCV.alpha = 1
            self.infiniteWeeklyCV.alpha = 0
        }
        
        self.view.layoutSubviews()
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        self.isCovered = true
    }
    
    func closeDrawer(){
        infiniteWeeklyCV.reloadData()
        self.infiniteWeeklyCV.contentOffset.x = calendarWidth
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: weeklyHeight)
        ///spring effect
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
        UIView.animate(withDuration: 0.3){
            self.infiniteMonthlyCV.alpha = 0
            self.infiniteWeeklyCV.alpha = 1
        }
        
        self.view.layoutSubviews()
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        self.isCovered = false
    }
    
    //MARK: - Protocol Methods
    
    func selectedWeekDateDidChange(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        selectedDateDidChange()
        DispatchQueue.main.async(execute: {self.infiniteWeeklyCV.contentOffset.x = self.calendarWidth})
    }
    
    func selectedMonthDateDidChange(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        selectedDateDidChange()
        DispatchQueue.main.async(execute: {self.infiniteWeeklyCV.contentOffset.x = self.calendarWidth})
        closeDrawer()
    }
    
    //MARK: - @objc methods
    
    @objc func setWeekday(_ noti: NSNotification){
        if let flag = noti.object as? Int{
            if flag == 7{
                setWeekdayColor()
            }
            else{
                weekdayLabelCollection[flag].textColor = .white
            }
        }

    }
    
    @objc func tapGestureHandler(recognizer: UITapGestureRecognizer){
//        print("tapped")
        if isCovered == true{
//            print("covered and tapped")
            self.view.frame = CGRect(x: 0, y: 0, width: self.screen.width, height: weeklyHeight)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
            UIView.animate(withDuration: 0.3){
                self.infiniteMonthlyCV.alpha = 0
                self.infiniteWeeklyCV.alpha = 1
            }
            
            
        }
        
        
    }
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: calendarDrawerView)
        let height = self.view.frame.maxY
        let velocity = recognizer.velocity(in: self.view)
        setWeekdayColor()
        if recognizer.state == .ended{
            ///going down
            if velocity.y>0{
                
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: monthlyHeight)
                infiniteMonthlyCV.performBatchUpdates({self.infiniteMonthlyCV.reloadData()}, completion: {_ in
                                                        self.infiniteMonthlyCV.contentOffset.x = self.calendarWidth*2})
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                                self.view.layoutIfNeeded()
//                    self.shadowView.layoutIfNeeded()
                                },
                               completion: nil)
                UIView.animate(withDuration: 0.3){
                    self.infiniteMonthlyCV.alpha = 1
                    self.infiniteWeeklyCV.alpha = 0
                }
                
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = true
                
                
                
            }
            ///going up
            else{
                infiniteWeeklyCV.reloadData()
                self.infiniteWeeklyCV.contentOffset.x = calendarWidth
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: weeklyHeight)
                //spring effect
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.3){
                    self.infiniteMonthlyCV.alpha = 0
                    self.infiniteWeeklyCV.alpha = 1
                }
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = false
                
            }
        }
        ///움직이는 중
        else{
            if weeklyHeight<=height+translation.y && height+translation.y <= monthlyHeight{
                self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height+translation.y)
                UIView.animate(withDuration: 0, animations: {
                                self.view.layoutIfNeeded()
                                self.calendarDrawerView.layoutIfNeeded()
                    self.shadowView.layoutIfNeeded()
                    
                })
                
                
//                self.view.layoutSubviews()
                self.infiniteWeeklyCV.alpha = 0
                self.infiniteMonthlyCV.alpha = (height+translation.y)/monthlyHeight
                recognizer.setTranslation(CGPoint.zero, in: self.view)
//                self.view.layoutSubviews()
            }
        }
        
        
    }
    @objc func donePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "yyyy.MM"
        let dateString = dateFormatter.string(from: picker.date)
        selectedDate = picker.date
        selectedDateDidChange()
        view.endEditing(true)
        yearMonthTextView.text = dateString
        
    }
    @objc func closePicker(){
        view.endEditing(true)
    }
    @objc func pickerValueDidChange(_ noti: Notification){
        selectedDate = noti.object as! Date
        picker.date = selectedDate
    }
    @objc func setSelected(_ noti: Notification){
        selectedDate = noti.object as! Date
        selectedDateDidChange()
    }
    @objc func setDeleted(_ noti: Notification){
//        week
    }
    
    //MARK: - IBActions
    
    @IBAction func todayButtonDidTap(_ sender: Any) {
        selectedDate = Date()
        selectedDateDidChange()
        closeDrawer()
        
    }
    
}

//MARK: - UIGestureRecognizer Delegate

extension CalendarVC{
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if gestureRecognizer == self.tapGesture{
//            if touch.view?.isDescendant(of: self.view) == true{
////                print("self.view is touched")
//            }
//            if touch.view?.isDescendant(of: self.calendarDrawerView) == true{
////                print("calendarDrawerView is touched")
//                return false
//            }
//            else{
//                return true
//            }
//        }
//        return false
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}

//MARK: - UICollectionViewDelegate

extension CalendarVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item) is selected")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == infiniteMonthlyCV{
            return CGSize(width: calendarWidth, height: calendarHeight)
        }
        ///infiniteWeeklyCV
        else{
            return CGSize(width: calendarWidth, height: 105*screen.width/375)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == infiniteWeeklyCV{
//            if let infiCVC = infiniteWeeklyCV.cellForItem(at: [0,0]) as? InfiniteWeeklyCVC{
//                if let weekCVC = infiCVC.weeklyCalendarCV.cellForItem(at: [0,selectedDate.weekday]) as? WeeklyCalendarCVC{
//                    weekCVC.selectedView.alpha = 0
//                }
//            }
//        }
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        if x < calendarWidth{
//            if let cell = infiniteWeeklyCV.cellForItem(at: [0,0]) as? InfiniteMonthlyCVC{
//                cell.monthlyCalendarCV.alpha = 1-x/(calendarWidth)
//            }
//        }
//        else if x > calendarWidth{
//            if let cell = infiniteWeeklyCV.cellForItem(at: [0,2]) as? InfiniteMonthlyCVC{
//                cell.monthlyCalendarCV.alpha = x/(calendarWidth) - 1
//            }
//        }
//    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(infiniteWeeklyCV.isScrollEnabled)
        
        ///미래 날짜로 스크롤 disable 시킴
        let gesture = scrollView.panGestureRecognizer
        if scrollView == infiniteMonthlyCV{
            if gesture.velocity(in: scrollView).x < 0{
                if selectedDate.month == Date().month{
                    infiniteMonthlyCV.isScrollEnabled = false
                }
            }
        }
        else if scrollView == infiniteWeeklyCV{
            if gesture.velocity(in: scrollView).x < 0{
                var leftDateComponent = DateComponents()
                leftDateComponent.day = -(selectedDate.weekday+1)
                var rightDateComponent = DateComponents()
                rightDateComponent.day = 7 - selectedDate.weekday
                let leftDate = Calendar.current.date(byAdding: leftDateComponent, to: Date())
                let rightDate = Calendar.current.date(byAdding: rightDateComponent, to: Date())
                if leftDate!.compare(Date()) == .orderedAscending
                    && rightDate!.compare(Date()) == .orderedDescending{
//                    infiniteWeeklyCV.isScrollEnabled = falser
                    infiniteWeeklyCV.isScrollEnabled = true
                }
            }
        }
        infiniteMonthlyCV.isScrollEnabled = true
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        if scrollView == infiniteMonthlyCV{
            if x == infiniteMonthlyCV.frame.width{
                yearMonthTextView.text = infiniteMonthList[1].currentYearMonth
                selectedDate = lastMonthDate
                selectedDateDidChange()
                
//                DispatchQueue.main.async(execute: { [self] in
//                    print("$$")
//                    self.infiniteMonthlyCV.contentOffset.x = calendarWidth
//                    //                self.pickerTextView.alpha = 1
//                })
                
            }
            else if x == calendarWidth*2{
                yearMonthTextView.text = infiniteMonthList[2].currentYearMonth
                selectedDate = nextMonthDate
                
                selectedDateDidChange()
                
//                DispatchQueue.main.async(execute: { [self] in
//                    print("$$")
//                    self.infiniteMonthlyCV.contentOffset.x = calendarWidth
//                    //                self.pickerTextView.alpha = 1
//                })
                
            }
            else if x == calendarWidth{
                yearMonthTextView.text = infiniteMonthList[1].currentYearMonth
            }
        }
        ///InfiniteWeeklyCV
        else{
            if x == 0{
                yearMonthTextView.text = infiniteWeekList[0].currentYearMonth
                selectedDate = lastWeekDate
                selectedDateDidChange()
                DispatchQueue.main.async(execute: { [self] in
                    self.infiniteWeeklyCV.contentOffset.x = calendarWidth
                })
                
            }
            else if x == calendarWidth*2{
                yearMonthTextView.text = infiniteWeekList[2].currentYearMonth
                selectedDate = nextWeekDate
                selectedDateDidChange()
                
                DispatchQueue.main.async(execute: { [self] in
                    self.infiniteWeeklyCV.contentOffset.x = calendarWidth
                })
                
            }
            else if x == calendarWidth{
                if let cell = infiniteWeeklyCV.cellForItem(at: [0,1]) as? InfiniteMonthlyCVC{
                    cell.monthlyCalendarCV.alpha = 1
                }
                yearMonthTextView.text = infiniteWeekList[1].currentYearMonth
            }
        }
        
    }
 

}


extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == infiniteMonthlyCV{
            return infiniteMonthList.count
        }
        ///infiniteWeeklyCV
        else{
            return 3
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == infiniteMonthlyCV{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteMonthlyCVC.identifier, for: indexPath) as? InfiniteMonthlyCVC else { return UICollectionViewCell() }
            cell.monthlyWeathyList = [] 
            cell.monthCellDelegate = self
            cell.selectedDateDidChange(infiniteMonthList[indexPath.item])
            cell.callMonthlyWeathy()
            CATransaction.begin()
            CATransaction.setDisableActions (true)
            if isFromBatch{
                cell.monthlyCalendarCV.reloadData()
                isFromBatch = false
            }
            
            CATransaction.commit()
            return cell
        }
        
        ///weekly
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteWeeklyCVC.identifier, for: indexPath) as? InfiniteWeeklyCVC else { return UICollectionViewCell() }
            cell.weekCellDelegate = self
            cell.selectedDate = infiniteWeekList[indexPath.item]
            cell.callWeeklyWeathy()
//            cell.weeklyCalendarCV.reloadData()
            return cell
        }
        
    }
}

