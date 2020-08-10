//
//  String+Utils.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.dropFirst()
    }
    var trimmed: String {
        return trimmingCharacters(in: .whitespaces)
    }
}
