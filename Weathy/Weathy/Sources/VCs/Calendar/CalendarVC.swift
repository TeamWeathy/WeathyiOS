//
//  CalendarPartialVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarVC: UIViewController,WeekCellDelegate,MonthCellDelegate{
    
    //MARK: - Custom Properties
    let hasNotch = UIScreen.main.hasNotch
    let screen = UIScreen.main.bounds
    let calendarWidth = 308*UIScreen.main.bounds.width/375
    var calendarHeight = 522*UIScreen.main.bounds.width/375
    var weeklyHeight = UIScreen.main.bounds.width/375*254 + 30
    var monthlyHeight = UIScreen.main.bounds.width/375*706 + 30
    let yearMonthDateFormatter: DateFormatter = DateFormatter()
    let dayDateFormatter: DateFormatter = DateFormatter()
    let infiniteMax = 500
    var isCovered = false
    var panGesture = UIPanGestureRecognizer()
    var picker = UIDatePicker()
    var pickerSelectedYear: Int!
    var pickerSelectedMonth: Int!
    var pickerSelectedDay: Int!
    var selectedDate = Date()
    var infiniteScrollIdx = 1
    var lastWeekIdx = Date().weekday
    
    /// infiniteMonthList
    
    var infiniteMonthList: [Date] = []
    var infiniteWeekList: [Date] = []
    var lastlastMonthDate: Date!
    var lastMonthDate: Date!
    var nextMonthDate: Date!
    var lastWeekDate: Date!
    var nextWeekDate: Date!
    var isFromBatch: Bool = false
    var scrollDirection: ScrollDirection = .left
    var currentIndex: Int = 0
    var nextWeekComponent: DateComponents = DateComponents()
    var lastWeekComponent: DateComponents = DateComponents()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var monthlyCalendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var infiniteMonthlyCV: UICollectionView!
    @IBOutlet weak var infiniteWeeklyCV: UICollectionView!
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    @IBOutlet var weekdayLabelCollection: [UILabel]!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("111",CGFloat(Int(infiniteWeeklyCV.frame.width/7)*7),calendarWidth,infiniteWeeklyCV.frame.width)
        setDateFormatter()
        setDateComponent()
        setMonthList()
        setWeekList()
        initSize()
        initDate()
        initPicker()
        initCollectionView()
        initCollectionViewOffset()
        setGesture()
        setStyle()
        addNotificationObserver()
        closeDrawer()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.infiniteMonthlyCV.alpha = 0
        self.infiniteWeeklyCV.alpha = 1
        weeklyCellDidSelected()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        closeDrawer()
        print("[token]", UserDefaults.standard.string(forKey: "token"))
    }
    
    //MARK: - Custom Methods
    func findIndexFromSelectedDate() -> Int{
        var firstComponent = DateComponents()
        firstComponent.day = -selectedDate.weekday
        let firstDateOfWeek = Calendar.current.date(byAdding: firstComponent, to: selectedDate)
        for i in 0..<infiniteWeekList.count{
            if infiniteWeekList[i].currentYearMonth == firstDateOfWeek?.currentYearMonth{
                if infiniteWeekList[i].day == firstDateOfWeek?.day{
                    currentIndex = i
                    return i
                }
            }
        }
        return -1
    }
    func initSize(){
        if !hasNotch{
            weeklyHeight -= 44
            monthlyHeight = screen.height*0.9
            calendarHeight = 420
            monthlyCalendarHeightConstraint.constant = calendarHeight
        }
        else{
            monthlyCalendarHeightConstraint.constant = screen.width/375*522
        }
        
    }
    func setDateFormatter(){
        yearMonthDateFormatter.dateFormat = "yyyy.MM"
        dayDateFormatter.dateFormat = "yyyy.MM.dd"
        
    }
    
    func setDateComponent(){
        lastWeekComponent.day = -7
        nextWeekComponent.day = 7
    }
    func setMonthList(){
        infiniteMonthList = []
        var currentMonth = yearMonthDateFormatter.date(from: Date().currentYearMonth)!
        var lastMonth = Date()
        for _ in 0..<infiniteMax{
            infiniteMonthList.insert(currentMonth, at: 0)
            lastMonth = yearMonthDateFormatter.date(from: currentMonth.lastYearMonth)!
            currentMonth = lastMonth
        }
        
    }
    func setWeekList(){
        infiniteWeekList = []
        var currentWeek = Date()
        var lastWeek = Date()
        var firstComponent = DateComponents()
        firstComponent.day = -currentWeek.weekday
        currentWeek = Calendar.current.date(byAdding: firstComponent, to: currentWeek)!
        
        for _ in 0..<infiniteMax{
            infiniteWeekList.insert(currentWeek, at: 0)
            lastWeek = Calendar.current.date(byAdding: lastWeekComponent, to: currentWeek)!
            currentWeek = lastWeek
        }
    }
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
        
        ///오늘 요일 하얗게
        setWeekdayWhite()
        
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
    
    func setWeekdayWhite(){
        weekdayLabelCollection[Date().weekday].textColor = .white
    }
    
    func setGesture(){
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandler))
        self.calendarDrawerView.addGestureRecognizer(panGesture)
    }
    
    func initPicker(){
        
        picker =  UIDatePicker(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.locale = Locale(identifier: "ko-KR")
        picker.backgroundColor = .white
        
        ///피커뷰를 열었을때 선택된 날짜가 나오도록
        picker.date = selectedDate
        picker.subviews[0].subviews[1].backgroundColor = UIColor(
            red: 0.506, green: 0.886, blue: 0.824, alpha: 0.15)
        picker.maximumDate = Date()
        picker.minimumDate = infiniteWeekList[0]
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        shadowView.frame = CGRect(x: -100, y: 0, width: screen.width, height: screen.height)
        
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
            self.infiniteMonthlyCV.contentOffset.x = infiniteMonthlyCV.frame.width*CGFloat(infiniteMonthList.count-1)
            self.infiniteWeeklyCV.contentOffset.x = infiniteWeeklyCV.frame.width*CGFloat(infiniteWeekList.count-1)
        })
    }
    
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(setSelected(_:)), name: NSNotification.Name("ChangeData"), object: nil)
    }
    
    //MARK: - Custom Methods - Calendar
    
    func selectedDateDidChange(){
        picker.date = selectedDate
        lastWeekIdx = selectedDate.weekday
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "ChangeDate"),object: selectedDate)
        yearMonthTextView.text = yearMonthDateFormatter.string(from: selectedDate)
        //        nextWeekDate = Calendar.current.date(byAdding: nextWeekComponent, to: selectedDate)
        //        lastWeekDate = Calendar.current.date(byAdding: lastWeekComponent, to: selectedDate)
        //        nextMonthDate = yearMonthDateFormatter.date(from: selectedDate.nextYearMonth)
        //        lastMonthDate = yearMonthDateFormatter.date(from:selectedDate.lastYearMonth)!
        //        lastlastMonthDate = yearMonthDateFormatter.date(from:lastMonthDate.lastYearMonth)!
        
    }
    
    func weeklyCellDidSelected(){
        if let infiniteCell = infiniteWeeklyCV.cellForItem(at: [0,currentIndex]) as? InfiniteWeeklyCVC{
//            infiniteCell.standardDate = infiniteWeekList[currentIndex]
            infiniteCell.selectedDate = selectedDate
            infiniteCell.callWeeklyWeathy()
            infiniteCell.weeklyCalendarCV.reloadData()
            infiniteCell.lastSelectedIdx = currentIndex
            infiniteCell.isSelected = true
//            infiniteCell.weeklyCalendarCV.selectItem(at: [0,selectedDate.weekday], animated: false, scrollPosition: .bottom)
            
        }
        else{
            print("weeklyCell returned nil")
        }
    }
    func monthlyCellDidSelected(){
        if let cell = infiniteMonthlyCV.cellForItem(at: [0,currentIndex]) as? InfiniteMonthlyCVC{
            cell.selectedDateDidChange(selectedDate)
            cell.callMonthlyWeathy()
            cell.monthlyCalendarCV.reloadData()
            cell.lastSelectedIdx = selectedDate.weekday
        }
    }
    
    //    func insertLeftDate(){
    //        ///컬렉션뷰 리로드 할 때 0번 인덱스 다녀오지 않도록
    //        CATransaction.begin()
    //        CATransaction.setDisableActions(true)
    //        infiniteMonthList.insert(lastlastMonthDate, at: 0)
    //        isFromBatch = true
    //        infiniteMonthlyCV.performBatchUpdates({infiniteMonthlyCV.insertItems(at: [[0,0]])}, completion: {_ in self.infiniteMonthlyCV.contentOffset.x = self.infiniteMonthlyCV.frame.width*2
    //            CATransaction.commit()
    //        })
    //    }
    
    func initDate(){
        yearMonthTextView.text = yearMonthDateFormatter.string(from: selectedDate)
        //        nextWeekDate = Calendar.current.date(byAdding: nextWeekComponent, to: selectedDate)
        //        lastWeekDate = Calendar.current.date(byAdding: lastWeekComponent, to: selectedDate)
        //        nextMonthDate = yearMonthDateFormatter.date(from: selectedDate.nextYearMonth)
        //        lastMonthDate = yearMonthDateFormatter.date(from: selectedDate.lastYearMonth)!
        //        lastlastMonthDate = yearMonthDateFormatter.date(from: lastMonthDate.lastYearMonth)!
    }
    
    func openDrawer(){
        currentIndex = self.infiniteMonthList.lastIndex(of: self.yearMonthDateFormatter.date(from: self.selectedDate.currentYearMonth)!)!
        monthlyCellDidSelected()
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: monthlyHeight)
        infiniteMonthlyCV.performBatchUpdates({self.infiniteMonthlyCV.reloadData()}, completion: {_ in
                                                self.infiniteMonthlyCV.contentOffset.x = self.infiniteMonthlyCV.frame.width*CGFloat(self.currentIndex)})
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        },
        completion: nil)
        UIView.animate(withDuration: 0.3){
            self.infiniteMonthlyCV.alpha = 1
            self.infiniteWeeklyCV.alpha = 0
        }
        
        self.isCovered = true
        
    }
    
    func closeDrawer(){
        let weeklyIndex = findIndexFromSelectedDate()
        currentIndex = weeklyIndex
        self.infiniteWeeklyCV.contentOffset.x = self.infiniteWeeklyCV.frame.width*CGFloat(weeklyIndex)
        
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: weeklyHeight)
        
        ///spring effect
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
        UIView.animate(withDuration: 0.3){
            self.infiniteMonthlyCV.alpha = 0
            self.infiniteWeeklyCV.alpha = 1
        }
        ///오늘이면 요일 색 하얗게
        if currentIndex == infiniteMax - 1 {
            setWeekdayWhite()
        }
        
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        weeklyCellDidSelected()
        self.isCovered = false
    }
    
    //MARK: - Protocol Methods
    
    func selectedWeekDateDidChange(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        selectedDateDidChange()
        weeklyCellDidSelected()
    }
    
    func selectedMonthDateDidChange(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        selectedDateDidChange()
        closeDrawer()
    }
    
//    func todayViewDidAppear(_ weekday: Int){
//        weekdayLabelCollection[weekday].textColor = .white
//    }
    
    //MARK: - @objc methods
    
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: calendarDrawerView)
        let height = self.view.frame.maxY
        let velocity = recognizer.velocity(in: self.view)
        setWeekdayColor()
        if recognizer.state == .ended{
            ///going down
            if velocity.y>0{
                openDrawer()
            }
            ///going up
            else{
                //                self.infiniteWeeklyCV.reloadData()
                closeDrawer()
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
                self.infiniteWeeklyCV.alpha = 0
                self.infiniteMonthlyCV.alpha = (height+translation.y)/monthlyHeight
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        }
        
        
    }
    @objc func donePicker(){
        view.endEditing(true)
        let dateString = yearMonthDateFormatter.string(from: picker.date)
        selectedDate = picker.date
        yearMonthTextView.text = dateString
        selectedDateDidChange()
        currentIndex = findIndexFromSelectedDate()
        setWeekdayColor()
        closeDrawer()
        
    }
    @objc func closePicker(){
        view.endEditing(true)
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
        yearMonthTextView.text = yearMonthDateFormatter.string(from: selectedDate)
        selectedDateDidChange()
        closeDrawer()
    }
    
}

//MARK: - UICollectionViewDelegate

extension CalendarVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ///infiniteMonthlyCV
        if collectionView == infiniteMonthlyCV{
            return CGSize(width: infiniteMonthlyCV.frame.width, height: infiniteMonthlyCV.frame.height)
        }
        ///infiniteWeeklyCV
        else{
            return CGSize(width: infiniteWeeklyCV.frame.width, height: infiniteWeeklyCV.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        setWeekdayColor()
    }
    
    ///캘린더를 왼쪽 or 오른쪽으로 스와이프 할 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        ///InfiniteMonthlyCV
        if scrollView == infiniteMonthlyCV{
            if x == infiniteMonthlyCV.frame.width{
                //                yearMonthTextView.text = infiniteMonthList[1].currentYearMonth
                //                selectedDate = lastMonthDate
                //                selectedDateDidChange()
                //                insertLeftDate()
            }
            else{
                selectedDate = infiniteMonthList[currentIndex]
                selectedDateDidChange()
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                monthlyCellDidSelected()
                CATransaction.commit()
            }
            
        }
        ///InfiniteWeeklyCV
        else if scrollView == infiniteWeeklyCV{
            yearMonthTextView.text = infiniteWeekList[currentIndex].currentYearMonth
            var addComponent = DateComponents()
            addComponent.day = lastWeekIdx
            
            ///선택된 날짜가 미래일 경우 오늘이 선택되도록
            if Date().compare(Calendar.current.date(byAdding: addComponent, to: infiniteWeekList[currentIndex])!) == .orderedAscending{
                selectedDate = Date()
            }
            else{
                selectedDate = Calendar.current.date(byAdding: addComponent, to: infiniteWeekList[currentIndex])!
            }
            ///요일 하얗게
            if currentIndex == infiniteMax - 1{
                setWeekdayWhite()
            }
            else{
                setWeekdayColor()
            }
            selectedDateDidChange()
            weeklyCellDidSelected()
        }
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let x = scrollView.contentOffset.x
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if currentIndex == infiniteMax - 1{
            setWeekdayWhite()
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
            return infiniteWeekList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ///Monthly
        if collectionView == infiniteMonthlyCV{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteMonthlyCVC.identifier, for: indexPath) as? InfiniteMonthlyCVC else { return UICollectionViewCell() }
            cell.monthlyWeathyList = [] 
            cell.monthCellDelegate = self
            cell.selectedDateDidChange(infiniteMonthList[indexPath.item])
            CATransaction.begin()
            CATransaction.setDisableActions (true)
            if isFromBatch{
                cell.monthlyCalendarCV.reloadData()
                isFromBatch = false
            }
            
            CATransaction.commit()
            return cell
        }
        
        ///Weekly
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteWeeklyCVC.identifier, for: indexPath) as? InfiniteWeeklyCVC else { return UICollectionViewCell() }
            cell.weekCellDelegate = self
            cell.standardDate = infiniteWeekList[indexPath.item]
//            cell.callWeeklyWeathy()
            return cell
        }
        
    }
}

enum ScrollDirection{
    case left
    case right
}
