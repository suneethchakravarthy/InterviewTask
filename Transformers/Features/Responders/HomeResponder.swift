//
//  HomeResponder.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

protocol HomeResponder {
        func navigateToAddTransformerScreen()
        func navigateToWarTransformerScreen(autobots: [Transformer], decepticons: [Transformer])
        func navigateToViewDetailsScreen(model: Transformer)
}
