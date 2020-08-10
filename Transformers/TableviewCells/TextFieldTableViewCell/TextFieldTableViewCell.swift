//
//  TextFieldTableViewCell.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: CellTextField!
    lazy var picker: UIPickerView = UIPickerView()
    var cellViewModel:TextFieldCellViewModel! {
        didSet {
            titleLabel.text = cellViewModel.titleName
            textField.text = cellViewModel.textFieldValue
            if cellViewModel.fieldType == .picker { textField.inputView = picker }
        }
    }
}
