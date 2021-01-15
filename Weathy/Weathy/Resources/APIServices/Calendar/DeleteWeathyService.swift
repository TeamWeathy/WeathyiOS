//
//  DeleteWeathyService.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/15.
//

import Foundation

import Alamofire

struct DeleteWeathyService{
    static let shared = DeleteWeathyService()
    
    func makeURL(weathyId: Int) -> String{
        var url = APIConstants.deleteWeathyURL.replacingOccurrences(of: ":weathy-id", with: String(weathyId))
        return url
    }
    
    func deleteWeathy(weathyId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)){
        let url = makeURL(weathyId: weathyId)
//        let token = UserDefaults.standard.string(forKey: "token")
        let token = "63:04nZVc9vUelbchZ6m8ALSOWbEyBIL5"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-access-token": token
        ]
        let dataRequest = AF.request(url, method: .delete ,encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData{ (response) in
            switch response.result{
                case .success:
                    guard let statusCode = response.response?.statusCode else{
                        return
                    }
                    guard let data = response.value else{
                        return
                    }
                    completion(judgeDeleteWeathyData(status: statusCode, data: data, url: url))
                case .failure(let err):
                    print("deleteWeathy",err)
                    completion(.networkFail)
                    
            }
        }
    }
    private func judgeDeleteWeathyData(status: Int, data: Data,url: String) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        print(">> delete status, data, url",status,data,url)
        if status == 204{
            return .requestErr("존재하지 않는 Weathy")
        }
        guard let decodedData = try? decoder.decode(DeleteWeathyData.self, from: data) else{
            return .pathErr
        }
        print(">>> delete decodedData",decodedData.message)
        switch status{
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
