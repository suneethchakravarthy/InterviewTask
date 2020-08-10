//
//  BaseViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

class BaseViewModel: RequestLoaderViewStatus {
    let viewStatus = Dynamic<ViewStatus>(value: .idel)
    let alertModel: Dynamic<AlertModel?> = Dynamic<AlertModel?>(value: nil)
    let errorAlertPresentation    = Dynamic<AlertPresentation?>(value: nil)
    init() {
        bindErrorAlertPresentation()
    }
    // MARK: - Methods
    func bindErrorAlertPresentation() {
        errorAlertPresentation.bind {[weak self] errorAlertPresentation in
            guard let errorAlertPresentation = errorAlertPresentation else { return }
            self?.errorAlertAction(with: errorAlertPresentation)
        }
    }
    func errorStyle(for key: String) -> ErrorStyle {
        return .alert
    }
    func errorAlertAction(with alertPresentation: AlertPresentation) {
        print(alertPresentation)
    }
    func showAPIError(errorObject: APIError) {
        alertModel.value = AlertModel(title: errorObject.errorTitle, message: errorObject.errorMessage, okTitle: "OK")
    }
}
