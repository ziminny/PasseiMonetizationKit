//
//  PMKPremiumPageView.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 27/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

import SwiftUI
import StoreKit

public struct PMKPremiumPageView: View {
    
    @StateObject private var store = PMKStoreFacade.shared.subscriptionService
    @Environment(\.dismiss) private var dismiss
    
    private let imageName: String
    private var onTap: (Result<StoreKit.Transaction, Error>) -> Void
    
#if DEBUG
    public init(imageName: String, previewType: PreviewsMoetizationType, onTap: @escaping (Result<StoreKit.Transaction, Error>) -> Void) {
        self.imageName = imageName
        self.onTap = onTap
        store.previewProducts = previewType.makeProducts()
    }
#else
    public init(imageName: String, onTap: @escaping (Result<StoreKit.Transaction, Error>) -> Void) {
        self.imageName = imageName
        self.onTap = onTap
    }
#endif
    
    public var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .clipped()
                    .ignoresSafeArea()
                
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.black)
                    .opacity(0.5)
                
                // Gradiente para dar cor interna à letra
                LinearGradient(
                    colors: [
                        .white.opacity(0.1),
                        .black.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(.ultraThinMaterial) // fundo translúcido
                .blur(radius: 0.2) // vidro levemente fosco
                .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark.square.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.5))
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Spacer()
                        
                        Text("Restaurar")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.white)
                            .underline()
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 16)
                    advantages()
                        .padding(.horizontal)
                    Spacer(minLength: 48)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                
                                if PREVIEWS {
                                    
                                    ForEach(Array(store.previewProducts.enumerated()), id: \.offset) { index, plan in
                                        VStack(spacing: 16) {
                                            
                                            // Precisa pensar em como fazer isso em producao
                                            if let hot = plan.hot {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.green)
                                                    .frame(width: 90, height: 32)
                                                    .overlay(
                                                        Text(hot.desc)
                                                            .font(.headline)
                                                            .foregroundStyle(.white)
                                                        ,alignment: .center
                                                    )
                                            }
                                            
                                            Text(plan.displayName)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            
                                            
                                            Rectangle()
                                                .fill(Color.yellow)
                                                .frame(width: 60, height: 2)
                                            
                                            Text(plan.displayPrice)
                                                .font(.system(size: 40, weight: .bold))
                                                .foregroundColor(.black)
                                            
                                            Text(plan.description)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(nil)
                                            
                                            Button(action: {
                                                // no action preview
                                            }) {
                                                Text("Assinar")
                                                    .fontWeight(.semibold)
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.purple)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(12)
                                            }
                                            .padding(.horizontal)
                                            .padding(.bottom, 8)
                                        }
                                        .frame(maxWidth: geometry.size.width / 2, maxHeight: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.white.opacity(0.95))
                                                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                                        )
                                        .padding(.bottom)
                                    }
                                    
                                } else {
                                    
                                    ForEach(Array(store.products.enumerated()), id: \.offset) { index, plan in
                                        VStack(spacing: 16) {
                                            
                                            if index == 1 {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.green)
                                                    .frame(width: 80, height: 28)
                                                    .overlay(
                                                        Text("-36%")
                                                            .font(.headline)
                                                            .foregroundStyle(.white)
                                                        ,alignment: .center
                                                    )
                                            }
                                            
                                            Text(plan.displayName)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            
                                            
                                            Rectangle()
                                                .fill(Color.yellow)
                                                .frame(width: 60, height: 2)
                                            
                                            Text(plan.displayPrice)
                                                .font(.system(size: 40, weight: .bold))
                                                .foregroundColor(.black)
                                            
                                            Text(plan.description)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(nil)
                                            
                                            Button(action: {
                                                
                                                Task {
                                                    do {
                                                        let transaction = try await store.purchase(plan)
                                                        self.onTap(.success(transaction))
                                                    } catch {
                                                        self.onTap(.failure(error))
                                                    }
                                                }
                                            }) {
                                                Text("Assinar")
                                                    .fontWeight(.semibold)
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.purple)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(12)
                                            }
                                            .padding(.horizontal)
                                            .padding(.bottom, 8)
                                        }
                                        .frame(maxWidth: geometry.size.width / 2, maxHeight: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.white.opacity(0.95))
                                                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                                        )
                                        .padding(.bottom)
                                    }
                                }
                            }
                            
                            .padding(.horizontal)
                        }
                        .onAppear {
                            // centraliza o segundo item (índice 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo(1, anchor: .center)
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 8)
                    
                    Label("Cancele a qualquer momento", systemImage: "")
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                }
                
            }
            
            
        }
    }
    
    private func advantages() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vantagens")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Cronograma personalizado")
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Até 10 simulados por mês")
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Sem anúncios")
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Questões por matéria ilimitado")
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Acesso a e-books, mais de 10.000 páginas")
                            .foregroundStyle(.white)
                    }
                    
                }
                Spacer()
            }
            .fontWeight(.light)
            .font(.system(size: 20))
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
#if DEBUG
    PMKPremiumPageView(imageName: "presentation_bg", previewType: .a) {_ in
    }
#endif
}

fileprivate let PREVIEWS = ProcessInfo.processInfo.isSwiftUIPreview

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
