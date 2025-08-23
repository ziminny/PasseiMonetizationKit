//
//  StoreManager.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 26/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

import Foundation
import StoreKit

final internal class PMKStoreViewModel: @unchecked Sendable {
    
    @Published var products: [Product] = []
    
    internal init() { }
    
    internal func fetchProducts(productNames: [String]) async throws {
        let storeProducts = try await Product.products(for: productNames)
        DispatchQueue.main.async {
            self.products = storeProducts
        }
    }
    
    internal func purchase(_ product: Product) async throws -> Transaction {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
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
    
}


enum StoreError: Error {
    case failedVerification
}
