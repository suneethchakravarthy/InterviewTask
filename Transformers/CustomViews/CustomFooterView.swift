//
//  CustomFooterView.swift
//  Transformers
//
//  Created by Suneeth on 8/8/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

protocol CustomHeaderDelegate: class {
    func buttonTapped()
}
class CustomFooterView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "CustomFooterView"
    weak var delegate: CustomHeaderDelegate?
    @IBOutlet weak var customButton: UIButton!
    @IBAction func didTapButton(_ sender: AnyObject) {
        delegate?.buttonTapped()
    }
}

