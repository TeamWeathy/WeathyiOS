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
    var infiniteMonthList: [String] = []
    let dayList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let monthList = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    let numberOfMonthList = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    //MARK: - IBOutlets
    
    @IBOutlet weak var infiniteScrollCV: UICollectionView!
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    @IBOutlet var weekdayLabelCollection: [UILabel]!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screen)
        infiniteScrollCV.delegate = self
        infiniteScrollCV.dataSource = self
        
        
        setGesture()
        setStyle()
        initPicker()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3){
            let frame = self.view.frame
            let heightComponent = self.screen.height*364/812
            print(heightComponent)
            self.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: heightComponent)
        }
//        self.infiniteScrollCV.alpha = 0
//        self.weeklyCalendarCV.alpha = 1
        
        
        
    }
    
    //MARK: - Custom Methods
    
    func setStyle(){
        yearMonthTextView.font = UIFont(name: "Roboto-Medium", size: 25)
        yearMonthTextView.textColor = .mainGrey
        calendarDrawerView.clipsToBounds = true
        calendarDrawerView.layer.cornerRadius = 35
        calendarDrawerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        calendarDrawerView.dropShadow(color: UIColor(red: 47/255, green: 83/255, blue: 124/255, alpha: 0.2), offSet: CGSize(width: 0, height: -4), opacity: 1, radius: 30)
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
//        yearMonthTextView.inputView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
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
        infiniteMonthList = [selectedDate.lastYearMonth, selectedDate.currentYearMonth, selectedDate.nextYearMonth]
    }
    
    //MARK: - @objc methods
    
    @objc func tapGestureHandler(recognizer: UITapGestureRecognizer){
        print("tapped")
        if isCovered == true{
            print("covered and tapped")
            self.view.frame = CGRect(x: 0, y: 0, width: self.screen.width, height: self.screen.height*364/812)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
            UIView.animate(withDuration: 0.3){
//                self.infiniteScrollCV.alpha = 0
//                self.weeklyCalendarCV.alpha = 1
            }
            
            
        }
        
        
    }
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: calendarDrawerView)
        let height = self.view.frame.maxY
        let velocity = recognizer.velocity(in: self.view)
        if recognizer.state == .ended{
            ///going down
            if velocity.y>0{
                
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: {
                                _ in
//                    self.infiniteScrollCV.reloadData()
                    
                })
                UIView.animate(withDuration: 0.3){
//                    self.infiniteScrollCV.alpha = 1
//                    self.weeklyCalendarCV.alpha = 0
                }
                
                self.view.layoutSubviews()
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = true
                
                
                
            }
            //going up
            else{
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.screen.height*364/812)
                //spring effect
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
                UIView.animate(withDuration: 0.3){
//                    self.infiniteScrollCV.alpha = 0
//                    self.weeklyCalendarCV.alpha = 1
                }
                //curveEaseIn
                //                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: {_ in
                //
                //                    UIView.animate(withDuration: 0.3){
                //                        self.monthlyCalendarCV.alpha = 0
                //                        self.weeklyCalendarCV.alpha = 1
                //                    }
                //                })
                
                self.view.layoutSubviews()
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.isCovered = false
                
            }
        }
        //움직이는 중
        else{
            if self.screen.height*364/812<=height+translation.y && height+translation.y <= self.screen.height{
                self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height+translation.y)
                self.view.layoutSubviews()
//                self.weeklyCalendarCV.alpha = 0
//                self.infiniteScrollCV.alpha = (height+translation.y)/(self.screen.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                
                
            }
        }
        
        
    }
    @objc func donePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        if Calendar.current.component(.month, from: picker.date)<10{
            dateFormatter.dateFormat = "yyyy. M"
        }
        else{
            dateFormatter.dateFormat = "yyyy.MM"
        }
        let dateString = dateFormatter.string(from: picker.date)

        view.endEditing(true)
        yearMonthTextView.text = dateString
//        initDate(pickerTextView.text)
//        i = 2
//        self.infiniteScrollCV.reloadDataWithCompletion {
//            self.infiniteScrollCV.contentOffset.x = 315
//        }
       
    }
    @objc func closePicker(){
        view.endEditing(true)
    }
    @objc func pickerValueDidChange(){
        
    }
    
    //MARK: - IBActions
    
    @IBAction func todayButtonDidTap(_ sender: Any) {
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
        if collectionView == infiniteScrollCV{
            return CGSize(width: screen.width - 60, height: 520)
        }
        ///weeklyCalendarCV
        else{
            return CGSize(width: (screen.width-60)/7, height: 85)
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: )
    //    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("#")
        let x = scrollView.contentOffset.x
        if x == 0{
            yearMonthTextView.text = infiniteMonthList[infiniteScrollIdx-1]
            infiniteScrollIdx -= 1
//            infiniteScrollCV.reloadItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0),IndexPath(item: 2, section: 0)])
            infiniteScrollCV.reloadData()
            
            DispatchQueue.main.async(execute: {
                print("###")
                self.infiniteScrollCV.contentOffset.x = 315*self.screen.width/375
//                self.pickerTextView.alpha = 1
            })
//            self.infiniteScrollCV.reloadDataWithCompletion {
//                print("###")
//
//            }
        }
        else if x == 315*screen.width/375{
            yearMonthTextView.text = infiniteMonthList[infiniteScrollIdx+1]
            infiniteScrollIdx += 1
            
            infiniteScrollCV.reloadData()
            DispatchQueue.main.async(execute: {
                print("###")
                self.infiniteScrollCV.contentOffset.x = 315*self.screen.width/375
//                self.pickerTextView.alpha = 1
            })
            
        }
        else if x == 315*screen.width/375{
            yearMonthTextView.text = infiniteMonthList[infiniteScrollIdx]
        }
    }

    
}

extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberItems")
        if collectionView == infiniteScrollCV{
            return 3
        }
        ///weeklyCalendarCV
        else{
            return 7
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == infiniteScrollCV{
            print("~~~indexPath",indexPath)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfiniteScrollCVC", for: indexPath) as? InfiniteScrollCVC else { return UICollectionViewCell() }
           
            print("##")
            if indexPath.row == 0{
                print("0000")
                cell.initDate(infiniteMonthList[infiniteScrollIdx-1])
                
//                if isReloaded{
//                    pickerTextView.alpha = 0
//                }
//                isReloaded = true
            }
            else if indexPath.row == 1{
//                pickerTextView.alpha = 1
                print("1111")
                cell.initDate(infiniteMonthList[infiniteScrollIdx])
//                pickerTextView.text = threeMonth[i]
                
            }
            else{
                print("2222")
                cell.initDate(infiniteMonthList[infiniteScrollIdx+1])
//                pickerTextView.text = threeMonth[i+1]
//                pickerTextView.alpha = 1
            }
            cell.monthlyCalendarCV.reloadData()
            return cell
        }
//        if collectionView == monthlyCalendarCV{
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCVC.identifier, for: indexPath) as? MonthlyCalendarCVC else { return UICollectionViewCell() }
//            cell.setDay()
//            cell.setCorner()
//            //윤달
//            if dateComponents.isLeapMonth == true{
//                //이번달
//                if indexPath.item >= firstDayOfMonth && indexPath.item < firstDayOfMonth+29{
//                    //현재 날짜(현재달)
//                    if isThisMonth{
//                        //오늘
//                        if indexPath.item-firstDayOfMonth+1 == dateComponents.day{
//                            cell.setToday()
//                        }
//                        //미래
//                        else if indexPath.item - firstDayOfMonth+1 > dateComponents.day!{
//                            cell.hideFuture()
//                        }
//                        //과거
//                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
//                    }
//                    //과거날짜
//                    else{
//                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
//                    }
//
//                }
//                //이전달
//                else if indexPath.item < firstDayOfMonth{
//                    let numberOfMonth = numberOfMonthList[1]
//                    cell.dayLabel.text = String(day[numberOfMonth-firstDayOfMonth+1+indexPath.item])
//                    cell.dayLabel.textColor = .lightGray
//
//                }
//                //다음달
//                else if indexPath.item >= firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
//
//                    cell.dayLabel.text = String(day[indexPath.item - (firstDayOfMonth+29) + 1 ])
//                    cell.dayLabel.textColor = .lightGray
//                    if isThisMonth{
//                        cell.hideFuture()
//                    }
//                }
//            }
//            //윤달X
//            else{
//                //이번달
//                if indexPath.item >= firstDayOfMonth && indexPath.item < firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
//                    //현재 날짜(현재달)
//                    if isThisMonth{
//                        //오늘
//                        if indexPath.item-firstDayOfMonth+1 == dateComponents.day{
//                            cell.setToday()
//                        }
//                        //미래
//                        else if indexPath.item - firstDayOfMonth+1 > dateComponents.day!{
//                            cell.hideFuture()
//                        }
//                        //과거
//                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
//                    }
//                    //과거날짜
//                    else{
//                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
//                    }
//
//                }
//                //이전달
//                else if indexPath.item < firstDayOfMonth{
//                    var lastMonth = dateComponents.month! - 1
//                    if dateComponents.month! == 1{
//                        lastMonth = 12
//                    }
//                    let numberOfMonth = numberOfMonthList[lastMonth]
//                    cell.dayLabel.text = String(day[numberOfMonth-firstDayOfMonth+1+indexPath.item])
//                    cell.dayLabel.textColor = .lightGray
//
//                }
//                //다음달
//                else if indexPath.item >= firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
//                    cell.dayLabel.text = String(day[indexPath.item - (firstDayOfMonth+numberOfMonthList[dateComponents.month!]) + 1 ])
//                    cell.dayLabel.textColor = .lightGray
//                    if isThisMonth{
//                        cell.hideFuture()
//                    }
//                }
//            }
//
//
//            return cell
//        }
        ///weekly
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarCVC.identifier, for: indexPath) as? WeeklyCalendarCVC else { return UICollectionViewCell() }
            var weekdayOfToday = selectedDate.weekday
//            //일요일이면
//            if weekdayOfToday == 1{
//                weekdayOfToday = 6
//            }
//            //다른 요일
//            else{
//                weekdayOfToday -= 2
//            }
            cell.weekdayLabel.text = yo[indexPath.item]
            let tempIdx = indexPath.item + dateComponents.day!-(weekdayOfToday-1)
            
            cell.emotionView.layer.cornerRadius = 4
            
            if indexPath.item == 6{
                cell.weekdayLabel.textColor = UIColor(red: 108/255, green: 154/255, blue: 231/255, alpha: 1)
                cell.dayLabel.textColor = UIColor(red: 108/255, green: 154/255, blue: 231/255, alpha: 1)
            }
            else if indexPath.item == 0{
                cell.weekdayLabel.textColor = UIColor(red: 178/255, green: 51/255, blue: 48/255, alpha: 1)
                cell.dayLabel.textColor = UIColor(red: 178/255, green: 51/255, blue: 48/255, alpha: 1)
            }
            if indexPath.item == weekdayOfToday-1{
                cell.setToday()
            }
            else if indexPath.item > weekdayOfToday-1{
                cell.emotionView.alpha = 0
            }
            if tempIdx>0{
                cell.dayLabel.text = String(day[indexPath.item + dateComponents.day!-(weekdayOfToday-1)])
            }
            else if tempIdx<=0{
                var lastMonth = dateComponents.month! - 1
                if lastMonth == 0{
                    lastMonth = 12
                }
                cell.dayLabel.text = String(numberOfMonthList[lastMonth]-(weekdayOfToday-1)-1+indexPath.item)
                cell.dayLabel.textColor = .lightGray
            }
            
            return cell
        }
        
    }
}
