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
    var width = UIScreen.main.bounds.width/375*309
    let height = UIScreen.main.bounds.width/375*195
    
    var yesButtonClicked: (()->())?
    var noButtonClicked: (()->())?
    
    var popupView: UIView{
        let popup = UIView()
        popup.backgroundColor = .white
        popup.makeRounded(cornerRadius: 15)
        popup.frame = CGRect(x: (screen.width - width) / 2, y: (screen.height - height) / 2, width: width, height: height)
        popup.dropShadow(color: UIColor(white: 39/255, alpha: 1), offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        return popup
    }
    var backgroundView: UIView{
        let background = UIView()
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        return background
    }
    var titleLabel: SpacedLabel{
        let title = SpacedLabel()
        title.textColor = .pink
        title.font = UIFont.SDGothicSemiBold20
        title.characterSpacing = -1.0
        return title
    }
    var messageLabel: SpacedLabel{
        let message = SpacedLabel()
        message.textColor = .subGrey6
        message.font = UIFont.SDGothicRegular16
        message.characterSpacing = -0.8
        return message
    }
    
    var yesButton: UIButton{
        let yes = UIButton()
        yes.setTitle("삭제하기", for: .normal)
        yes.backgroundColor = .pink
        yes.makeRounded(cornerRadius: 30)
        yes.addTarget(self, action: #selector(yesButtonDidTap), for: .touchUpInside)
        return yes
    }
    var noButton: UIButton{
        let no = UIButton()
        no.setTitle("취소하기", for: .normal)
        no.backgroundColor = .white
        no.makeRounded(cornerRadius: 30)
        no.setBorder(borderColor: .subGrey2, borderWidth: 1)
        no.addTarget(self, action: #selector(noButtonDidTap), for: .touchUpInside)
        return no
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundView)
        self.addSubview(popupView)
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
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

    
}
