//
//  UIViewController+Alert.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

extension UIViewController {
    
  func present(alertModel: AlertModel, presentationState: Dynamic<AlertPresentation?>? = nil) {
    
    presentationState?.value = .presenting(id: alertModel.id)

    let alertController = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
    alertController.view.tintColor = UIColor.navigationBarbuttonTextColor
    var okTitle = alertModel.okTitle
    if alertModel.cancelTitle == nil && alertModel.okTitle == nil {
        okTitle = "OK"
    }
    
    if let title = alertModel.cancelTitle {
        let cancelAction = UIAlertAction(title: title, style: .default) { _ in
            presentationState?.value = .cancel(id: alertModel.id)
            presentationState?.value = nil
        }
        alertController.addAction(cancelAction)
    }
    
    if let title = okTitle {
        let okAction = UIAlertAction(title: title, style: .default) { _ in
            presentationState?.value = .ok(id: alertModel.id)
            presentationState?.value = nil
        }
        alertController.addAction(okAction)
    }
    
    DispatchQueue.main.async {[weak self] in
        self?.present(alertController, animated: true, completion: nil)
    }
  }
}
