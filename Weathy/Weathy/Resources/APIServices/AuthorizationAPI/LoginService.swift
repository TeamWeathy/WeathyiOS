//
//  autoLoginService.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation
import Alamofire

struct LoginService {
    static let shared = LoginService()
    
    func postLogin(uuid: String, completion: @escaping (NetworkResult<Any>) -> () ){
        
        let url = APIConstants.loginURL
        let header : HTTPHeaders = [ "Content-Type" : "application/json"]
        let body : Parameters = ["uuid": uuid]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData {(response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeLoginData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeLoginData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(UserData.self, from: data) else {
            return .pathErr
        }
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
