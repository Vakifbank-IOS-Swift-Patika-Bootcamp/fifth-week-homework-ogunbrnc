//
//  Character.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let birthday: String
    let imageURL: String
    let nickname: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case birthday
        case imageURL = "img"
        case nickname
        case status
    }
}
