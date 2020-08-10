//
//  DetailTitleCellViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation
import UIKit

struct DetailTitleCellViewModel {
    let titleName: String
    let detailTitleName: String
    let accessoryType: UITableViewCell.AccessoryType
    
    init(with model: DetailTitleModel, accessoryType:UITableViewCell.AccessoryType) {
        self.accessoryType = accessoryType
        self.titleName = model.title
        self.detailTitleName = model.detailTitle
    }
}

