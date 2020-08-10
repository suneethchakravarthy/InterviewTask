//
//  AlertModel.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

enum AlertPresentation {
    case presenting(id: String?)
    case cancel(id: String?)
    case ok(id: String?)
}

struct AlertModel {
    let id: String?
    let title: String
    let message: String
    let okTitle: String?
    let cancelTitle: String?

    init(title: String,
         message: String,
         okTitle: String? = nil,
         cancelTitle: String? = nil,
         id: String? = nil) {
        
        self.id = id
        self.title = title
        self.message = message
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
    }
}
