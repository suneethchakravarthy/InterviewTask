//
//  TransformerListModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

// MARK: - TransformerListModel
struct TransformerListModel: Decodable {
    let transformers: [Transformer]?
}

// MARK: - Transformer
struct Transformer: Decodable {
    let id, name: String
    let strength, intelligence, speed, endurance: Int
    let rank, courage, firepower, skill: Int
    let team: String
    let teamIcon: String?
    var overallRating: Int {
        return (strength + intelligence + speed + endurance + firepower)
    }
    enum CodingKeys: String, CodingKey {
        case id, name, strength, intelligence, speed, endurance, rank, courage, firepower, skill, team
        case teamIcon = "team_icon"
    }
    func getTeamName() -> String {
        if self.team == Constants.TeamCode.autobot { return TransformerTeam.Autobots.rawValue}
        else { return TransformerTeam.Decepticons.rawValue }
    }
}

