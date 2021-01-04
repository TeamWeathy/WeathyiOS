//
//  MainVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainVC: UIViewController {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
    }
    
    //MARK: - Custom Method
    
    func setView() {
        weatherCollectionView.isPagingEnabled = true
        weatherCollectionView.decelerationRate = .fast
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let bottomCVC = weatherCollectionView.cellForItem(at: [1, 0]) as? MainBottomCVC {
            if (scrollView.contentOffset.y >= 500) {
                bottomCVC.viewScrollDown()
            } else {
                bottomCVC.viewScrollUp()
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
