//
//  MainVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainVC: UIViewController {
    //MARK: - Custom Variables
    var lastContentOffset: CGFloat = 0.0
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var topBlurView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var settingIconImage: UIImageView!
    @IBOutlet weak var searchIconImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var todayDateTimeLabel: UILabel!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setGradientView()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
    }
    
    //MARK: - Custom Method
    
    func setView() {
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.isPagingEnabled = true
        weatherCollectionView.decelerationRate = .fast
        
        topBlurView.alpha = 0
        
        todayDateTimeLabel.font = UIFont.RobotoRegular15
        todayDateTimeLabel.textColor = UIColor.subGrey1
        todayDateTimeLabel.text = "1월 7일 일요일 • 오후 4시"
        
        logoImage.transform = CGAffineTransform(translationX: 0, y: 100)
        logoImage.alpha = 0
    }
}

//MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let bottomCVC = weatherCollectionView.cellForItem(at: [1, 0]) as? MainBottomCVC {
            if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y >= 200) {
                bottomCVC.viewScrollDown()
            }
            
            else if (lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y <= 500){
                bottomCVC.viewScrollUp()
            }
            
            lastContentOffset = scrollView.contentOffset.y
        }
        
        if (scrollView.contentOffset.y > 0) {
            UIView.animate(withDuration: 0.7) {
                print(scrollView.contentOffset.y)
                self.topBlurView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseIn], animations: {
                print(scrollView.contentOffset.y)
                self.topBlurView.alpha = 0

            }, completion: nil)
        }
        
        if (scrollView.contentOffset.y >= 400) {
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImage.alpha = 1
                self.logoImage.transform = CGAffineTransform(translationX: 0, y: 0)
                self.todayDateTimeLabel.transform = CGAffineTransform(translationX: 0, y: -100)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImage.alpha = 0
                self.logoImage.transform = CGAffineTransform(translationX: 0, y: 100)
                self.todayDateTimeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}


//MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "MainTopCVC", for: indexPath) as? MainTopCVC else {return UICollectionViewCell()}
            
            cell.setCell()
            return cell
        case 1:
            guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "MainBottomCVC", for: indexPath) as? MainBottomCVC else {return UICollectionViewCell()}
            
            cell.setCell()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
