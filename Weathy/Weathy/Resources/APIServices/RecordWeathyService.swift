//
//  RecordWeathyService.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/14.
//

import Foundation
import Alamofire

struct RecordWeathyService {
    static let shared = RecordWeathyService()
    
    // MARK: - 웨디 기록하기
    func recordWeathy(userId:Int, date: String, code: Int, clothArray: [Int], stampId: Int, feedback: String, completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.recordWeathyURL
        
        let token = UserDefaults.standard.string(forKey:"token")!
        
        let header: HTTPHeaders = [
            "x-access-token" : token
            "Content-Type" : "application/json",
        ]
            
        let body: Parameters = [
            "userId": userId,
            "date": date,
            "code": code,
            "clothes": clothArray,
            "stampId": stampId,
            "feedback": feedback
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success :
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeRecordWeathyService(status: statusCode, data: data))
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    private func judgeRecordWeathyService(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(RecordWeathyData.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.message)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    // MARK: - 날씨 검색
    
    func getWeatherByLocation(dateString: String, regionCode: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {return}
        
        let url = APIConstants.getWeatherByLocationURL + "?code=\(regionCode)&date=\(dateString)"
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
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
