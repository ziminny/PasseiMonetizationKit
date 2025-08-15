//
//  PreviewProducts.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 27/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

#if DEBUG
import Foundation
public struct PreviewProducts {
    let displayName: String
    let displayPrice: String
    let description: String
    let hot: HotProduct?
    
    init(displayName: String, displayPrice: String, description: String, hot: HotProduct? = nil) {
        self.displayName = displayName
        self.displayPrice = displayPrice
        self.description = description
        self.hot = hot
    }
}

public struct HotProduct {
    let desc: String
}
#endif