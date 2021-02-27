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
    
    static let identifier = "RecentTVC"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var weatherTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weahterImage: UIImageView!
    @IBOutlet weak var currentTemper: UILabel!
    @IBOutlet weak var highTemper: UILabel!
    @IBOutlet weak var lowTemper: UILabel!
    @IBOutlet weak var slashLabel: UILabel!
    
    //MARK: - Custom Variables
    
    var leadingConstraint: NSLayoutConstraint!
    var deletTrailingConstraint: NSLayoutConstraint!
    var indexPath: IndexPath?
    var delegate: CellDelegate?
    
    // MARK: - UI
    
    let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("삭제", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha:0.1)
        btn.layer.cornerRadius = 35
        btn.dropShadow(color: .black, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 1)
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //MARK: - LifeCycle Methods
        
        initView()
        shadowSet()
        configureLayout()
        textColor()
        textFont()
    }

    //MARK: - @objc Methods
    
    func didSwipe() {
            delegate?.swipeCell(indexPath: indexPath!)
    }
    
    func bind(weatherDate: String, weahterTime: String, location: String, weatherImage: String, currentTemper: String, highTemper: String, lowTemper: String){
        self.weatherDate.text = weatherDate
        self.weatherTime.text = weahterTime
        self.location.text = location
        self.weahterImage.image = UIImage(named: weatherImage)
        self.currentTemper.text = currentTemper
        self.highTemper.text = highTemper
        self.lowTemper.text = " \(lowTemper)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func shadowSet(){
        radiusView.layer.cornerRadius = 35
        radiusView.backgroundColor  = .white
        radiusView.dropShadow(color: .gray, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 1.5)
    }
    
    func textFont(){
        weatherDate.font = UIFont.SDGothicRegular15
        weatherDate.textColor = UIColor.subGrey1
        location.font = UIFont.SDGothicSemiBold17
        location.textColor = UIColor.subGrey1
        weatherTime.font = UIFont.SDGothicRegular15
        currentTemper.font = UIFont.RobotoLight50
        highTemper.font = UIFont.RobotoLight23
        lowTemper.font = UIFont.RobotoLight23
//        slashLabel.font = UIFont.RobotoLight23
    }
    
    func textColor(){
        highTemper.textColor = .redTemp
        lowTemper.textColor = .blueTemp
    }
    
    // MARK: - Action
    @objc
    func didPanAction(_ sender: UIPanGestureRecognizer) {
        let changedX = sender.translation(in: backView).x
        
        print("----> \(changedX)")
        if changedX < 0 {
            buttonStack.frame.size.width = -(changedX) - 15
            leadingConstraint.constant = changedX
            
            UIView.animate(withDuration: 0.1) {
                self.layoutIfNeeded()
            }
        }

        switch sender.state {
        
        case .ended:
            if  changedX > -170 && changedX < -(buttonStack.bounds.width) {
                buttonStack.frame.size.width = 108
                leadingConstraint.constant = -buttonStack.bounds.width - 15
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                    self.buttonStack.frame.size.width = 108
                }
            }else if changedX < -170{
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
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Init
    private func initView() {
        backView.frame = self.bounds
        self.contentView.addSubview(backView)
        self.contentView.addSubview(buttonStack)
        buttonStack.addArrangedSubview(backButton)
        
        addGesture()
    }
    
    private func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAction(_:)))
        backView.addGestureRecognizer(panGesture)
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
}



