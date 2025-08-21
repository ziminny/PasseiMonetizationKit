//
//  PMKPremiumPageView.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 27/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

import SwiftUI
import StoreKit

fileprivate let PREVIEWS = ProcessInfo.processInfo.isSwiftUIPreview

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

public struct PMKPremiumPageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var store = PMKStoreFacade.shared.subscriptionService
    
    private let imageName: String
    private let isIpad: Bool
    private var onTap: (Result<StoreKit.Transaction, Error>) -> Void
    
#if DEBUG
    public init(imageName: String, previewType: PreviewsMoetizationType, isIpad: Bool, onTap: @escaping (Result<StoreKit.Transaction, Error>) -> Void) {
        self.imageName = imageName
        self.isIpad = isIpad
        self.onTap = onTap
        store.previewProducts = previewType.makeProducts()
    }
#else
    public init(imageName: String, isIpad: Bool, onTap: @escaping (Result<StoreKit.Transaction, Error>) -> Void) {
        self.imageName = imageName
        self.onTap = onTap
        self.isIpad = isIpad
    }
#endif
    
    public var body: some View {
        VStack(spacing: 20) {
            
            Text("Assinatura PasseiOAB")
                .font(isIpad ? .largeTitle : .title3)
                .bold()
                .padding(.top, 8)
            
            Text("Escolha o plano ideal para você")
                .font(isIpad ? .title2 : .subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                
                if PREVIEWS {
#if DEBUG
                    ForEach(Array(store.previewProducts.enumerated()), id: \.offset) { index, product in
                        subscriptionOption(
                            title: product.displayName,
                            price: product.displayPrice,
                            description: product.description
                        )
                    }
#endif
                } else {
                    ForEach(Array(store.products.enumerated()), id: \.offset) { index, plan in
                        subscriptionOption(
                            title: plan.displayName,
                            price: plan.displayPrice,
                            description: plan.description
                        ).onTapGesture {
                            Task {
                                do {
                                    let transaction = try await store.purchase(plan)
                                    self.onTap(.success(transaction))
                                } catch {
                                    self.onTap(.failure(error))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
            
            Button(action: {
                
                if !PREVIEWS {
                    Task {
                        await store.refreshStatus()
                    }
                }
            }) {
                Text("Restaurar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            .padding(.top, isIpad ? 20 : 12)
            
            Button("Cancelar") {
                dismiss()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 16)
            
        }
        .padding(.horizontal, isIpad ? 32 : 16)
        .presentationDetents( isIpad ? [.large] : [.medium, .large])
    }
    
    @ViewBuilder
    func subscriptionOption(title: String, price: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(isIpad ? .title : .headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(price)
                    .font(isIpad ? .title3 : .headline)
                    .foregroundStyle(.purple)
                    .bold()
            }
            Text(description)
                .font(isIpad ? .headline : .caption)
                .fontWeight(.regular)
                .foregroundStyle(.secondary)
        }
        .padding(isIpad ? 32 : 16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
#if DEBUG
    PMKPremiumPageView(imageName: "presentation_bg", previewType: .a, isIpad: false) {_ in
    }
#endif
}

