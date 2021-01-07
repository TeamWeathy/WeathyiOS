//
//  MainSearchVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/05.
//

import UIKit


class MainSearchVC: UIViewController {
    
    //MARK: - Custom Variables
    
    static let identifier = "MainSearchVC"
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIImageView!
    
    /// 최근 검색한 위치 관련  Background View
    @IBOutlet weak var recentBackgroundView: UIView!
    @IBOutlet weak var recentNoneImage: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - LifeCycle Methods
        recentTableView.dataSource = self
        recentTableView.delegate = self

        recentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    //MARK: - @objc Methods
    
    //MARK: - IBActions
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

////MARK: - UITableView Datasource

extension MainSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recentCell = recentTableView.dequeueReusableCell(withIdentifier: RecentTVC.identifier, for: indexPath) as? RecentTVC else { return UITableViewCell() }
        
        recentCell.selectionStyle = .none
        
        return recentCell
    }
}

////MARK: - UITableView Delegate

extension MainSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, complete in
//            self.Items.remove(at: indexPath.row)
            self.recentTableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        // here set your image and background color
        
        deleteAction.backgroundColor = UIColor(white: 1, alpha: 0)
        deleteAction.image = #imageLiteral(resourceName: "search_weather")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)

        cell?.backgroundColor = .black
      }
}
