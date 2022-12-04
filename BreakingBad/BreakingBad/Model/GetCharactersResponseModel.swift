//
//  GetCharactersResponseModel.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import Foundation

struct GetCharactersResponseModel: Codable {
    let success: Bool
    let message: String
    let result: [Character]
}
