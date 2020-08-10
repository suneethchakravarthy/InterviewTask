//
//  HomeViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

enum TransformerTeam: String, CaseIterable {
    case Autobots
    case Decepticons
}
class HomeViewModel: BaseViewModel {
    let homeResponder: HomeResponder
    let rowHeight = 60.0
    let sectionHeaderViewHeight = 70.0
    let sectionFooterViewHeight = 0.01
    let screenName = "Home"
    var didItemsLoad = Dynamic<Bool>(value: false)
    let cellIdentifier: String = "DetailTextTableViewCell"
    private var allModelsArray: [Transformer] = []
    var transformersArray: [[Transformer]] = [] {
        didSet {
            didItemsLoad.value = true
        }
    }
    init(homeResponder: HomeResponder) {
        self.homeResponder = homeResponder
        super.init()
    }
    func fetchTokenIfNeeded() {
        if UserDefaultUtils.shared.getStringValue(for: .token).count == 0 {
            fetchToken()
        } else {
            fetchTransformersList()
        }
    }
    func numberOfSections() -> Int {
        return transformersArray.count
    }
    func numberOfRows(for section: Int) -> Int {
        return transformersArray[section].count
    }
    func getSectionImageName(for section: Int) -> String {
        let sectionName = getSectionName(for: section)
        if sectionName == TransformerTeam.Autobots.rawValue {
            return Constants.TeamIconImages.autobot
        } else {
            return Constants.TeamIconImages.decept
        }
    }
    func getSectionName(for section: Int) -> String {
        if transformersArray.count == TransformerTeam.allCases.count {
            return TransformerTeam.allCases[section].rawValue
        } else if transformersArray.count == 1 {
            let model: Transformer? = transformersArray[section].first
            if model?.team == Constants.TeamCode.autobot {
                return TransformerTeam.Autobots.rawValue
            } else {
                return TransformerTeam.Decepticons.rawValue
            }
        } else {
            return ""
        }
    }
    func getCellViewModel(section: Int, row: Int) -> DetailTitleCellViewModel {
        let model = transformersArray[section][row]
        return .init(with: .init(title: model.name , detailTitle: "Rank: \(model.rank)"), accessoryType: .disclosureIndicator)
    }
    func delete(indexPath: IndexPath, completion: @escaping () -> Void) {
        let model = transformersArray[indexPath.section][indexPath.row]
        deleteTransformer(with: model.id , completion: completion)
    }
    // MARK: - Private Methods
    private func handleTokenResponse(token: String) {
        UserDefaultUtils.shared.setStringValue(for: .token, value: token)
    }
    private func handleTransformersResponse(modelsArray: [Transformer]) {
        allModelsArray.removeAll()
        allModelsArray.append(contentsOf: modelsArray)
        let autobotTransformers = getAutobotTransformers(modelsArray: modelsArray)
        let deceptTransformers = getDeceptTransformers(modelsArray: modelsArray)
        transformersArray.removeAll()
        if autobotTransformers.count > 0 {
            // add the section only if autobot tranformers are available
            transformersArray.append(autobotTransformers)
        }
        if deceptTransformers.count > 0 {
            // add the section only if decept tranformers are available
            transformersArray.append(deceptTransformers)
        }
    }
    private func getAutobotTransformers(modelsArray: [Transformer]) -> [Transformer] {
        return modelsArray.filter { (object) -> Bool in return object.team == Constants.TeamCode.autobot }
    }
    private func getDeceptTransformers(modelsArray: [Transformer]) -> [Transformer] {
        return modelsArray.filter { (object) -> Bool in return object.team == Constants.TeamCode.decepticon }
    }
    private func displayAlert(title: String, message: String, id: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.alertModel.value = AlertModel(title: title, message: message, okTitle: "OK", id: id)
        }
    }
}
// MARK: - API calls
extension HomeViewModel {
    private func fetchToken() {
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        TransformersHandler().getAllSpark { [weak self] (value, error) in
            self?.viewStatus.value = .loaded
            if let error = error { self?.showAPIError(errorObject: error) }
            else if let value = value {
                self?.handleTokenResponse(token: value)
                self?.fetchTransformersList()
            }
        }
    }
    private func fetchTransformersList() {
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        TransformersHandler().getTransformers { [weak self] (value, error) in
            self?.viewStatus.value = .loaded
            if let error = error { self?.showAPIError(errorObject: error) }
            else if let value = value {
                self?.handleTransformersResponse(modelsArray: value.transformers ?? [])
            }
        }
    }
    private func deleteTransformer(with transformerId: String, completion: @escaping () -> Void) {
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        TransformersHandler().deleteTransformer(transformerId: transformerId) { [weak self] (_, error) in
            self?.viewStatus.value = .loaded
            if let error = error { self?.showAPIError(errorObject: error) }
            completion()
        }
    }
}
// MARK: - Navigations
extension HomeViewModel {
    func goToAddScreen() {
        homeResponder.navigateToAddTransformerScreen()
    }
    func goToWarScreen() {
        guard numberOfSections() == 2 else {
            // must need 2 teams for a war
            displayAlert(title: Constants.ValidationMessages.alertTitle, message: Constants.ValidationMessages.noTeamMembersMessage)
            return
        }
        let autobotTransformers = getAutobotTransformers(modelsArray: allModelsArray)
        let deceptTransformers = getDeceptTransformers(modelsArray: allModelsArray)
        homeResponder.navigateToWarTransformerScreen(autobots: autobotTransformers, decepticons: deceptTransformers)
    }
    func goToViewDetailsScreen(indexPath: IndexPath) {
        let modelObject = transformersArray[indexPath.section][indexPath.row]
        homeResponder.navigateToViewDetailsScreen(model: modelObject)
    }
}
