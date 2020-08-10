//
//  ViewDetailsViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class ViewDetailsViewModel: BaseViewModel {
    let transformer: Transformer
    let screenName = "View"
    let numberOfSections = 1
    let rowHeight = 60.0
    let sectionName = "Transformer Details"
    let sectionFooterViewHeight = 0.01
    let sectionHeaderViewHeight = 50.0
    let cellIdentifier: String = "DetailTextTableViewCell"
    var didItemsLoad = Dynamic<Bool>(value: false)
    let viewResponder: ViewResponder
    init(viewResponder: ViewResponder, transformer: Transformer) {
        self.viewResponder = viewResponder
        self.transformer = transformer
        super.init()
    }
    func numberOfRows() -> Int {
        return TechSpecs.allCases.count
    }
    func getCellViewModel(row: Int) -> DetailTitleCellViewModel {
        let key = TechSpecs.allCases[row].rawValue
        return .init(with: .init(title: key.capitalizingFirstLetter, detailTitle: getValue(for: key)), accessoryType: .none)
    }
    private func getValue(for key: String) -> String {
        if key == TechSpecs.name.rawValue { return transformer.name }
        else if key == TechSpecs.strength.rawValue { return "\(transformer.strength)" }
        else if key == TechSpecs.intelligence.rawValue { return "\(transformer.intelligence)" }
        else if key == TechSpecs.speed.rawValue { return "\(transformer.speed)" }
        else if key == TechSpecs.endurance.rawValue { return "\(transformer.endurance)" }
        else if key == TechSpecs.rank.rawValue { return "\(transformer.rank)" }
        else if key == TechSpecs.courage.rawValue { return "\(transformer.courage)" }
        else if key == TechSpecs.firepower.rawValue { return "\(transformer.firepower)" }
        else if key == TechSpecs.skill.rawValue { return "\(transformer.skill)" }
        else if key == TechSpecs.team.rawValue { return transformer.getTeamName() }
        else { return ""}        
    }
}
extension ViewDetailsViewModel {
    func goToEditScreen() {
        viewResponder.navigateToEditTransformerScreen(model: transformer)
    }
}
