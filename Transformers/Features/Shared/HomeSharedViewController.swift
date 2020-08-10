//
//  HomeSharedViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class HomeSharedViewController: UINavigationController {
    var viewModel: HomeSharedViewModel! {
        didSet {
            configureView(with: viewModel)
            bindViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNavigationBar(type: .red)
    }
    
    // MARK: - Private Methods
    private func present(_ view: HomeView) {
        DispatchQueue.main.async { [weak self] in
            switch view {
            case .home:
                self?.presentHomeScreen()
            case .add:
                self?.presentAddTransformerScreen()
            case .viewDetails(let transformer):
                self?.presentViewTransformerScreen(transformer: transformer)
            case .editDetails(let transformer):
                self?.presentEditTransformerScreen(transformer: transformer)
            case .war:
                self?.presentWarTransformersScreen()
            case .results(let autobots, let decepticons):
                self?.presentResultsScreen(autobotsArray: autobots, decepticonsArray: decepticons)
            }
        }
    }
}
// MARK: - Screens presentation
extension HomeSharedViewController {
    private func bindViewModel() {
        viewModel.homeView.bindAndFire { [weak self] view in
            if let view = view { self?.present(view) }
        }
    }
    private func presentHomeScreen() {
        let homeViewController = HomeViewController.load(from: .home)
        homeViewController.viewModel = HomeViewModel(homeResponder: viewModel)
        pushViewController(homeViewController, animated: true)
    }
    private func presentAddTransformerScreen() {
        let addViewController = AddViewController.load(from: .home)
        addViewController.viewModel = AddViewModel()
        pushViewController(addViewController, animated: true)
    }
    private func presentViewTransformerScreen(transformer: Transformer) {
        let viewDetailsViewController = ViewDetailsViewController.load(from: .home)
        viewDetailsViewController.viewModel = ViewDetailsViewModel(viewResponder: viewModel, transformer: transformer)
        pushViewController(viewDetailsViewController, animated: true)
    }
    private func presentEditTransformerScreen(transformer: Transformer) {
        let editDetailsViewController = EditDetailsViewController.load(from: .home)
        editDetailsViewController.viewModel = EditDetailsViewModel(transformer: transformer)
        pushViewController(editDetailsViewController, animated: true)
    }
    private func presentWarTransformersScreen() {
        let warViewController = WarViewController.load(from: .home)
        warViewController.viewModel = WarViewModel(warResponder: viewModel, autobotTransformers: viewModel.autobotTransformers, decepticonsTransformers: viewModel.decepticonsTransformers)
        pushViewController(warViewController, animated: true)
    }
    private func presentResultsScreen(autobotsArray: [Transformer], decepticonsArray: [Transformer]) {
        let resultsViewController = ResultsViewController.load(from: .home)
        resultsViewController.viewModel = ResultsViewModel(autobots: autobotsArray, decepticons: decepticonsArray)
        pushViewController(resultsViewController, animated: true)
    }
}

