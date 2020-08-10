//
//  Network+Utils.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

extension Reachability {
    public static func isNetwrokReachable() -> Bool {
        let connection = try? Reachability().connection
        if connection == .unavailable {
            return false
        }
        return true
    }
}
