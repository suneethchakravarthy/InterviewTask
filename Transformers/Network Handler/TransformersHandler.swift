//
//  TransformersHandler.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

class TransformersHandler {
    func getAllSpark(completion: @escaping (String?, APIError?) -> Void) {
        let allsparkRouter = TransformersRouter.allspark
        NetworkHandler().makeAPICall(router: allsparkRouter) { (result) in
            switch result {
                case .success(let token):
                        completion(token, nil)
                case .failure(let error):
                        completion(nil, error)
            }
        }
    }
    func getTransformers(completion: @escaping (TransformerListModel?, APIError?) -> Void) {
        let getTransformersRouter = TransformersRouter.getTransformers(token: UserDefaultUtils.shared.getStringValue(for: .token))
        NetworkHandler().makeAPICall(router: getTransformersRouter, decodingType: TransformerListModel.self) { (result) in
            switch result {
            case .success(let model):
                    completion(model as? TransformerListModel, nil)
            case .failure(let error):
                    completion(nil, error)
            }
        }
    }
    func createTransformer(with dataDictionary: [String: String], completion: @escaping (Transformer?, APIError?) -> Void) {
        let result = returnMultipleValues(dataDictionary: dataDictionary)
        let postTransformersRouter = TransformersRouter.postTransformers(token: UserDefaultUtils.shared.getStringValue(for: .token), name: result.name, team: result.teamName, strength: result.strength, intelligence: result.intelligence,
                                                                         speed: result.speed, endurance: result.endurance, rank: result.rank,
                                                                         courage: result.courage, firepower: result.firepower, skill: result.skill)
        NetworkHandler().makeAPICall(router: postTransformersRouter, decodingType: Transformer.self) { (result) in
            switch result {
            case .success(let model):
                completion(model as? Transformer, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    func updateTransformer(transformerId: String, dataDictionary: [String: String], completion: @escaping (Transformer?, APIError?) -> Void) {
        let result = returnMultipleValues(dataDictionary: dataDictionary)
        let putTransformersRouter = TransformersRouter.putTransformers(token: UserDefaultUtils.shared.getStringValue(for: .token), id: transformerId, name: result.name,
                                                                        team: result.teamName, strength: result.strength, intelligence: result.intelligence,
                                                                        speed: result.speed, endurance: result.endurance, rank: result.rank, courage: result.courage, firepower: result.firepower, skill: result.skill)
        NetworkHandler().makeAPICall(router: putTransformersRouter, decodingType: Transformer.self) { (result) in
            switch result {
            case .success(let model):
                completion(model as? Transformer, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    func deleteTransformer(transformerId: String, completion: @escaping (String?, APIError?) -> Void) {
        let deleteTransformerRouter = TransformersRouter.deleteTransformer(token: UserDefaultUtils.shared.getStringValue(for: .token), id: transformerId)
        NetworkHandler().makeAPICall(router: deleteTransformerRouter) { (result) in
            switch result {
                case .success(_):
                        completion("", nil)
                case .failure(let error):
                        completion(nil, error)
            }
        }
    }
    // MARK: - Private Methods
    private func returnMultipleValues(dataDictionary: [String: String]) -> (name: String, teamName: String,
        strength: Int, intelligence: Int, speed: Int, endurance: Int, rank: Int, courage: Int,
        firepower: Int, skill: Int) {
        let name = dataDictionary[TechSpecs.name.rawValue] ?? ""
        let teamName = (dataDictionary[TechSpecs.team.rawValue] == TransformerTeam.Autobots.rawValue) ? Constants.TeamCode.autobot : Constants.TeamCode.decepticon
        let strength = Int(dataDictionary[TechSpecs.strength.rawValue] ?? "1") ?? 1
        let intelligence = Int(dataDictionary[TechSpecs.intelligence.rawValue] ?? "1") ?? 1
        let speed = Int(dataDictionary[TechSpecs.speed.rawValue] ?? "1") ?? 1
        let endurance = Int(dataDictionary[TechSpecs.endurance.rawValue] ?? "1") ?? 1
        let rank = Int(dataDictionary[TechSpecs.rank.rawValue] ?? "1") ?? 1
        let courage = Int(dataDictionary[TechSpecs.courage.rawValue] ?? "1") ?? 1
        let firepower = Int(dataDictionary[TechSpecs.firepower.rawValue] ?? "1") ?? 1
        let skill = Int(dataDictionary[TechSpecs.skill.rawValue] ?? "1") ?? 1
        return (name, teamName, strength, intelligence, speed, endurance, rank, courage, firepower, skill)
    }
}
