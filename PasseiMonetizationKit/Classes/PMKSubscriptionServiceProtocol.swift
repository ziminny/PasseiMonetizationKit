//
//  PMKSubscriptionServiceProtocol.swift
//  PasseiMonetizationKit
//
//  Created by Vagner Oliveira on 28/06/25.
//

import Foundation
import StoreKit

public protocol PMKSubscriptionServiceProtocol: ObservableObject, Sendable {
    var isPremiumUser: Bool { get }
    func fetchProducts(productNames: [String]) async throws
    func purchase(_ product: Product) async throws -> Transaction
    func refreshStatus() async
    
    init()
}
