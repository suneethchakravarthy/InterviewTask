//
//  ResultsViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit
enum SectionNames: Int, CaseIterable {
    case WINNERS
    case SURVIVORS
    case SKIPPED
}
class ResultsViewModel: BaseViewModel {
    let screenName = "Results"
    let rowHeight = 60.0
    let sectionHeaderViewHeight = 50.0
    let sectionFooterViewHeight = 0.01
    let cellIdentifier: String = "DetailTextTableViewCell"
    let autobots: [Transformer]
    let decepticons: [Transformer]
    var didItemsLoad = Dynamic<Bool>(value: false)
    var winnersArray: [Transformer] = []
    var eliminatedArray: [Transformer] = []
    var skippedArray: [Transformer] = []
    let name1 = "Optimus Prime"
    let name2 = "Predaking"
    init(autobots: [Transformer], decepticons: [Transformer]) {
        self.autobots = autobots
        self.decepticons = decepticons
        super.init()
    }
    func numberOfSections() -> Int {
        return (skippedArray.count == 0) ? (SectionNames.allCases.count-1) : SectionNames.allCases.count
    }
    func getSectionName(for section: Int) -> String {
        if section == SectionNames.WINNERS.rawValue {
            return "WINNERS"
        } else if section == SectionNames.SURVIVORS.rawValue {
            return "SURVIVORS"
        } else {
            return "SKIPPED"
        }
    }
    func numberOfRows(for section: Int) -> Int {
        if section == SectionNames.WINNERS.rawValue {
            return winnersArray.count
        } else if section == SectionNames.SURVIVORS.rawValue {
            return eliminatedArray.count
        } else {
            return skippedArray.count
        }
    }
    private func getTransformerName(section: Int, row: Int) -> String {
        if section == SectionNames.WINNERS.rawValue {
            return winnersArray[row].name
        } else if section == SectionNames.SURVIVORS.rawValue {
            return eliminatedArray[row].name
        } else {
            return skippedArray[row].name
        }
    }
    private func getTransformerTeamName(section: Int, row: Int) -> String {
        var team = ""
         if section == SectionNames.WINNERS.rawValue {
             team = winnersArray[row].team
         } else if section == SectionNames.SURVIVORS.rawValue {
             team = eliminatedArray[row].team
         } else {
             team = skippedArray[row].team
         }
        return (team == Constants.TeamCode.autobot) ? TransformerTeam.Autobots.rawValue : TransformerTeam.Decepticons.rawValue
     }
    func getCellViewModel(section: Int, row: Int) -> DetailTitleCellViewModel {
        let transformerName = getTransformerName(section: section, row: row)
        let team = getTransformerTeamName(section: section, row: row)
        return .init(with: .init(title: transformerName, detailTitle: team), accessoryType: .none)
    }
    func getWinnerTeamName() -> String {
        if didItemsLoad.value == false { return "" }
        let autobotEliminators = eliminatedArray.filter { return $0.team == Constants.TeamCode.autobot}
        let decepticonEliminators = eliminatedArray.filter { return $0.team == Constants.TeamCode.decepticon}
        if autobotEliminators.count > decepticonEliminators.count {
            return "Winner is \(TransformerTeam.Decepticons.rawValue.capitalized)"
        } else if autobotEliminators.count < decepticonEliminators.count {
            return "Winner is \(TransformerTeam.Autobots.rawValue.capitalized)"
        }
        return "Game is TIE"
    }
    func startWar() {
        let numberOfMatches = (autobots.count < decepticons.count) ? autobots.count : decepticons.count
        skippedParticipants(numberOfMatches: numberOfMatches)
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        for i in 0...(numberOfMatches - 1) {
            let autobotModel = autobots[i]
            let decepticonModel = decepticons[i]
            if isDuplicateNamingConvention(autobot: autobotModel, decepticon: decepticonModel) {
                for j in i...(numberOfMatches - 1) {
                    eliminatedArray.append(autobots[j])
                    eliminatedArray.append(decepticons[j])
                }
                break
            } else {
                conductOneOnOneMatch(autobot: autobotModel, decepticon: decepticonModel)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewStatus.value = .loaded
            self?.didItemsLoad.value = true
        }
    }
    private func skippedParticipants(numberOfMatches: Int) {
        if autobots.count > numberOfMatches {
            for i in numberOfMatches...(autobots.count-1) {
                skippedArray.append(autobots[i])
            }
        }
        if decepticons.count > numberOfMatches {
            for i in numberOfMatches...(decepticons.count-1) {
                skippedArray.append(decepticons[i])
            }
        }
    }
    private func conductOneOnOneMatch(autobot: Transformer, decepticon: Transformer) {
        if checkForCourageStrength(autobot: autobot, decepticon: decepticon) {
            // no need to check for other criteria
        } else if checkForSkill(autobot: autobot, decepticon: decepticon) {
            // no need to check for other criteria
        } else if checkForOverallRating(autobot: autobot, decepticon: decepticon) {
            // no need to check for other criteria
        }
    }
    private func isNameMatching(name: String) -> Bool {
        if name.caseInsensitiveCompare(name1) == .orderedSame || name.caseInsensitiveCompare(name2) == .orderedSame {
            return true
        }
        return false
    }
    private func isDuplicateNamingConvention(autobot: Transformer, decepticon: Transformer) -> Bool {
        if isNameMatching(name: autobot.name) && isNameMatching(name: decepticon.name) {
            return true
        }
        return false
    }
    
    private func checkForNamingConvention(autobot: Transformer, decepticon: Transformer) -> Bool {
        if isNameMatching(name: autobot.name) && !isNameMatching(name: decepticon.name) {
            winnersArray.append(autobot)
            eliminatedArray.append(decepticon)
            return true
        } else if !isNameMatching(name: autobot.name) && isNameMatching(name: decepticon.name) {
            winnersArray.append(decepticon)
            eliminatedArray.append(autobot)
            return true
        } else if !isNameMatching(name: autobot.name) && !isNameMatching(name: decepticon.name) {
            return false
        }
        return false
    }
    
    private func checkForOverallRating(autobot: Transformer, decepticon: Transformer) -> Bool {
        // check for over-all rating
        // transformer with higher rating is the winner
        if autobot.overallRating > decepticon.overallRating {
            winnersArray.append(autobot)
            eliminatedArray.append(decepticon)
            return true
        } else if autobot.overallRating < decepticon.overallRating {
            winnersArray.append(decepticon)
            eliminatedArray.append(autobot)
            return true
        } else {
            // both are considered destroyed if over-all rating is same
            eliminatedArray.append(autobot)
            eliminatedArray.append(decepticon)
            return true
        }
    }
    private func checkForCourageStrength(autobot: Transformer, decepticon: Transformer) -> Bool {
        // check for courage and strength
        if ((autobot.courage - decepticon.courage) >= 4 && (autobot.strength - decepticon.strength) >= 3) {
            winnersArray.append(autobot)
            eliminatedArray.append(decepticon)
            return true
        }
        if ((decepticon.courage - autobot.courage) >= 4 && (decepticon.strength - autobot.strength) >= 3) {
            winnersArray.append(decepticon)
            eliminatedArray.append(autobot)
            return true
        }
        return false
    }
    private func checkForSkill(autobot: Transformer, decepticon: Transformer) -> Bool {
        // check for skill
        if (autobot.skill - decepticon.skill) >= 3 {
            winnersArray.append(autobot)
            eliminatedArray.append(decepticon)
            return true
        }
        if (decepticon.skill - autobot.skill) >= 3 {
            winnersArray.append(decepticon)
            eliminatedArray.append(autobot)
            return true
        }
        return false
    }
}
