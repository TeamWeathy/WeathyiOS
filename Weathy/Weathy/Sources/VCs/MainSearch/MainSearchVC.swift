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
    
    /// 최근 검색 배열을 사용하기 위해 appdelegate에서 전역변수 생성!!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var searchInfos: [SearchRecentInfo] = []
    var mainDeliverSearchInfo: SearchRecentInfo?
    
    var recentInformations: [OverviewWeatherList] = []
    var searchInformations: [OverviewWeatherList] = []
    var changBool: Bool = false
    
    let dateFormatter = DateFormatter()
    
    var backImage: String = ""
    var gradient: String = ""
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIImageView!       // 날씨에 따른 뒤 배경
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    /// 최근 검색한 위치 관련
    @IBOutlet weak var recentBackgroundView: UIView!
    @IBOutlet weak var recentNoneImage: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var recentLabel: UILabel!
    
    /// 현재 검색 관련
    @IBOutlet weak var gradientView: UIImageView!
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var searchNoneImage: UIImageView!
    @IBOutlet weak var searchTableView: UITableView!
    
    /// 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.resignFirstResponder()
        ///
        if searchTextField.isSelected == false && searchTextField.text?.count == 0 {
            recentBackgroundView.isHidden = false
            searchBackgroundView.isHidden = true
            searchTextField.isSelected = !searchTextField.isSelected
        }
    }
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearButton.isHidden = true
        // TextField.isSelected를 false로 하면 안뜨더라구요
        searchTextField.isSelected = true
        searchBackgroundView.isHidden = true
        recentNoneImage.isHidden = true
        searchNoneImage.isHidden = true
        
        recentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        searchTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        searchTextField.delegate = self
        
        recentTableView.dataSource = self
        recentTableView.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        backView.image = UIImage(named: self.backImage)
        gradientView.image = UIImage(named: self.gradient)
        
        recentNonImage()
        font()
    }
    
    func font(){
        recentLabel.font = UIFont.SDGothicSemiBold17
    }
    
    /// 촤근 검색 에 따른 이미지 변경
    func recentNonImage(){
        DispatchQueue.main.async {
            if self.appDelegate.appDelegateRecentInfos.count == 0{
                self.recentNoneImage.isHidden = false
            } else {
                self.recentNoneImage.isHidden = true
            }
        }
    }
    
    /// 검색 에 따른 이미지 변경
    func searchNonImage(){
        DispatchQueue.main.async {
            if self.searchInfos.count == 0{
                self.searchTableView.isHidden = true
                self.searchNoneImage.isHidden = false
            } else {
                self.searchTableView.isHidden = false
                self.searchNoneImage.isHidden = true
            }
        }
    }
    
    //MARK: - @objc Methods
    
    //MARK: - IBActions
    
    /// 뒤로가기 버튼 눌렀을 때 Main에 지역 날씨 넘겨 주기!!
    @IBAction func backButtonDidTap(_ sender: Any) {
        //전달해줄 대상 뷰 컨트롤러
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        guard let mainVC = story.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
        
        mainVC.mainDeliverSearchInfo = self.mainDeliverSearchInfo
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    /// textField 눌렀을 때    
    @IBAction func textFieldDidTap(_ sender: Any) {
        checkTextCount(textField: searchTextField)
        
        /// 한국 시간으로 설정
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        
        guard let searchText = searchTextField.text else { return }
        
        print(searchText)
        print("현재 시간---> \(dateFormatter.string(from: Date()))")
        
        if searchText == "" {
            
        }else{
            /// 서버연결에 딜레이를 주기 위해서
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                /// 맨 마지막에 검색한 text만 서버에 연결하기 위해!
                if searchText == self.searchTextField.text {
                    /// 서버 연결!
                    searchService.shared.searchWheatherget(keyword: searchText, date: self.dateFormatter.string(from: Date())){(NetworkResult) -> (Void) in
                        switch NetworkResult{
                        case .success(let data):
                            /// 원상복귀
                            self.searchInfos = []
                            
                            /// 데이터 넣기
                            if let searchWeatherData = data as? SearchWeatherInformation{
                                self.searchInformations = searchWeatherData.overviewWeatherList
                            }
                            for i in 0 ..< self.searchInformations.count{
                                self.searchInfos.append(SearchRecentInfo.init(date: "\(self.searchInformations[i].dailyWeather.date.month)월 \(self.searchInformations[i].dailyWeather.date.day)일 \(self.searchInformations[i].dailyWeather.date.dayOfWeek)", time: self.searchInformations[i].hourlyWeather.time, location: self.searchInformations[i].region.name, weatherImage: self.searchInformations[i].hourlyWeather.climate.iconID, currentTemper: "\(self.searchInformations[i].hourlyWeather.temperature)", highTemper: "\(self.searchInformations[i].dailyWeather.temperature.maxTemp)", lowTemper: "\(self.searchInformations[i].dailyWeather.temperature.minTemp)"))
                            }
                            print("잘 받아왔어?\(self.searchInfos)")
                            DispatchQueue.main.async {
                                self.searchTableView.reloadData()
                                self.searchNonImage()
                            }
                            
                        case .requestErr:
                            print("requestErr")
                        case .pathErr:
                            print("pathErr")
                        case .serverErr:
                            print("serverErr")
                        case .networkFail:
                            print("networkFail")
                        }
                    }
                }else{
                    
                }
            }
        }
    }
    
    /// textfield 지우기 버튼 눌렀을 때
    @IBAction func clearButtonDidTap(_ sender: Any) {
        if changBool == false {
            clearButton.isHidden = false
        } else {
            clearButton.isHidden = true
            searchTextField.text = ""
            changBool = false
            
            self.searchInfos = []
            self.searchTableView.reloadData()
        }
    }
    
    //    /// Tap Gesture를 활용해서 최근 검색한 위치 숨기기
    //    @IBAction func backtextGR(_ sender: Any) {
    //        searchTextField.resignFirstResponder()
    //        if searchTextField.isSelected == false && searchTextField.text?.count == 0 {
    //            recentBackgroundView.isHidden = false
    //            searchBackgroundView.isHidden = true
    //            searchTextField.isSelected = !searchTextField.isSelected
    //        }
    //    }
}

//MARK: - UITableView Datasource

extension MainSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView{
            return appDelegate.appDelegateRecentInfos.count
        }else{
            return searchInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentTableView {
            guard let recentCell = recentTableView.dequeueReusableCell(withIdentifier: RecentTVC.identifier, for: indexPath) as? RecentTVC else { return UITableViewCell() }
            
            recentCell.selectionStyle = .none
            
            recentCell.bind(weatherDate: appDelegate.appDelegateRecentInfos[indexPath.row].date, weahterTime: appDelegate.appDelegateRecentInfos[indexPath.row].time, location: appDelegate.appDelegateRecentInfos[indexPath.row].location, weatherImage: ClimateImage.getClimateAssetName(appDelegate.appDelegateRecentInfos[indexPath.row].weatherImage), currentTemper: "\(appDelegate.appDelegateRecentInfos[indexPath.row].currentTemper)°", highTemper:  "\(appDelegate.appDelegateRecentInfos[indexPath.row].highTemper)°", lowTemper: "\(appDelegate.appDelegateRecentInfos[indexPath.row].lowTemper)°")
            
            recentCell.delegate = self
            recentCell.indexPath = indexPath    /// 해당 cell 위치 제공
            
            return recentCell
        }else{
            guard let searchCell = searchTableView.dequeueReusableCell(withIdentifier: SearchTVC.identifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            
            //            print("잘 받아왔어?\(self.searchInfos)")
            
            searchCell.bind(weatherDate: searchInfos[indexPath.row].date, weahterTime: searchInfos[indexPath.row].time, location: searchInfos[indexPath.row].location, weatherImage: ClimateImage.getClimateAssetName(self.searchInfos[indexPath.row].weatherImage), currentTemper: "\(searchInfos[indexPath.row].currentTemper)°", highTemper:  "\(searchInfos[indexPath.row].highTemper)°", lowTemper: "\(searchInfos[indexPath.row].lowTemper)°")
            
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == recentTableView {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .clear
            
        }else if tableView == searchTableView{
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .white
            print(indexPath.row)
            /// 최근 검색 기록에 데이터 넣기
            if appDelegate.appDelegateRecentInfos.count < 3{
                appDelegate.appDelegateRecentInfos.append(searchInfos[indexPath.row])
                self.recentTableView.reloadData()
            }else {
                appDelegate.appDelegateRecentInfos.remove(at: 0)
                appDelegate.appDelegateRecentInfos.append(searchInfos[indexPath.row])
                self.recentTableView.reloadData()
            }
            
            /// Main에 넘겨줄 데이터 넣기
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            guard let mainVC = story.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
            mainVC.mainDeliverSearchInfo = self.searchInfos[indexPath.row]
            
            NotificationCenter.default.post(name: .init("record"), object: nil, userInfo: ["mainDeliverSearchInfo": self.searchInfos[indexPath.row]])
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            self.recentNonImage()
        }
    }
}

//MARK: - UITextField Delegate

extension MainSearchVC: UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            cell.transform = CGAffineTransform(translationX: 0, y: 74 * 1.4)
            cell.alpha = 0
            UIView.animate(
                withDuration: 0.45,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1 } )
        }
    }
    
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
        
        UIView.animate(withDuration: 0.3, animations: {            self.appDelegate.appDelegateRecentInfos.remove(at: indexPath.row)
                        self.recentTableView.deleteRows(at: [indexPath], with: .automatic)}, completion: {_ in self.recentTableView.reloadData()
                            self.recentNonImage()
                        })
    }
}
