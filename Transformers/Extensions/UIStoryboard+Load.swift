//
//  UIStoryboard+Load.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum StoryboardEnumerated: String {
        case home
    }
}

extension UIStoryboard.StoryboardEnumerated {
    var filename: String {
        return rawValue.capitalizingFirstLetter
    }
    
    var instance: UIStoryboard {
        return UIStoryboard(name: filename, bundle: Bundle.main)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instance.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.self) ")
        }
        return viewController
    }
}

