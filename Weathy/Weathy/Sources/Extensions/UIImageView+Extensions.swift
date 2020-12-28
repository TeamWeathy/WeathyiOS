//
//  UIImageView+Extensions.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/29.
//

import UIKit

import Kingfisher

// Kingfisher를 이용하여 url로부터 이미지를 가져오는 extension
extension UIImageView {
    
    public func imageFromUrl(_ urlString: String?) {
        if let url = urlString {
            self.kf.setImage(with: URL(string: url), options: [.transition(ImageTransition.fade(0.5))])
        }
    }
    
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String) {
        let defaultImg = UIImage(named: defaultImgPath)
        if let url = urlString {
            if url.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))])
            }
        } else {
            self.image = defaultImg
        }
    }
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String? = nil) {
        if let imageName = defaultImgPath
           ,let defaultImg = UIImage(named: imageName) {
            if let url = urlString {
                if url.isEmpty {
                    self.image = defaultImg
                } else {
                    self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))])
                }
            } else {
                self.image = defaultImg
            }
        }
        else {
            if let url = urlString {
                if !url.isEmpty {
                    self.kf.setImage(with: URL(string: url), options: [.transition(ImageTransition.fade(0.5))])
                }
            }
        }
        
    }
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String, completion: @escaping ()->()) {
        let defaultImg = UIImage(named: defaultImgPath)
        if let url = urlString {
            if url.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))]) { (result) in
                    completion()
                }
            }
        } else {
            self.image = defaultImg
        }
    }
}
