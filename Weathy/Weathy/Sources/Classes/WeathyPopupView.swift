//
//  PopupView.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/29.
//

import UIKit

class WeathyPopupView: UIView{
    let screen = UIScreen.main.bounds
    
    ///기기 가로비에 맞춰서 레이아웃 잡음
    let width = 309*UIScreen.main.bounds.width/375
    let height = 195*UIScreen.main.bounds.width/375
    
    var yesButtonClicked: (()->())?
    var noButtonClicked: (()->())?
    
    var popupView: UIView = {
        let popup = UIView()
        popup.backgroundColor = .white
        popup.makeRounded(cornerRadius: 15)
//        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.dropShadow(color: UIColor(white: 39/255, alpha: 1), offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        return popup
    }()
    var backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return background
    }()
    var titleLabel: SpacedLabel = {
        let title = SpacedLabel()
        title.textColor = .pink
        title.font = UIFont.SDGothicSemiBold20
        title.characterSpacing = -1.0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    var messageLabel: SpacedLabel = {
        let message = SpacedLabel()
        message.textColor = .subGrey6
        message.font = UIFont.SDGothicRegular16
        message.characterSpacing = -0.8
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    var yesButton: UIButton = {
        let yes = UIButton()
        yes.setTitle("삭제하기", for: .normal)
        yes.titleLabel?.font = .SDGothicSemiBold16
        yes.backgroundColor = .pink
        yes.setTitleColor(.white, for: .normal)
        yes.addTarget(self, action: #selector(yesButtonDidTap), for: .touchUpInside)
        yes.translatesAutoresizingMaskIntoConstraints = false
        return yes
    }()
    var noButton: UIButton = {
        let no = UIButton()
        no.setTitle("취소하기", for: .normal)
        no.titleLabel?.font = .SDGothicSemiBold16
        no.setTitleColor(.subGrey6, for: .normal)
        no.backgroundColor = .white
        no.setBorder(borderColor: .subGrey2, borderWidth: 1)
        no.addTarget(self, action: #selector(noButtonDidTap), for: .touchUpInside)
        no.translatesAutoresizingMaskIntoConstraints = false
        return no
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    @objc func yesButtonDidTap(){
        if let handler = self.yesButtonClicked{
            handler()
        }
    }
    
    @objc func noButtonDidTap(){
        if let handler = self.noButtonClicked{
            handler()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPopup(titleText: String,
                  messageText: String,
                  yesHandler: (()->())?,
                  noHandler:(()->())?){
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        self.popupView.frame = CGRect(x: (screen.width-width)/2 ,y: (screen.height-height)/2, width: width, height: height)
        self.addSubview(backgroundView)
        self.addSubview(popupView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(messageLabel)
        popupView.addSubview(yesButton)
        popupView.addSubview(noButton)
        self.titleLabel.text = titleText
        self.titleLabel.centerXAnchor.constraint(equalTo: self.popupView.centerXAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 39*screen.width/375).isActive = true
        
        self.messageLabel.text = messageText
        self.messageLabel.centerXAnchor.constraint(equalTo: self.popupView.centerXAnchor).isActive = true
        self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                               constant: 6*screen.width/375).isActive = true
        
        self.yesButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor,
                                            constant: 27*screen.width/375).isActive = true
        self.yesButton.widthAnchor.constraint(equalToConstant: 119*screen.width/375).isActive = true
        self.yesButton.heightAnchor.constraint(equalToConstant: 47*screen.width/375).isActive = true
        self.yesButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -29*screen.width/375).isActive = true
        
        self.noButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 27*screen.width/375).isActive = true
        self.noButton.widthAnchor.constraint(equalToConstant: 119*screen.width/375).isActive = true
        self.noButton.heightAnchor.constraint(equalToConstant: 47*screen.width/375).isActive = true
        self.noButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 29*screen.width/375).isActive = true
        self.yesButton.makeRounded(cornerRadius: 47*screen.width/375/2)
        self.noButton.makeRounded(cornerRadius: 47*screen.width/375/2)
        self.yesButtonClicked = yesHandler
        self.noButtonClicked = noHandler
        
    }

}
