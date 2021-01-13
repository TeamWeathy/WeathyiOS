//
//  createUserService.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/13.
//

import Foundation
import Alamofire

struct createUserService {
    static let shared = createUserService()
    
    func createUser(uuid: String, nickname: String, completion: @escaping (NetworkResult<Any>) -> () ){
        
        let url = APIConstants.createUserURL
        let header : HTTPHeaders = [ "Content-Type" : "application/json"]
        let body : Parameters = ["uuid": uuid, "nickname": nickname]
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
                completion(createUserData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func createUserData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(UserInformation.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            print(" 연결??-----> \(decodedData)")
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
