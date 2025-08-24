//
//  PMKMonetizationView.swift
//  
//
//  Created by Joel Lacerda on 24/08/25.
//

import SwiftUI
import StoreKit

public struct PMKMonetizationView: View {
    @ObservedObject private var viewModel: PMKPremiumCicleViewModel
    private let configuration: PMKUIConfiguration
    
    public init(viewModel: PMKPremiumCicleViewModel,
                configuration: PMKUIConfiguration = PMKUIConfiguration()) {
        self.viewModel = viewModel
        self.configuration = configuration
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Título principal
            Text(configuration.titleText)
                .font(Font(configuration.titleFont))
                .foregroundColor(Color(configuration.primaryColor))
            
            // Subtítulo
            Text(configuration.subtitleText)
                .font(Font(configuration.subtitleFont))
                .foregroundColor(Color(configuration.secondaryColor))
            
            // Lista de planos
            ScrollView(configuration.tierLayoutStyle == .horizontalScroll ? .horizontal : .vertical,
                       showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.availableProducts, id: \.id) { product in
                        VStack(spacing: 8) {
                            Text(product.displayName)
                                .font(Font(configuration.bodyFont))
                                .foregroundColor(.white)
                            Text(product.displayPrice)
                                .font(Font(configuration.bodyFont))
                                .foregroundColor(Color(configuration.secondaryColor))
                        }
                        .padding()
                        .background(Color(configuration.primaryColor))
                        .cornerRadius(configuration.buttonCornerRadius)
                    }
                }
            }
            .padding(.vertical, 8)
            
            // Botão de assinatura
            Button(action: { /* Disparar compra */ }) {
                Text(configuration.subscribeButtonText)
                    .foregroundColor(Color(configuration.buttonTextColor))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(configuration.primaryColor))
                    .cornerRadius(configuration.buttonCornerRadius)
            }
            
            // Botão para restaurar compras
            Button(action: { /* Restaurar compras */ }) {
                Text(configuration.restoreButtonText)
                    .foregroundColor(Color(configuration.secondaryColor))
                    .font(Font(configuration.bodyFont))
            }
        }
        .padding()
        .background(Color(configuration.backgroundColor))
    }
}


#Preview {
    PMKMonetizationView()
}
