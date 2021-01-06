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
    //MARK: - IBOutlets
    
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    @IBOutlet var weekdayLabelCollection: [UILabel]!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screen)
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
//        self.monthlyThreeCV.alpha = 0
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
    //MARK: - @objc methods
    
    @objc func tapGestureHandler(recognizer: UITapGestureRecognizer){
        print("tapped")
        if isCovered == true{
            print("covered and tapped")
            self.view.frame = CGRect(x: 0, y: 0, width: self.screen.width, height: self.screen.height*364/812)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
            UIView.animate(withDuration: 0.3){
//                self.monthlyThreeCV.alpha = 0
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
//                    self.monthlyThreeCV.reloadData()
                    
                })
                UIView.animate(withDuration: 0.3){
//                    self.monthlyThreeCV.alpha = 1
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
//                    self.monthlyThreeCV.alpha = 0
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
            if self.screen.height*0.3<=height+translation.y && height+translation.y <= self.screen.height{
                self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height+translation.y)
                self.view.layoutSubviews()
//                self.weeklyCalendarCV.alpha = 0
//                self.monthlyThreeCV.alpha = (height+translation.y)/(self.screen.height)
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
//        self.monthlyThreeCV.reloadDataWithCompletion {
//            self.monthlyThreeCV.contentOffset.x = 315
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
