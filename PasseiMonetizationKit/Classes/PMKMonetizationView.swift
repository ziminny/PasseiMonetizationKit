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
        ZStack {
            // Fundo com gradiente
            LinearGradient(
                colors: [configuration.primaryColor, configuration.secondaryColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Ícone principal (estrela)
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                    .padding(.bottom, 8)
                
                // Título e subtítulo
                Text(configuration.titleText)
                    .font(Font(configuration.titleFont))
                    .foregroundColor(.white)
                
                Text(configuration.subtitleText)
                    .font(Font(configuration.subtitleFont))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 24)
                
                // Benefícios listados
                VStack(spacing: 12) {
                    ForEach(configuration.benefits, id: \.self) { benefit in
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.yellow)
                            Text(benefit)
                                .font(Font(configuration.bodyFont))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
                
                Spacer()
                
                // Botão de assinar
                Button(action: {
                    Task {
                        if let product = viewModel.availableProducts.first {
                            try? await PMKStoreFacade.shared.purchase(product)
                        }
                    }
                }) {
                    Text(configuration.subscribeButtonText)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(configuration.buttonTextColor))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(configuration.buttonCornerRadius)
                }
                
                // Botão de restaurar compras
                Button(action: {
                    Task {
                        do {
                            try? await PMKStoreFacade.shared.restorePurchases()
                        } catch {
                            print("Erro ao restaurar compras: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Restaurar Compras")
                        .foregroundColor(Color(configuration.secondaryColor))
                        .font(Font(configuration.bodyFont))
                }
                .padding(.top, 8)

                
                // Botão de dismiss
                Button(configuration.dismissButtonText) {
                    // Aqui o app pode fechar a tela, você pode expor via closure depois
                }
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 8)
            }
            .padding()
        }
    }
}
