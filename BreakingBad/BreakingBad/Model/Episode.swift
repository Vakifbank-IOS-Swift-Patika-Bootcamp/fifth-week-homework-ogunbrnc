//
//  Episode.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import Foundation

struct Episode: Codable {
    let episode_id: Int
    let title: String
    let season: String
    let characters: [String]
    let episode: String
}
