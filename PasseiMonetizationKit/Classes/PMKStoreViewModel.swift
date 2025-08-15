//
//  StoreManager.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 26/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

import Foundation
import StoreKit

final public class PMKStoreViewModel: PMKSubscriptionServiceProtocol {
    
    @MainActor
    @Published public private(set) var products: [Product] = []
    @Published public private(set) var purchasedProductIDs: Set<String> = []
    @Published public private(set) var isPremiumUser = false
    
    #if DEBUG
    @MainActor
    @Published public var previewProducts: [PreviewProducts] = []
    #endif
    
    public required init() {
        
    }
    
    public func fetchProducts(productNames: [String]) async throws {
        let storeProducts = try await Product.products(for: productNames)
        DispatchQueue.main.async {
            self.products = storeProducts
        }
    }
    
    public func purchase(_ product: Product) async throws -> Transaction {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    self.purchasedProductIDs.insert(transaction.productID)
                    await transaction.finish()
                    return transaction
                case .unverified(_, let error):
                    throw PMKStoreKitError.unverified(error)
                }
            case .userCancelled:
                throw PMKStoreKitError.userCancelled
            case .pending:
                throw PMKStoreKitError.pending
            default:
                throw PMKStoreKitError.unknown(NSError(domain: "unknown error", code: 10))
            }
        } catch {
            throw PMKStoreKitError.unknown(error)
        }
    }
    
    public func refreshStatus() async {
        
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                if transaction.productType == .autoRenewable {
                    if !transaction.isUpgraded {
                        DispatchQueue.main.async {
                            self.isPremiumUser = true
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.isPremiumUser = false
        }
        
    }
    
}
