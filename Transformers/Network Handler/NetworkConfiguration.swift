//
//  NetworkConfiguration.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkConfiguration {
    // default values provided in protocol-extenstion
    var baseURL: String { get }
    var timeoutInterval: TimeInterval { get }
    
    // specific to API
    var method: HTTPMethod { get }
    var path: String? { get }
    var bodyparameters: [String: Any]? { get }
    var headers: [String : String]? { get }
}
extension NetworkConfiguration {
    var baseURL: String {
        return Constants.URLConstants.baseURL
    }
    var timeoutInterval: TimeInterval {
        return Constants.URLConstants.defaultTimeOut
    }
}
