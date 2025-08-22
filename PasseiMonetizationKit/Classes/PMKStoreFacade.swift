//
//  PMKStoreFacade.swift
//  PasseiMonetizationKit
//
//  Created by Vagner Oliveira on 28/06/25.
//

import Foundation
import UIKit
import StoreKit

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
    
    public func checkUserSubscriptionStatus(completion: (Result<Transaction, Error>) -> Void) async {
          await subscriptionService.checkUserSubscriptionStatus(completion: completion)
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
