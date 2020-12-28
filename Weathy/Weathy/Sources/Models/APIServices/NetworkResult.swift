//
//  File.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/29.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
