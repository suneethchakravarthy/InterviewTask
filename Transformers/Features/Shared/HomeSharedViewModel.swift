//
//  HomeSharedViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

enum HomeView {
    case home
    case add
    case viewDetails(transformer: Transformer)
    case editDetails(transformer: Transformer)
    case war
    case results(autobots: [Transformer], decepticons: [Transformer])
}

class HomeSharedViewModel: BaseViewModel {
    let homeView = Dynamic<HomeView?>(value: .home)
    var autobotTransformers: [Transformer] = []
    var decepticonsTransformers: [Transformer] = []
    init(with homeView: HomeView) {
        super.init()
        self.homeView.value = homeView
    }
    private func changeViewState(to view: HomeView) {
        homeView.value = view
    }
}
extension HomeSharedViewModel: HomeResponder {
    func navigateToAddTransformerScreen() {
        changeViewState(to: .add)
    }
    func navigateToWarTransformerScreen(autobots: [Transformer], decepticons: [Transformer]) {
        self.autobotTransformers.removeAll()
        self.autobotTransformers.append(contentsOf: autobots)
        self.decepticonsTransformers.removeAll()
        self.decepticonsTransformers.append(contentsOf: decepticons)
        changeViewState(to: .war)
    }
    func navigateToViewDetailsScreen(model: Transformer) {
        changeViewState(to: .viewDetails(transformer: model))
    }
}
extension HomeSharedViewModel: ViewResponder {
    func navigateToEditTransformerScreen(model: Transformer) {
        changeViewState(to: .editDetails(transformer: model))
    }
}
extension HomeSharedViewModel: WarResponder {
    func navigateToResultsScreen(autobots: [Transformer], decepticons: [Transformer]) {
        changeViewState(to: .results(autobots: autobots, decepticons: decepticons))
    }
}
