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
    func modifyWeathy(userId:Int, token: String, date: String, code: Int, clothArray: [Int], stampId: Int, feedback: String?, img: UIImage?, isDelete: Bool, weathyId: Int, completion: @escaping (NetworkResult<Any>)->(Void)) {
        let url = APIConstants.recordWeathyURL + "/\(weathyId)"
        
        let header: HTTPHeaders = [
            "x-access-token" : token,
            "Content-Type" : "multipart/form-data"
        ]
        
        let body: Parameters = [
            "code": code,
            "clothes": clothArray,
            "stampId": stampId,
            "feedback": feedback ?? NSNull(),
            "isDelete": isDelete
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

        },to: APIConstants.recordWeathyURL, usingThreshold:UInt64.init(), method: .post, headers: header)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { result in
            switch result.result{
            case .success:
                
                guard let statusCode = result.response?.statusCode else {return}
                guard let data = result.data else {return}
                
                completion(judgeModifyWeathyService(status: statusCode, data: data))

            case .failure(let error):
                print(error.localizedDescription)
                completion(.networkFail) }
        })
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
