//
//  TextFieldCellViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation
import UIKit

struct TextFieldCellViewModel {
    let titleName: String
    let textFieldValue: String
    let fieldType: TextFieldType
    init(with model: TextFieldModel, fieldType: TextFieldType) {
        self.titleName = model.title
        self.textFieldValue = model.fieldValue
        self.fieldType = fieldType
    }
}

