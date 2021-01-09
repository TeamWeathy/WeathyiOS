//
//  CalendarPartialVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarVC: UIViewController {
    
    //MARK: - Custom Properties
    
    let screen = UIScreen.main.bounds
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
    var lastMonthDate: Date!
    var nextMonthDate: Date!
    var lastWeekDate: Date!
    var nextWeekDate: Date!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var infiniteMonthlyCV: UICollectionView!
    @IBOutlet weak var infiniteWeeklyCV: UICollectionView!
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    @IBOutlet var weekdayLabelCollection: [UILabel]!

    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screen)
        initDate()
        //        selectedDateDidChange()
        infiniteMonthlyCV.delegate = self
        infiniteMonthlyCV.dataSource = self
        infiniteWeeklyCV.delegate = self
        infiniteWeeklyCV.dataSource = self
        setGesture()
        setStyle()
        initPicker()
        
        
        print("today",Calendar.current.dateComponents(in: TimeZone.current, from: selectedDate))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3){
            let frame = self.view.frame
            let heightComponent = self.screen.height*330/812
            print(heightComponent)
            self.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: heightComponent)
        }
        self.infiniteMonthlyCV.alpha = 0
        self.infiniteWeeklyCV.alpha = 1
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            print("$$setOffset")
            self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
            self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
        })
        
    }
    
    
    //MARK: - Custom Methods
    
    func setStyle(){
        yearMonthTextView.font = UIFont(name: "Roboto-Medium", size: 25)
        yearMonthTextView.textColor = .mainGrey
        calendarDrawerView.clipsToBounds = true
        calendarDrawerView.layer.cornerRadius = 35
        calendarDrawerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        calendarDrawerView.dropShadow(color: UIColor(red: 47/255, green: 83/255, blue: 124/255, alpha: 0.2), offSet: CGSize(width: 0, height: -4), opacity: 1, radius: 30)
        for label in weekdayLabelCollection{
            label.font = UIFont(name:"AppleSDGothicNeoM00",size: 13)
        }
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
        tapGesture.delegate = self
        self.calendarDrawerView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
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
        picker.addTarget(self, action: #selector(pickerValueDidChange), for: .valueChanged)
        
        ///피커뷰를 열었을때 선택된 날짜가 나오도록
        picker.date = selectedDate
        picker.subviews[0].subviews[1].backgroundColor = UIColor(red: 0.506, green: 0.886, blue: 0.824, alpha: 0.15)
        
        
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
    
    
    //MARK: - Custom Methods - Calendar
    
    func selectedDateDidChange(){
        print("selected")
        
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
        print("last3",lastMonthDate.month,selectedDate.month,nextMonthDate.month)
        infiniteMonthList = [lastMonthDate,selectedDate,nextMonthDate]
        infiniteWeekList = [lastWeekDate,selectedDate,nextWeekDate]
        print("last4", infiniteWeekList)
        UIView.performWithoutAnimation {
            infiniteMonthlyCV.reloadData()
            infiniteWeeklyCV.reloadData()
        }
        DispatchQueue.main.async(execute: {
            print("$$setOffset")
            self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
            self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
        })
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
        lastMonthDate = dateFormatter.date(from:selectedDate.lastYearMonth)!
        print("last3",lastMonthDate.month,selectedDate.month,nextMonthDate.month)
        infiniteMonthList = [lastMonthDate,selectedDate,nextMonthDate]
        infiniteWeekList = [lastWeekDate,selectedDate,nextWeekDate]
        print("last4", infiniteWeekList)
    }
    
    func openDrawer(){
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: {
            _ in
            self.infiniteMonthlyCV.reloadData()
            self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
            
        })
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
        self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height*330/812)
        //spring effect
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
        UIView.animate(withDuration: 0.3){
            self.infiniteMonthlyCV.alpha = 0
            self.infiniteWeeklyCV.alpha = 1
        }
        
        self.view.layoutSubviews()
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        self.isCovered = false
    }
    
    //MARK: - @objc methods
    
    @objc func tapGestureHandler(recognizer: UITapGestureRecognizer){
        print("tapped")
        if isCovered == true{
            print("covered and tapped")
            self.view.frame = CGRect(x: 0, y: 0, width: self.screen.width, height: self.screen.height*330/812)
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
                
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: {
                    _ in
                    self.infiniteMonthlyCV.reloadData()
                    self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
                    
                })
                UIView.animate(withDuration: 0.3){
                    self.infiniteMonthlyCV.alpha = 1
                    self.infiniteWeeklyCV.alpha = 0
                }
                
                self.view.layoutSubviews()
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = true
                
                
                
            }
            //going up
            else{
                infiniteWeeklyCV.reloadData()
                self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height*330/812)
                //spring effect
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
                UIView.animate(withDuration: 0.3){
                    self.infiniteMonthlyCV.alpha = 0
                    self.infiniteWeeklyCV.alpha = 1
                }
                self.view.layoutSubviews()
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = false
                
            }
        }
        //움직이는 중
        else{
            if self.screen.height*330/812<=height+translation.y && height+translation.y <= self.screen.height{
                self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height+translation.y)
                self.view.layoutSubviews()
                self.infiniteWeeklyCV.alpha = 0
                self.infiniteMonthlyCV.alpha = (height+translation.y)/(self.screen.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.view.layoutSubviews()
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
    @objc func pickerValueDidChange(){
        
    }
    
    //MARK: - IBActions
    
    @IBAction func todayButtonDidTap(_ sender: Any) {
        selectedDate = Date()
        selectedDateDidChange()
        closeDrawer()
        
    }
    
}

//MARK: - UIGestureRecognizer Delegate

extension CalendarVC: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == self.tapGesture{
            if touch.view?.isDescendant(of: self.view) == true{
                print("self.view is touched")
            }
            if touch.view?.isDescendant(of: self.calendarDrawerView) == true{
                print("calendarDrawerView is touched")
                return false
            }
            else{
                return true
            }
        }
        return false
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
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
            return CGSize(width: 308*screen.width/375, height: 516*screen.width/375)
        }
        ///infiniteWeeklyCV
        else{
            return CGSize(width: 308*screen.width/375, height: 105*screen.width/375)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == infiniteWeeklyCV{
            if let infiCVC = infiniteWeeklyCV.cellForItem(at: [0,0]) as? InfiniteWeeklyCVC{
                if let weekCVC = infiCVC.weeklyCalendarCV.cellForItem(at: [0,selectedDate.weekday]) as? WeeklyCalendarCVC{
                    weekCVC.selectedView.alpha = 0
                }
            }
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        if x < 308*screen.width/375{
//            if let cell = infiniteWeeklyCV.cellForItem(at: [0,0]) as? InfiniteMonthlyCVC{
//                cell.monthlyCalendarCV.alpha = 1-x/(308*screen.width/375)
//            }
//        }
//        else if x > 308*screen.width/375{
//            if let cell = infiniteWeeklyCV.cellForItem(at: [0,2]) as? InfiniteMonthlyCVC{
//                cell.monthlyCalendarCV.alpha = x/(308*screen.width/375) - 1
//            }
//        }
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("#")
        let x = scrollView.contentOffset.x
        print("x",x)
        if scrollView == infiniteMonthlyCV{
            if x == 0{
                yearMonthTextView.text = infiniteMonthList[0].currentYearMonth
                selectedDate = lastMonthDate
                selectedDateDidChange()
                
                DispatchQueue.main.async(execute: {
                    print("$$")
                    self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
                    //                self.pickerTextView.alpha = 1
                })
                
            }
            else if x == 308*screen.width/375*2{
                yearMonthTextView.text = infiniteMonthList[2].currentYearMonth
                selectedDate = nextMonthDate
                
                selectedDateDidChange()
                
                DispatchQueue.main.async(execute: {
                    print("$$")
                    self.infiniteMonthlyCV.contentOffset.x = 308*self.screen.width/375
                    //                self.pickerTextView.alpha = 1
                })
                
            }
            else if x == 308*screen.width/375{
                yearMonthTextView.text = infiniteMonthList[1].currentYearMonth
            }
        }
        ///InfiniteWeeklyCV
        else{
            if x == 0{
                yearMonthTextView.text = infiniteWeekList[0].currentYearMonth
                selectedDate = lastWeekDate
                selectedDateDidChange()
                DispatchQueue.main.async(execute: {
                    print("$$")
                    self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
                    //                self.pickerTextView.alpha = 1
                })
                
            }
            else if x == 308*screen.width/375*2{
                yearMonthTextView.text = infiniteWeekList[2].currentYearMonth
                selectedDate = nextWeekDate
                selectedDateDidChange()
                
                DispatchQueue.main.async(execute: {
                    print("$$")
                    self.infiniteWeeklyCV.contentOffset.x = 308*self.screen.width/375
                    //                self.pickerTextView.alpha = 1
                })
                
            }
            else if x == 308*screen.width/375{
                if let cell = infiniteWeeklyCV.cellForItem(at: [0,1]) as? InfiniteMonthlyCVC{
                    cell.monthlyCalendarCV.alpha = 1
                }
                yearMonthTextView.text = infiniteWeekList[1].currentYearMonth
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == infiniteMonthlyCV{
            print("willDisplay")
        }
        
    }
    
    
}

extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberItems")
        if collectionView == infiniteMonthlyCV{
            return 3
        }
        ///infiniteWeeklyCV
        else{
            return 3
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == infiniteMonthlyCV{
            print("$$reloaded")
            print("~~~indexPath",indexPath,infiniteMonthList)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteMonthlyCVC.identifier, for: indexPath) as? InfiniteMonthlyCVC else { return UICollectionViewCell() }
            cell.initDate(infiniteMonthList[indexPath.item])
            cell.monthlyCalendarCV.reloadData()
            return cell
        }
        
        ///weekly
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteWeeklyCVC.identifier, for: indexPath) as? InfiniteWeeklyCVC else { return UICollectionViewCell() }
            
            cell.selectedDate = infiniteWeekList[indexPath.item]
            cell.weeklyCalendarCV.reloadData()
            return cell
        }
        
    }
}
