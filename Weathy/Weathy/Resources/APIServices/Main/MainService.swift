//
//  MainService.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/13.
//

import Foundation

import Alamofire

struct MainService {
    // MARK: - Custom Variables

    static let shared = MainService()
    
    let defaultLocationCode: Int = 1100000000
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - Network
    
    /// /weather/overview?lat={latitude}&lon={longitude}&code={code}&date={date}
    func getWeatherByLocation(isCode: Bool, completion: @escaping (NetworkResult<Any>) -> Void) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"

        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let lat = UserDefaults.standard.double(forKey: "locationLat")
        let lon = UserDefaults.standard.double(forKey: "locationLon")
        let code = UserDefaults().isExistUserDefaults("searchLocationCode") ? UserDefaults.standard.integer(forKey: "searchLocationCode") : defaultLocationCode
        
        let query = isCode ? "?code=\(code)" : "?lat=\(lat)&lon=\(lon)"
        let url = APIConstants.getWeatherByLocationURL + query + "&date=\(dateFormatter.string(from: Date()))"
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                
                completion(judgeWeatherByLocationData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    /// /users/:user-id/weathy/recommend?code={code}&date={date}
    func getRecommendedWeathy(userId: Int, code: Int, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let url: String = APIConstants.getRecommendedWeathyURL(userId: userId, code: code, date: dateFormatter.string(from: Date()))
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }

                completion(judgeRecommendedWeathyData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    /// /weather/forecast/hourly?code={code}&date={date}
    func getHourlyWeather(code: Int, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let url: String = APIConstants.getHourlyWeatherURL(code: code, date: dateFormatter.string(from: Date()))
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]

        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                
                completion(judgeHourlyWeatherData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    /// /weather/forecast/daily?code={code}&date={date}
    func getDailyWeather(code: Int, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let url: String = APIConstants.getDailyWeatherURL(code: code, date: dateFormatter.string(from: Date()))
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                
                completion(judgeDailyWeatherData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    /// /weather/daily/extra?code={code}&date={date}
    func getExtraWeather(code: Int, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let url: String = APIConstants.getExtraWeatherURL(code: code, date: dateFormatter.string(from: Date()))
        let header: HTTPHeaders = ["x-access-token": token, "Content-Type": "application/json"]
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                
                completion(judgeExtraWeatherData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Judge func

    // FIXME: - status 204 추가 처리 필요
    private func judgeWeatherByLocationData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LocationWeatherData.self, from: data) else { return .pathErr }
        
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
    
    // FIXME: - 204 status가 .pathErr에 걸림
    private func judgeRecommendedWeathyData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(RecommendedWeathyData.self, from: data) else { return .pathErr }
        
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
        guard let decodedData = try? decoder.decode(HourlyWeatherData.self, from: data) else { return .pathErr }
        
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
    
    private func judgeDailyWeatherData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(DailyWeatherData.self, from: data) else { return .pathErr }
        
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
    
    private func judgeExtraWeatherData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ExtraWeatherData.self, from: data) else { return .pathErr }
        
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
