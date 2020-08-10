//
//  WarViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class WarViewModel: BaseViewModel {
    let screenName = "Participants"
    let cellIdentifier: String = "DetailTextTableViewCell"
    let rowHeight = 60.0
    let sectionHeaderViewHeight = 70.0
    let autobots: [Transformer]
    let decepticons: [Transformer]
    let warResponder: WarResponder
    init(warResponder: WarResponder, autobotTransformers: [Transformer], decepticonsTransformers: [Transformer]) {
        self.warResponder = warResponder
        self.autobots = autobotTransformers.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.rank < obj2.rank
        })
        self.decepticons = decepticonsTransformers.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.rank < obj2.rank
        })
        super.init()
    }
    func numberOfSections() -> Int {
        return 2
    }
    func sectionFooterViewHeight(for section: Int) -> CGFloat {
        return (section == 0) ? 0.01 : 70.0
    }
    func getSectionImageName(for section: Int) -> String {
        return (section == 0) ? Constants.TeamIconImages.autobot : Constants.TeamIconImages.decept
    }
    func getSectionName(for section: Int) -> String {
        return (section == 0) ? TransformerTeam.Autobots.rawValue : TransformerTeam.Decepticons.rawValue
    }
    func numberOfRows(for section: Int) -> Int {
        return (section == 0) ? autobots.count : decepticons.count
    }
    func getCellViewModel(section: Int, row: Int) -> DetailTitleCellViewModel {
        let model = (section == 0) ? autobots[row] : decepticons[row]
        return .init(with: .init(title: model.name, detailTitle: "Rank: \(model.rank)"), accessoryType: .none)
    }
}
extension WarViewModel {
    func goToResultsScreen() {
        warResponder.navigateToResultsScreen(autobots: autobots, decepticons: decepticons)
    }
}
