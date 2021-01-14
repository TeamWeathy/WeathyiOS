//
//  MainService.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/13.
//

import Foundation

import Alamofire

struct MainService {
    static let shared = MainService()
    
    let dateFormatter = DateFormatter()
    var currDate: Date = Date()
    var lat: Double
    var lon: Double
    
    init() {
        currDate = Date()
        
        lat = 37.59311236609
        lon = 126.9501814612
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getWeatherByLocation(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        //weather/overview?lat={latitude}&lon={longitude}&code={code}&date={date}
        guard let token = UserDefaults.standard.string(forKey: "token") else {return}
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        
        let url = APIConstants.getWeatherByLocationURL + "?lat=\(self.lat)&lon=\(self.lon)&date=\(dateFormatter.string(from: currDate))"
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let data = response.value else {return}
                
                completion(judgeWeatherByLocationData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func getRecommendedWeathy(userId: Int, completion: @escaping ((NetworkResult<Any>) -> (Void))) {
        guard let userId = Int(UserDefaults.standard.string(forKey: "userId") ?? "0") else {return}
        guard let locationCode = UserDefaults.standard.string(forKey: "locationCode") else {return}
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let url: String = APIConstants.getRecommendedWeathyURL(userId: userId, code: locationCode, date: "2021-01-14")
        let header: HTTPHeaders = ["x-access-token": UserDefaults.standard.string(forKey: "token")!, "Content-Type": "application/json"]

        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let data = response.value else {return}
                
                completion(judgeRecommendedWeathyData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func getHourlyWeather(completion: @escaping ((NetworkResult<Any>) -> (Void))) {
        guard let locationCode = UserDefaults.standard.string(forKey: "locationCode") else {return}
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        
        let url: String = APIConstants.getHourlyWeatherURL(code: locationCode, date: dateFormatter.string(from: currDate))
        let header: HTTPHeaders = ["x-access-token": UserDefaults.standard.string(forKey: "token")!, "Content-Type": "application/json"]

        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let data = response.value else {return}
                
                completion(judgeHourlyWeatherData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeWeatherByLocationData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LocationWeatherData.self, from: data) else {return .pathErr}
        
        switch status {
        case 200:
            return .success(decodedData)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeRecommendedWeathyData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(RecommendedWeathyData.self, from: data) else {return .pathErr}
        
        switch status {
        case 200:
            return .success(decodedData)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeHourlyWeatherData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(HourlyWeatherData.self, from: data) else {return .pathErr}
        
        switch status {
        case 200:
            return .success(decodedData)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
