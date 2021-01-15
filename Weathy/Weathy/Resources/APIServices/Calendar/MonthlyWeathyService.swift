//
//  MonthlyWeathyService.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/13.
//

import Alamofire

struct MonthlyWeathyService{
    static let shared = MonthlyWeathyService()
    
    func makeURL(userID: Int, startDate: String, endDate: String) -> String{
        var url = APIConstants.monthlyWeathyURL.replacingOccurrences(of: ":user-id", with: String(userID))
        url = url.replacingOccurrences(of: "{start_date}", with: startDate)
        url = url.replacingOccurrences(of: "{end_date}", with: endDate)
        return url
    }
    
    func getMonthlyCalendar(userID: Int, startDate: String, endDate: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
        let url = makeURL(userID: userID, startDate: startDate, endDate: endDate)
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
                    completion(judgeMonthlyWeathyData(status: statusCode, data: data, url: url))
                case .failure(let err):
                    print(err)
                    completion(.networkFail)
                    
            }
        }
    }
    private func judgeMonthlyWeathyData(status: Int, data: Data,url: String) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        print(">> net status, data, url",status,data,url)
        guard let decodedData = try? decoder.decode(MonthlyWeathyData.self, from: data) else{
            return .pathErr
        }
        print(">>> net decodedData",decodedData.calendarOverviewList)
        switch status{
            case 200:
                return .success(decodedData.calendarOverviewList)
            case 400..<500:
                return .requestErr(decodedData.message)
            case 500:
                return .serverErr
            default:
                return .networkFail
        }
    }
    
}
