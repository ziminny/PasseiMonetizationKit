//
//  StoreManager.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 26/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

import Foundation
import StoreKit

@MainActor
public protocol ObservableSubscriptionStatusDelegate {
    func onChange(_ isLoading: Bool, error: Error?) async
}

final internal class PMKStoreViewModel: @unchecked Sendable {
    
    @Published var products: [Product] = []
    
    var delegate: ObservableSubscriptionStatusDelegate?
    
    internal init() { }
    
    internal func fetchProducts(productNames: [String]) async throws {
        let storeProducts = try await Product.products(for: productNames)
        DispatchQueue.main.async {
            self.products = storeProducts
        }
    }
    
    internal func purchase(_ product: Product) async throws -> Transaction {
        await delegate?.onChange(true, error: nil)
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    await delegate?.onChange(false, error: nil)
                    return transaction
                case .unverified(_, let error):
                    await delegate?.onChange(false, error: error)
                    throw PMKStoreKitError.unverified(error)
                }
            case .userCancelled:
                await delegate?.onChange(false, error: PMKStoreKitError.userCancelled)
                throw PMKStoreKitError.userCancelled
            case .pending:
                await delegate?.onChange(false, error: PMKStoreKitError.pending)
                throw PMKStoreKitError.pending
            default:
                await delegate?.onChange(false, error: PMKStoreKitError.unknown(NSError(domain: "unknown error", code: 10)))
                throw PMKStoreKitError.unknown(NSError(domain: "unknown error", code: 10))
            }
        } catch {
            await delegate?.onChange(false, error: error)
            throw PMKStoreKitError.unknown(error)
        }
    }
    
}


enum StoreError: Error {
    case failedVerification
}
