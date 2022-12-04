//
//  CharacterQuotes.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import Foundation

struct CharacterQuote: Codable {
    let quote_id: Int
    let quote: String
    let author: String
    let series: String
}
