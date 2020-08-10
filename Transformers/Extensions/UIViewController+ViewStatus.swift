//
//  UIViewController+ViewStatus.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func configureView(with viewModel: BaseViewModel?) {
        guard let viewModel = viewModel else { return }
        viewModel.viewStatus.bind { [weak self](viewState) in
            DispatchQueue.main.async {
                self?.bindBaseViewModel(with: viewState)
            }
        }
    }
    
    private func bindBaseViewModel(with viewStatus: ViewStatus) {
        DispatchQueue.main.async { [weak self] in
            switch viewStatus {
            case .idel, .loaded:
                self?.removeLoaderErrorViewFromSuperview()
            case .loading(let loadStyle, let title, let subtitle):
                self?.view.endEditing(true)
                self?.displayLoading(loadStyle: loadStyle, title: title, subtitle: subtitle)
            }
        }
    }
    fileprivate func displayLoading(loadStyle: LoadingStyle, title: String?, subtitle: String?) {
        // add loading indicator
        switch loadStyle {
            case .covering:
                showCoveringLoader(onView: view, title: title, subtitle: subtitle)
        }
    }
    fileprivate func removeLoaderErrorViewFromSuperview() {
        // remove loading indicator
        removeSpinner()
    }
}

extension UIViewController {
    static func load(from storyboard: UIStoryboard.StoryboardEnumerated) -> Self {
        return storyboard.instantiateViewController()
    }
}

extension UIViewController {
    func showCoveringLoader(onView : UIView, title: String?, subtitle: String?) {
        view.showIndicator(withTitle: title, and: subtitle)
    }
    func removeSpinner() {
        view.hideIndicator()
    }
}


