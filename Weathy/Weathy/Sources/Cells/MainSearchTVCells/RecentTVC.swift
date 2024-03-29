//
//  RecentTVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/06.
//

import UIKit

/// cell을 지우기 위한 Delegate 생성
protocol CellDelegate {
    func swipeCell(indexPath: IndexPath)
}

class RecentTVC: UITableViewCell {
    
    //MARK: - Custom Variables
    
    static let identifier = "RecentTVC"
    
    var leadingConstraint: NSLayoutConstraint!
    var deletTrailingConstraint: NSLayoutConstraint!
    var indexPath: IndexPath?
    var delegate: CellDelegate?
    var buttonFlag: Bool = false
    var initialXPosition: CGFloat = 0.0
    
    var weatherData: LocationWeatherData?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var weatherDateLabel: SpacedLabel!
    @IBOutlet weak var weatherTimeLabel: SpacedLabel!
    @IBOutlet weak var location: SpacedLabel!
    @IBOutlet weak var weahterImage: UIImageView!
    @IBOutlet weak var currentTemper: SpacedLabel!
    @IBOutlet weak var highTemper: SpacedLabel!
    @IBOutlet weak var lowTemper: SpacedLabel!
    @IBOutlet weak var slashLabel: SpacedLabel!
    
    // MARK: - UI
    
    let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("삭제", for: .normal)
        btn.setTitleColor(.subGrey6, for: .normal)
        btn.titleLabel?.font = .SDGothicSemiBold16
        btn.backgroundColor = UIColor.subGrey5.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 35
        btn.setBorder(borderColor: .subGrey7, borderWidth: 1)
        
        return btn
    }()
    
    //MARK: - LifeCycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        setRadiusView()
        configureLayout()
        textColor()
        textFont()
    }
    
    //MARK: - @objc Methods
    
    func didSwipe() {
        delegate?.swipeCell(indexPath: indexPath!)
    }
    
    func bind(weatherDate: String, weahterTime: String, location: String, weatherImage: String, currentTemper: String, highTemper: String, lowTemper: String){
        self.weatherDateLabel.text = weatherDate
        self.weatherTimeLabel.text = weahterTime
        self.location.text = location
        self.weahterImage.image = UIImage(named: weatherImage)
        self.currentTemper.text = currentTemper
        self.highTemper.text = highTemper
        self.lowTemper.text = "\(lowTemper)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setRadiusView(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = UIColor.white.withAlphaComponent(0.75)
        radiusView.setBorder(borderColor: .subGrey7, borderWidth: 1)
    }
    
    func textFont(){
        weatherDateLabel.font = UIFont.SDGothicRegular15
        location.font = UIFont.SDGothicSemiBold17
        weatherTimeLabel.font = UIFont.SDGothicRegular15
        currentTemper.font = UIFont.RobotoLight50
        highTemper.font = UIFont.RobotoLight23
        lowTemper.font = UIFont.RobotoLight23
        //        slashLabel.font = UIFont.RobotoLight23
    }
    
    func textColor(){
        weatherDateLabel.textColor = UIColor.subGrey1
        location.textColor = UIColor.mainGrey
        weatherTimeLabel.textColor = .subGrey1
        currentTemper.textColor = .subGrey1
        slashLabel.textColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1)
        highTemper.textColor = .redTemp
        lowTemper.textColor = .blueTemp
    }
    
    
    // MARK: - Init
    private func initView() {
        backView.frame = self.bounds
        self.contentView.addSubview(backView)
        self.contentView.addSubview(buttonStack)
        buttonStack.addArrangedSubview(deleteButton)
        
        addGesture()
    }
    
    private func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAction(_:)))
        backView.addGestureRecognizer(panGesture)
        deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        panGesture.delegate = self
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool {
        return true
    }
    // MARK: - Layout
    
    private func configureLayout() {
        leadingConstraint = backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        
        deletTrailingConstraint = trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            buttonStack.leadingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 15),
            buttonStack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            buttonStack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    @objc func deleteAction(_ sender: Any){
        didSwipe()
    }
    
    // MARK: - Action
    @objc func didPanAction(_ sender: UIPanGestureRecognizer) {
        let changedX = sender.translation(in: backView).x
        initialXPosition += changedX
        
        print("----> \(initialXPosition)")
        
        switch sender.state {
            
            case .ended:
                if  initialXPosition > -170 && initialXPosition < -(buttonStack.bounds.width) {
                    buttonStack.frame.size.width = 108
                    leadingConstraint.constant = -buttonStack.bounds.width - 15
                    
                    UIView.animate(withDuration: 0.3) {
                        self.layoutIfNeeded()
                        self.buttonStack.frame.size.width = 108
                        self.buttonFlag = true
                        
                    }
                }else if initialXPosition < -170{
                    leadingConstraint.constant = -(self.backView.frame.size.width)
                    UIView.animate(withDuration: 0.2) {
                        self.layoutIfNeeded()
                    }
                    ///해당 cell을 지우기 위한 data 전송
                    didSwipe()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        self.leadingConstraint.constant = 0
                        self.layoutIfNeeded()
                    }
                    
                }else {
                    leadingConstraint.constant = 0
                    self.buttonFlag = false
                    UIView.animate(withDuration: 0.3) {
                        self.layoutIfNeeded()
                    }
                }
                
            default:
                if initialXPosition < 0 {
                    buttonStack.frame.size.width = -(initialXPosition) - 15
                    leadingConstraint.constant = initialXPosition
                    
                    UIView.animate(withDuration: 0.1) {
                        self.layoutIfNeeded()
                    }
                }
                sender.setTranslation(CGPoint.zero, in: self.backView)
        }
    }
}



