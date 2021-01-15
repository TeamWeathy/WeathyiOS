//
//  RecordTagService.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/13.
//

import Foundation
import Alamofire

struct RecordTagService {
    static let shared = RecordTagService()
    
    // MARK: - 태그 보기
    func displayTag(userId:Int, token: String, completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.clothesTagURL + "\(userId)" + "/clothes"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "x-access-token" : token
        ]
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
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
                completion(judgeDisplayTagService(status: statusCode, data: data))
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    private func judgeDisplayTagService(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GetClothesArrayData.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.closet)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func addTag(userId:Int, token: String, category: Int, tagName: String, completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.clothesTagURL + "\(userId)" + "/clothes"
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-access-token": token
        ]
        
        let body: Parameters = [
            "category": category,
            "name": tagName
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
                completion(judgeAddTagService(status: statusCode, data: data))
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    private func judgeAddTagService(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(AddClothesData.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.clothesList)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func deleteTag(userId:Int, token: String, clothArray: [Int], completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.clothesTagURL + "\(userId)" + "/clothes"
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-access-token": token
        ]
        
        let body: Parameters = [
            "clothes": clothArray
        ]
        
        let dataRequest = AF.request(url,
                                     method: .delete,
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
                completion(judgeDeleteTagService(status: statusCode, data: data))
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    private func judgeDeleteTagService(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GetClothesArrayData.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.closet)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}


