//
//  CellTextField.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

let textFieldMaxLength = 12

enum TextFieldType: Int {
    case text
    case picker
}

class CellTextField: UITextField {
    var textFieldType: TextFieldType?
}
