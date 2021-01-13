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
    
    var SearchRecentInfos : [SearchRecentInfo] = []
    var SearchInfos : [SearchRecentInfo] = []
    var changBool = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    /// 최근 검색한 위치 관련
    @IBOutlet weak var recentBackgroundView: UIView!
    @IBOutlet weak var recentNoneImage: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    
    /// 현재 검색 관련
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var searchNoneImage: UIImageView!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearButton.isHidden = true
        searchTextField.isSelected = true    // 첫 상태
        searchBackgroundView.isHidden = true
        
        /// cell 지우기 관련 Notifi
        NotificationCenter.default.addObserver(self, selector: #selector(deleteNoti), name: .init("delete"), object: nil)
        
        searchTextField.delegate = self
        recentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        searchTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        recentTableView.dataSource = self
        recentTableView.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //MARK: - LifeCycle Methods
        
        setRecentInfo()     // 최근 검색 관련
        setSearchInfo()     // 검색 관련
    }
    
    /// 최근 검색 관련 Info
    func setRecentInfo(){
        let data1 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 서초구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data2 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 양천구", weatherImage: "", currentTemper: "-18", highTemper: "-22", lowTemper: "-20")
        let data3 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 마포구", weatherImage: "", currentTemper: "-30", highTemper: "-1", lowTemper: "-2")
        
        SearchRecentInfos = [data1, data2, data3]
    }
    
    /// 검색 관련 Info
    func setSearchInfo(){
        let data1 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 서초구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data2 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 양천구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data3 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 마포구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data4 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 서초구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data5 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 양천구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        let data6 = SearchRecentInfo(date: "12월 20일 일요일", time: "오후 4시", location: "서울 마포구", weatherImage: "", currentTemper: "-20", highTemper: "-20", lowTemper: "-20")
        
        SearchInfos = [data1, data2, data3,data4,data5,data6]
    }
    
    //MARK: - @objc Methods
    
    /// 최근 검색 cell 지우기 관련 notifi
    @objc func deleteNoti(_ notification: Notification){
        
    }
    
    //MARK: - IBActions
    
    /// 뒤로가기 버튼
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// textField 눌렀을 때
    @IBAction func textFieldDidTap(_ sender: Any) {
        checkTextCount(textField: searchTextField)
    }
    
    /// textfield 지우기 버튼 눌렀을 때
    @IBAction func clearButtonDidTap(_ sender: Any) {
        if changBool == false {
            clearButton.isHidden = false
        } else {
            clearButton.isHidden = true
            searchTextField.text = ""
            changBool = false
        }
    }
    
    /// Tap Gesture를 활용해서 최근 검색한 위치 숨기기
    @IBAction func backtextGR(_ sender: Any) {
        searchTextField.resignFirstResponder()
        if searchTextField.isSelected == false && searchTextField.text?.count == 0 {
            recentBackgroundView.isHidden = false
            searchBackgroundView.isHidden = true
            searchTextField.isSelected = !searchTextField.isSelected
        }
    }
}

//MARK: - UITableView Datasource

extension MainSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView{
            return SearchRecentInfos.count
        }else{
            return SearchInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentTableView {
            guard let recentCell = recentTableView.dequeueReusableCell(withIdentifier: RecentTVC.identifier, for: indexPath) as? RecentTVC else { return UITableViewCell() }
            
            recentCell.selectionStyle = .none
            
            recentCell.bind(weatherDate: SearchRecentInfos[indexPath.row].date, weahterTime: SearchRecentInfos[indexPath.row].time, location: SearchRecentInfos[indexPath.row].location, weatherImage: SearchRecentInfos[indexPath.row].weatherImage, currentTemper: "\(SearchRecentInfos[indexPath.row].currentTemper)°", highTemper:  "\(SearchRecentInfos[indexPath.row].highTemper)°", lowTemper: "\(SearchRecentInfos[indexPath.row].lowTemper)°")
            
            recentCell.delegate = self
            recentCell.indexPath = indexPath    /// 해당 cell 위치 제공
            
            return recentCell
        }else{
            guard let searchCell = searchTableView.dequeueReusableCell(withIdentifier: SearchTVC.identifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            
            searchCell.bind(weatherDate: SearchInfos[indexPath.row].date, weahterTime: SearchInfos[indexPath.row].time, location: SearchInfos[indexPath.row].location, weatherImage: SearchInfos[indexPath.row].weatherImage, currentTemper: "\(SearchInfos[indexPath.row].currentTemper)°", highTemper:  "\(SearchInfos[indexPath.row].highTemper)°", lowTemper: "\(SearchInfos[indexPath.row].lowTemper)°")
            
            
            return searchCell
        }
    }
}

//MARK: - UITableView Delegate

extension MainSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == recentTableView {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .clear
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .clear
        }
    }
}

//MARK: - UITextField Delegate

extension MainSearchVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        /// textfield 눌렀을 때 최신 검색 view 숨기기
        if searchTextField.isSelected == true {
            recentBackgroundView.isHidden = true
            searchBackgroundView.isHidden = false
            searchTextField.isSelected = !searchTextField.isSelected
        }
    }
    
    func checkTextCount(textField: UITextField!) {
        /// 글자 개수에 따른 "변경하기" 버튼 이미지 변경
        if searchTextField.text?.count == 0{
            changBool = false
            clearButton.isHidden = true
        }else{
            changBool = true
            clearButton.isHidden = false
        }
    }
}

//MARK: - Cell 을 지우기 위한 CellDelegate

extension MainSearchVC: CellDelegate {
    func swipeCell(indexPath: IndexPath) {
        print("-----> index \(indexPath)")
        
        UIView.animate(withDuration: 1, animations: {            self.SearchRecentInfos.remove(at: indexPath.row)
                        self.recentTableView.deleteRows(at: [indexPath], with: .automatic)}, completion: {_ in self.recentTableView.reloadData()})
        
    }
}
