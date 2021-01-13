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
    
    func getWeatherByLocation(token: String, lat: Double, lon: Double, date: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        // weather/overview?lat={latitude}&lon={longitude}&code={code}&date={date}
        
        let url = APIConstants.getWeatherByLocationURL + "?lat=\(lat)&lon=\(lon)&date=\(date)"
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
    
    private func judgeWeatherByLocationData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LocationWeatherData.self, from: data) else {return .pathErr}
        
        switch status {
        case 200:
            return .success(decodedData)
        case 204:
            return .requestErr("No content")
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
