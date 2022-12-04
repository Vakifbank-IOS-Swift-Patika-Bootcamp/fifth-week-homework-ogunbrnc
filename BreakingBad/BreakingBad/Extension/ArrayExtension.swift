//
//  Extension.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 2.12.2022.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    //To get only unique values in array.
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
