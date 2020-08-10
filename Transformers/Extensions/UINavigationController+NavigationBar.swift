//
//  UINavigationController+NavigationBar.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

extension UINavigationController {
    fileprivate func setRedBackGroundNavigationBar(){
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.navigationBarbuttonTextColor]
        navigationBar.tintColor = UIColor.navigationBarbuttonTextColor
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = textAttributes
    }
    func setUpNavigationBar(type: NavigationBarType) {
        switch type {
        case .red:
            setRedBackGroundNavigationBar()
        }
    }
}
