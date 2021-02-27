//
//  modifyUserService.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation
import Alamofire

struct modifyUserService {
    static let shared = modifyUserService()
    
    func makeURL(userID: Int) -> String{
        let url = APIConstants.modifyUserURL.replacingOccurrences(of: ":user-id", with: String(userID))

            return url
        }
    
    func modifyUserPut(nickname: String, completion: @escaping (NetworkResult<Any>) -> () ){
        
        let url = makeURL(userID: UserDefaults.standard.integer(forKey: "userId"))
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header : HTTPHeaders = [ "x-access-token" : token, "Content-Type" : "application/json"]
        let body : Parameters = ["nickname": nickname]
        
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData {(response) in
            switch response.result{
            case .success:
            
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(modifyUserData(status: statusCode, data: data))
            print(" dd연결??-----> \(data)")
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func modifyUserData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(UserData.self, from: data) else {
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
