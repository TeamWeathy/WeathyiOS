//
//  UIViewController+Extension.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/14.
//

import UIKit

extension UIViewController{
    func showToast(message: String) {
        let width_variable: CGFloat = 33
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: UIScreen.main.bounds.height-165, width: view.frame.size.width-2*width_variable, height: 50))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
        toastLabel.textColor = UIColor.mainGrey
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.SDGothicRegular16
        toastLabel.lineSetting(kernValue: -0.8)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 25
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToast(message: String, completion: @escaping () -> ()) {
        let width_variable: CGFloat = 33
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-165, width: view.frame.size.width-2*width_variable, height: 50))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
        toastLabel.textColor = UIColor.mainGrey
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.SDGothicRegular16
        toastLabel.lineSetting(kernValue: -0.8)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 25
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.8, animations: {
            toastLabel.alpha = 1
            },completion: { finish in
              UIView.animate(withDuration: 0.3, delay: 0.7, animations: {
                toastLabel.alpha = 0
              }, completion: { finish in
                if finish {
                    toastLabel.removeFromSuperview()
                  completion()
                }
              })
            })
    }
    
    func showToastOnTop(message: String) {
        let width_variable: CGFloat = 33
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: 80, width: view.frame.size.width-2*width_variable, height: 50))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
        toastLabel.textColor = UIColor.mainGrey
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.SDGothicRegular16
        toastLabel.lineSetting(kernValue: -0.8)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 25
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
