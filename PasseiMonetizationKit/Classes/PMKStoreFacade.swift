//
//  PMKStoreFacade.swift
//  PasseiMonetizationKit
//
//  Created by Vagner Oliveira on 28/06/25.
//

import Foundation
import UIKit

public final class PMKStoreFacade {
    public static let shared = PMKStoreFacade()

    internal private(set) var subscriptionService: PMKStoreViewModel

    private init(
        subscriptionService: PMKStoreViewModel = PMKStoreViewModel()
    ) {
        self.subscriptionService = subscriptionService
    }
    
    public func fetchProducts(productNames: [String]) async throws {
        try await subscriptionService.fetchProducts(productNames: productNames)
    }

    public var isPremium: Bool {
        return subscriptionService.isPremiumUser
    }

    public func refreshSubscriptionStatus() async {
        await subscriptionService.refreshStatus()
    }

    public func showAdIfNeeded() -> Bool {
        return !isPremium
    }
}
