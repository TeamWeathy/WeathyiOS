//
//  DailyWeathyService.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/14.
//

import Foundation
 
import Alamofire

struct DailyWeathyService{
    static let shared = DailyWeathyService()
    
    func makeURL(userID: Int, date: String) -> String{
        var url = APIConstants.dailyWeathyURL.replacingOccurrences(of: ":user-id", with: String(userID))
        url = url.replacingOccurrences(of: "{date}", with: date)
        return url
    }
    
    func getDailyCalendar(userID: Int, date: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
        let url = makeURL(userID: userID, date: date)
//        let token = UserDefaults.standard.string(forKey: "token")
        let token = "61:vtk5hTe4IsXoHWHuw0lVZgwCY76SON"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-access-token": token
        ]
        let dataRequest = AF.request(url, method: .get ,encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData{ (response) in
            switch response.result{
                case .success:
                    guard let statusCode = response.response?.statusCode else{
                        return
                    }
                    guard let data = response.value else{
                        return
                    }
                    completion(judgeDailyWeathyData(status: statusCode, data: data, url: url))
                case .failure(let err):
                    print("daily",err)
                    completion(.networkFail)
                    
            }
        }
    }
    private func judgeDailyWeathyData(status: Int, data: Data,url: String) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        print(">> daily status, data, url",status,data,url)
        guard let decodedData = try? decoder.decode(DailyWeathyData.self, from: data) else{
            return .pathErr
        }
        print(">>> daily decodedData",decodedData.weathy)
        switch status{
            case 200:
                return .success(decodedData.weathy)
            case 400..<500:
                return .requestErr(decodedData.message)
            case 500:
                return .serverErr
            default:
                return .networkFail
        }
    }
    
}
