//
//  searchService.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation
import Alamofire

struct searchService {
    static let shared = searchService()
    
    /// encoding 된 String을 넘기기 위해서!!  (그냥 한글만 넘기면 networking fail이 뜹니다!.)
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    func makeURL(keyword: String, date: String) -> String{
        let key = makeStringKoreanEncoded(keyword)
        var url = APIConstants.searchURL.replacingOccurrences(of: "{keyword}", with: key)
        
        url = url.replacingOccurrences(of: "{date}", with: date)

        return url
    }

    func searchWheatherget(keyword: String, date: String, completion: @escaping (NetworkResult<Any>) -> () ){
        /// 값을 어떻게 넣어야 하나?
        let url = makeURL(keyword: keyword, date: date)
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""

        let header : HTTPHeaders = [ "x-access-token": token, "Content-Type": "application/json"]
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData {(response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                completion(searchWeatherData(status: statusCode, data: data))
            print(" dd연결??-----> \(data)")
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func searchWeatherData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SearchWeatherInformation.self, from: data) else {
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
