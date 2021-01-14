//
//  ModifyWeathyService.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/15.
//

import Foundation
import Alamofire

struct ModifyWeathyService {
    static let shared = ModifyWeathyService()
    
    // MARK: - 웨디 기록하기
    func modifyWeathy(userId:Int, token: String, date: String, code: Int, clothArray: [Int], stampId: Int, feedback: String, completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.recordWeathyURL
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "x-access-token" : token
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
                                     method: .put,
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
                completion(judgeModifyWeathyService(status: statusCode, data: data))
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    private func judgeModifyWeathyService(status: Int, data: Data) -> NetworkResult<Any> {
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
}
