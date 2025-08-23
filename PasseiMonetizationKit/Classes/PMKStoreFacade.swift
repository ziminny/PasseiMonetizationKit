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

    private let subscriptionService: PMKStoreViewModel = PMKStoreViewModel()
    private let premiumCicleViewModel: PMKPremiumCicleViewModel = PMKPremiumCicleViewModel()
    
    public var products: [Product] {
        return subscriptionService.products
    }
    
    public func fetchProducts(productNames: [String]) async throws {
        return try await subscriptionService.fetchProducts(productNames: productNames)
    }
    
    public func purchase(_ product: Product) async throws -> Transaction {
        return try await subscriptionService.purchase(product)
    }
    
    public func cicleViewModel() -> PMKPremiumCicleViewModel {
        return premiumCicleViewModel
    }

}
