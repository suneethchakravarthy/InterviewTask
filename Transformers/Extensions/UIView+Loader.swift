//
//  UIView+Loader.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIView {
    func showIndicator(withTitle title: String?, and subtitle:String?) {
       let indicator = MBProgressHUD.showAdded(to: self, animated: true)
       indicator.animationType = .fade
       indicator.isUserInteractionEnabled = false
       if let title = title { indicator.label.text = title }
       if let subtitle = subtitle { indicator.detailsLabel.text = subtitle }
       self.isUserInteractionEnabled = false
       indicator.show(animated: true)
    }
    func hideIndicator() {
       self.isUserInteractionEnabled = true
       MBProgressHUD.hide(for: self, animated: true)
    }
}
