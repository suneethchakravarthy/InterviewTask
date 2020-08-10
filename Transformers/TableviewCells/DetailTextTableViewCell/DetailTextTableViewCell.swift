//
//  DetailTextTableViewCell.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class DetailTextTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    var cellViewModel:DetailTitleCellViewModel! {
        didSet {
            titleLabel.text = cellViewModel.titleName
            detailTitleLabel.text = cellViewModel.detailTitleName
            self.accessoryType = cellViewModel.accessoryType
        }
    }
}
