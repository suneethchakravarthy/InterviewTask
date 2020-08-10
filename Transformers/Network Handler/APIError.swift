//
//  APIError.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

struct ErrorConstants {
    struct ErrorTitles {
        static let noNetwork = "Network Error"
        static let serverError = "Server Error"
        static let jsonError = "Internal Error"
    }
    struct ErrorMessages {
        static let noNetwork = "No internet connection. Please check the network settings."
        static let serverError = "Service unavailable now."
        static let jsonError = "Parsing failed"
        static let emotionError = "Please select your feelings."
    }
}

enum APIError: Error {
    case noNetwork
    case serverError
    case jsonError
}

extension APIError {
    var errorTitle: String {
        switch self {
        case .noNetwork:
            return ErrorConstants.ErrorTitles.noNetwork
        case .serverError:
            return ErrorConstants.ErrorTitles.serverError
        case .jsonError:
            return ErrorConstants.ErrorTitles.jsonError
        }
    }
    var errorMessage: String {
        switch self {
        case .noNetwork:
            return ErrorConstants.ErrorMessages.noNetwork
        case .serverError:
            return ErrorConstants.ErrorMessages.serverError
        case .jsonError:
            return ErrorConstants.ErrorMessages.jsonError
        }
    }
}
