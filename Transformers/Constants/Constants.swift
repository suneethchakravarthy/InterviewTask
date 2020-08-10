//
//  Constants.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

struct Constants {
    struct URLConstants {
        static let baseURL: String = "https://transformers-api.firebaseapp.com"
        static let defaultTimeOut: Double = 90.0
    }
    struct ValidationMessages {
        static let alertTitle = "Error"
        static let emptyValidationMessage = "Please fill the all required fields"
        static let noTeamMembersMessage = "Teams do not have sufficient members to participate in war"
    }
    struct TeamIconImages {
        static let autobot = "https://tfwiki.net/mediawiki/images2/archive/f/fe/20110410191732%21Symbol_autobot_reg.png"
        static let decept = "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
    }
    struct TeamCode {
        static let autobot = "A"
        static let decepticon = "D"
    }
}
