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
    func recordWeathy(userId:Int, date: String, code: Int, clothArray: [Int], stampId: Int, feedback: String?, img: UIImage?, completion: @escaping (NetworkResult<Any>)->(Void)) {
//        let url = APIConstants.recordWeathyURL
        
        let token = UserDefaults.standard.string(forKey:"token")!
        
        let header: HTTPHeaders = [
            "x-access-token" : token,
            "Content-Type" : "multipart/form-data"
        ]
            
        let body = [
            "userId": userId,
            "date": date,
            "code": code,
            "clothes": clothArray,
            "stampId": stampId,
            "feedback": feedback ?? NSNull()
        ] as [String : Any]
        
        let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        let jsonString = String(data: data, encoding: .utf8)!

        AF.upload(multipartFormData: { multiPartFormData in
            
            multiPartFormData.append(jsonString.data(using:String.Encoding.utf8)!, withName: "weathy")
            
            /// 이미지 업로드
            if let image = img {
                let imageData = image.jpegData(compressionQuality: 1.0)
                multiPartFormData.append(imageData!, withName:"img", fileName:"file.jpeg", mimeType:"image/jpeg")
                print("imgData")
            }
            
//            /// 바디 하나하나 append 후 업로드
//            for (key,value) in body{
//                if value is String{
//                    let val = value as! String
//                    multiPartFormData.append(val.data(using:String.Encoding.utf8)!,withName:key)
//                    print(key)
//                }
//                else if value is Int{
//                    let val = value as! Int
//                    multiPartFormData.append("\(val)".data(using:String.Encoding.utf8)!, withName: key)
//                    print(key)
//                }
//                else if value is NSArray{
//                    let val = value as! NSArray
//                    val.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPartFormData.append(value.data(using: .utf8)!, withName: keyObj)
//                            print(keyObj)
//                        }
//                    })
//                }
//            }

        },to: APIConstants.recordWeathyURL, usingThreshold:UInt64.init(), method: .post, headers: header)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { result in
            switch result.result{
            case .success:
                
                guard let statusCode = result.response?.statusCode else {return}
                guard let data = result.value else {return}
                
                completion(judgeRecordWeathyService(status: statusCode, data: data as! Data))

            case .failure(let error):
                print(error.localizedDescription)
                completion(.networkFail) }
        })
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
