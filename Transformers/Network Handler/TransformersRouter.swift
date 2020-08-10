//
//  TransformersRouter.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

enum TransformersRouter {
    case allspark
    case getTransformers(token: String)
    case postTransformers(token: String, name: String, team: String, strength: Int, intelligence: Int, speed: Int, endurance: Int, rank: Int, courage: Int, firepower: Int, skill: Int)
    case putTransformers(token: String, id: String, name: String, team: String, strength: Int, intelligence: Int, speed: Int, endurance: Int, rank: Int, courage: Int, firepower: Int, skill: Int)
    case deleteTransformer(token: String, id: String)
}

extension TransformersRouter: NetworkConfiguration {
    var method: HTTPMethod {
        switch self {
        case .allspark:
            return .get
        case .getTransformers(_):
            return .get
        case .postTransformers(_,_,_,_,_,_,_,_,_,_,_):
            return .post
        case .putTransformers(_,_,_,_,_,_,_,_,_,_,_,_):
            return .put
        case .deleteTransformer(_,_):
            return .delete
        }
    }
    var path: String? {
        switch self {
        case .allspark:
            return "/allspark"
        case .getTransformers(_):
            return "/transformers"
        case .postTransformers(_,_,_,_,_,_,_,_,_,_,_):
            return "/transformers"
        case .putTransformers(_,_,_,_,_,_,_,_,_,_,_,_):
            return "/transformers"
        case .deleteTransformer(_,let id):
            return "/transformers/\(id)"
        }
        
    }
    var headers: [String : String]? {
        switch self {
        case .allspark:
            return ["Content-Type":"application/json"]
        case .getTransformers(let token):
            return ["Content-Type":"application/json", "Authorization":"Bearer \(token)"]
        case .postTransformers(let token,_,_,_,_,_,_,_,_,_,_):
            return ["Content-Type":"application/json", "Authorization":"Bearer \(token)"]
        case .putTransformers(let token,_,_,_,_,_,_,_,_,_,_,_):
            return ["Content-Type":"application/json", "Authorization":"Bearer \(token)"]
        case .deleteTransformer(let token,_):
            return ["Content-Type":"application/json", "Authorization":"Bearer \(token)"]
        }
        
    }
    var bodyparameters: [String : Any]? {
        switch self {
        case .allspark:
            return [:]
        case .getTransformers(_):
            return [:]
        case .postTransformers(_,let name,let team,let strength,let intelligence,let speed,let endurance,let rank,let courage,let firepower,let skill):
            return ["name":name, "strength": strength, "intelligence":intelligence,"speed":speed,
                    "endurance":endurance,"rank": rank,"courage":courage,"firepower": firepower,"skill":skill,"team":team]
        case .deleteTransformer(_,_):
            return [:]
        case .putTransformers(_,let id,let name,let team,let strength,let intelligence,let speed,let endurance,let rank,let courage,let firepower,let skill):
            return ["id": id, "name":name, "strength": strength, "intelligence":intelligence,"speed":speed,
            "endurance":endurance,"rank": rank,"courage":courage,"firepower": firepower,"skill":skill,"team":team]
        }
    }
}
