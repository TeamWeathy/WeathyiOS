//
//  MainSearchVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/02/27.
//

import UIKit


class MainSearchVC: UIViewController {
    
    //MARK: - Custom Variables
    
    static let identifier = "MainSearchVC"

    
    var mainDeliverSearchInfo: OverviewWeather?
    
    var recentInformations: [OverviewWeather] = []
    var searchInformations: [OverviewWeather] = []
    var changBool: Bool = false
    
    let dateFormatter = DateFormatter()
    
    var backImage: String = ""
    var gradient: String = ""
    
    var isFromRecord: Bool = false
    var dateFromRecord: String = "0000-00-00"
    
    var locationWeatherData: LocationWeatherData?
    var maxTemp: Int = 0
    var minTemp: Int = 0
    var climateId: Int = 0
    
    var locationCodes: [Int] = [1100000000]
    
    //MARK: - IBOutlets
    
    // 날씨에 따른 뒤 배경
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    /// 최근 검색한 위치 관련
    @IBOutlet weak var recentBackgroundView: UIView!
    @IBOutlet weak var recentNoneImage: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var RecentLabelUnderlineView: UIView!
    
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
        
        backImageView.image = UIImage(named: self.backImage)
        if isFromRecord == false {
            gradientView.image = UIImage(named: self.gradient)
        } else {
            gradientView.image = UIImage(named: "recordWeatherBoxTopblur")
        }
        
        
        recentNonImage()
        setRecentTitle()
        keyBoardAction()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /// 유저디폴트에서 locationCodes 불러오기
        if let data = UserDefaults.standard.array(forKey: "locationCodes") as? [Int] {
            locationCodes = data
            print("[viewWillAppear]", locationCodes, data)
        } else {
            locationCodes = []
        }
        
        initialTextView()
    }
    
    func setRecentTitle(){
        recentLabel.font = UIFont.SDGothicSemiBold17
        recentLabel.textColor = .mainGrey
        RecentLabelUnderlineView.backgroundColor = .subGrey7
    }
    
    /// 촤근 검색 에 따른 이미지 변경
    func recentNonImage(){
        DispatchQueue.main.async {
            
            if let codesCount = UserDefaults.standard.array(forKey: "locationCodes")?.count {
                if codesCount == 0{
                    self.recentNoneImage.isHidden = false
                } else {
                    self.recentNoneImage.isHidden = true
                }
            } else {
                self.recentNoneImage.isHidden = false
            }
        }
    }
    
    /// 검색 에 따른 이미지 변경
    func searchNonImage(){
        DispatchQueue.main.async {
            if self.searchInformations.count == 0{
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
                    
                    searchService.shared.searchWheatherget(keyword: searchText, date: self.isFromRecord == true ? self.dateFromRecord : self.dateFormatter.string(from: Date())){(NetworkResult) -> (Void) in
                        switch NetworkResult{
                        case .success(let data):
                            /// 원상복귀
                            self.searchInformations = []
                            
                            /// 데이터 넣기
                            if let searchWeatherData = data as? SearchWeatherInformation {
                                self.searchInformations = searchWeatherData.overviewWeatherList
                            }
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
            
            self.searchInformations = []
            self.searchTableView.reloadData()
        }
    }
    
    func keyBoardAction() {
        // TODO: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        if noti.name == UIResponder.keyboardWillShowNotification {
            searchView.setBorder(borderColor: .mintMain, borderWidth: 1)
        } else {
            searchView.setBorder(borderColor: .subGrey7, borderWidth: 1)
        }
    }
    
    func initialTextView() {
        searchView.setBorder(borderColor: .subGrey7, borderWidth: 1)
        searchView.layer.cornerRadius = 25
        searchView.backgroundColor = UIColor.white.withAlphaComponent(0.75)
    }
}

extension MainSearchVC {
    // MARK: - Network
    
    func getLocationWeather(indexPath: Int, date: String, cell: UITableViewCell) {

        var locationCode = 0
        
        print(locationCodes)
        locationCode = locationCodes[indexPath]
        
        
        RecordWeathyService.shared.getWeatherByLocation(dateString: date, regionCode: locationCode) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? LocationWeatherData {
                    self.locationWeatherData = response
                    
                    /// 홈 > 최근검색
                    if self.isFromRecord == false {
                        if let recentCell = cell as? RecentTVC {
                            print("[홈>최근검색] \(date)\n\(self.locationWeatherData)")
                            
                            recentCell.weatherData = self.locationWeatherData
                            recentCell.weatherDateLabel.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.date.month) ?? 0)월 \((self.locationWeatherData?.overviewWeather.dailyWeather.date.day) ?? 0)일 \((self.locationWeatherData?.overviewWeather.dailyWeather.date.dayOfWeek) ?? "땡요일")"
                            recentCell.weatherTimeLabel.text = "\((self.locationWeatherData?.overviewWeather.hourlyWeather.time) ?? "오전 땡땡시")"
                            recentCell.location.text = self.locationWeatherData?.overviewWeather.region.name
                            recentCell.weahterImage.image = UIImage(named: ClimateImage.getClimateSearchIllust(self.locationWeatherData?.overviewWeather.hourlyWeather.climate.iconId ?? 0))
                            recentCell.currentTemper.text = "\((self.locationWeatherData?.overviewWeather.hourlyWeather.temperature) ?? 0)°"
                            recentCell.highTemper.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.temperature.maxTemp) ?? 0)°"
                            recentCell.lowTemper.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.temperature.minTemp) ?? 0)°"
                        }
                    /// 기록뷰/수정뷰 > 최근 검색
                    } else {
                        if let recentCell = cell as? RecentFromRecordTVC {
                            print("[기록>최근검색] \(date)\n\(self.locationWeatherData)")
                            recentCell.weatherData = self.locationWeatherData
                            recentCell.weatherDateLabel.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.date.month)!)월 \((self.locationWeatherData?.overviewWeather.dailyWeather.date.day)!)일 \((self.locationWeatherData?.overviewWeather.dailyWeather.date.dayOfWeek)!)"
                            recentCell.location.text = self.locationWeatherData?.overviewWeather.region.name
                            recentCell.weahterImage.image = UIImage(named: ClimateImage.getClimateSearchIllust(self.locationWeatherData?.overviewWeather.hourlyWeather.climate.iconId ?? 0))
                            recentCell.highTemper.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.temperature.maxTemp)!)°"
                            recentCell.lowTemper.text = "\((self.locationWeatherData?.overviewWeather.dailyWeather.temperature.minTemp)!)°"
                        }
                    }

                    
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("path Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                print("network Fail")
            }
        }
    }
}

//MARK: - UITableView Datasource

extension MainSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView{
            
            return locationCodes.count
        }
        else{
            return searchInformations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentTableView {
            /// 메인에서 들어간
            if isFromRecord == false {
                guard let recentCell = recentTableView.dequeueReusableCell(withIdentifier: RecentTVC.identifier, for: indexPath) as? RecentTVC else { return UITableViewCell() }
                
                recentCell.selectionStyle = .none
                
                getLocationWeather(indexPath: indexPath.row, date: self.dateFormatter.string(from: Date()), cell: recentCell)
 
                recentCell.delegate = self
                recentCell.indexPath = indexPath    /// 해당 cell 위치 제공
                
                return recentCell
            } else {
                guard let recentCell = recentTableView.dequeueReusableCell(withIdentifier: RecentFromRecordTVC.identifier, for: indexPath) as? RecentFromRecordTVC else { return UITableViewCell() }
                
                recentCell.selectionStyle = .none
                
                getLocationWeather(indexPath: indexPath.row, date: self.dateFromRecord, cell: recentCell)
                
                recentCell.delegate = self
                recentCell.indexPath = indexPath    /// 해당 cell 위치 제공
                
                return recentCell
            }
            
            
        }else{
            if isFromRecord == false {
                guard let searchCell = searchTableView.dequeueReusableCell(withIdentifier: SearchTVC.identifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }

                searchCell.selectionStyle = .none
                
                searchCell.bind(weatherDate:
                                    "\(self.searchInformations[indexPath.row].dailyWeather.date.month)월 \(self.searchInformations[indexPath.row].dailyWeather.date.day)일 \(self.searchInformations[indexPath.row].dailyWeather.date.dayOfWeek)", weahterTime: self.searchInformations[indexPath.row].hourlyWeather.time ?? "d", location: self.searchInformations[indexPath.row].region.name, weatherImage: ClimateImage.getClimateSearchIllust(self.searchInformations[indexPath.row].hourlyWeather.climate.iconId), currentTemper: "\(self.searchInformations[indexPath.row].hourlyWeather.temperature ?? -100)°", highTemper:  "\(self.searchInformations[indexPath.row].dailyWeather.temperature.maxTemp)°", lowTemper: "\(self.searchInformations[indexPath.row].dailyWeather.temperature.minTemp)°")
                
                return searchCell
            } else { /// isFromRecord == true
                guard let searchCell = searchTableView.dequeueReusableCell(withIdentifier: RecordModifySearchTVC.identifier, for: indexPath) as? RecordModifySearchTVC else { return UITableViewCell() }
                
                searchCell.bind(weatherDate:
                                    "\(self.searchInformations[indexPath.row].dailyWeather.date.month)월 \(self.searchInformations[indexPath.row].dailyWeather.date.day)일 \(self.searchInformations[indexPath.row].dailyWeather.date.dayOfWeek)", location: self.searchInformations[indexPath.row].region.name, weatherImage: ClimateImage.getClimateSearchIllust(self.searchInformations[indexPath.row].hourlyWeather.climate.iconId), highTemper:  "\(self.searchInformations[indexPath.row].dailyWeather.temperature.maxTemp)°", lowTemper: "\(self.searchInformations[indexPath.row].dailyWeather.temperature.minTemp)°")
                
                return searchCell
            }
            
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
        
        /// 최근 검색
        if tableView == recentTableView {
            
            /// 홈 > 최근검색
            if !isFromRecord {
                if let cell = tableView.cellForRow(at: indexPath) as? RecentTVC {
                    
                    /// 클릭한 지역이 가장 위로 올라올 수 있게
                    locationCodes.insert(locationCodes[indexPath.row], at: 0)
                    locationCodes.remove(at: indexPath.row + 1)
                    
                    UserDefaults.standard.set(locationCodes, forKey: "locationCodes")
                    
                    /// 검색 위치로 유저디폴트 갱신
                    UserDefaults.standard.set(locationCodes[0], forKey: "searchLocationCode")
                    
                    NotificationCenter.default.post(name: .init("search"), object: true)
                    NotificationCenter.default.post(name: .init("record"), object: nil, userInfo: ["mainDeliverSearchInfo": cell.weatherData!])
                    
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    cell.backgroundColor = .clear
                }
            }
            /// 기록뷰/수정뷰 > 최근검색
            else {
                if let cell = tableView.cellForRow(at: indexPath) as? RecentFromRecordTVC {
                    
                    /// 클릭한 지역이 가장 위로 올라올 수 있게
                    locationCodes.insert(locationCodes[indexPath.row], at: 0)
                    locationCodes.remove(at: indexPath.row + 1)
                    
                    UserDefaults.standard.set(locationCodes, forKey: "locationCodes")
                    
                    /// 검색 위치로 유저디폴트 갱신
                    UserDefaults.standard.set(locationCodes[0], forKey: "searchLocationCode")
                    
                    NotificationCenter.default.post(name: .init("record"), object: nil, userInfo: ["mainDeliverSearchInfo": cell.weatherData!.overviewWeather])
                    
                    print("[기록/수정>최근검색]", cell.weatherData!.overviewWeather)
                    
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    cell.backgroundColor = .clear
                }
            }
            
            
        /// 검색한 경우
        }else if tableView == searchTableView{
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .white
            print(indexPath.row)
            
            /// 만약 같은 지역코드가 이미 있으면
            if locationCodes.contains(searchInformations[indexPath.row].region.code) {
                /// 저장돼있던 지역코드는 삭제
                locationCodes.remove(at: locationCodes.firstIndex(of: searchInformations[indexPath.row].region.code)!)
            }
            
            /// 3개 안 됐을 때
            if locationCodes.count < 3 {
                locationCodes.insert(searchInformations[indexPath.row].region.code, at: 0)
                self.recentTableView.reloadData()
            }
            /// 3개가 다 찼을 때
            else {
                _ = locationCodes.popLast()
                locationCodes.insert(searchInformations[indexPath.row].region.code, at: 0)
                self.recentTableView.reloadData()
            }
            
            /// 유저디폴트에 저장
            UserDefaults.standard.set(locationCodes, forKey: "locationCodes")
            
            /// 기록뷰에서 변경하기 버튼을 이용해 넘어 온 경우 유저디폴트 갱신하지 않음
            if !isFromRecord {
                UserDefaults.standard.set(searchInformations[indexPath.row].region.code, forKey: "searchLocationCode")
                NotificationCenter.default.post(name: NSNotification.Name("search"), object: true)
            }
            
            NotificationCenter.default.post(name: .init("record"), object: nil, userInfo: ["mainDeliverSearchInfo": self.searchInformations[indexPath.row]])
            
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Cell 을 지우기 위한 CellDelegate

extension MainSearchVC: CellDelegate {
    func swipeCell(indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            if let cell = self.recentTableView.cellForRow(at: indexPath) as? RecentTVC{
                cell.contentView.alpha = 0
            }
            else{
                if let cell = self.recentTableView.cellForRow(at: indexPath) as? RecentFromRecordTVC{
                    cell.contentView.alpha = 0
                }
            }
            
        }, completion: {_ in self.recentTableView.performBatchUpdates({
            
            print(self.locationCodes)
            
            self.locationCodes.remove(at: indexPath.row)
            self.recentTableView.deleteRows(at: [indexPath], with: .automatic)
            
            UserDefaults.standard.set(self.locationCodes, forKey: "locationCodes")
            
            self.recentTableView.reloadData()
        }, completion: {_ in self.recentNonImage()})})
            
    }
}
