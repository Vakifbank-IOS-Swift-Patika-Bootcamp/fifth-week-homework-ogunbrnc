//
//  BaseResponse.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import Foundation

struct BaseResponse: Codable {
    let success: Bool
    let message: String
}

extension BaseResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
