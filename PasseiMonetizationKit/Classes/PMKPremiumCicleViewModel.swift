//
//  PMKPremiumCicleViewModel.swift
//  PasseiMonetizationKit
//
//  Created by Vagner Oliveira on 22/08/25.
//

import Foundation
import StoreKit

@MainActor
public protocol ObservableUserStatusChangeDelegate {
    func onChange(_ isPremium: Bool) async
}

final public class PMKPremiumCicleViewModel: ObservableObject, @unchecked Sendable {
    
    @Published var isUserPremium: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var expirationDate: Date? = nil
    
    public var delegate: ObservableUserStatusChangeDelegate?
    
    private var updates: Task<Void, Never>? = nil
    
    internal init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    // Verificar se a assinatura está ativa baseado na data atual
    public func checkIfSubscriptionIsCurrentlyActive() -> Bool {
        guard let expiration = expirationDate else {
            // Se não tem data de expiração, é compra permanente
            return isUserPremium
        }
        
        return isUserPremium && expiration > Date()
    }
    
    // Verificar status de assinatura
    public func verifySubscriptionStatus() async {
        isLoading = true
        // Verificar todas as transações
        await checkForTransactions()
        
        isLoading = false
    }
    
    // Observar atualizações de transações
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await verificationResult in Transaction.updates {
                await self?.handle(transactionVerification: verificationResult)
            }
        }
    }
    
    // Verificar transações existentes
    private func checkForTransactions() async {
        do {
            // Verificar transações não consumidas
            for await verificationResult in Transaction.currentEntitlements {
                await handle(transactionVerification: verificationResult)
            }
        }
    }
    
    // Processar resultado de verificação de transação
    private func handle(transactionVerification result: VerificationResult<Transaction>) async {
        do {
            let transaction = try result.payloadValue
            await checkTransactionStatus(transaction)
            
        } catch {
            errorMessage = "Transação inválida: \(error.localizedDescription)"
        }
    }
    
    
    private func checkTransactionStatus(_ transaction: Transaction) async {
        let currentDate = Date()
        
        // Verificar se a transação foi revogada
        guard transaction.revocationDate == nil else {
            isUserPremium = false
            expirationDate = nil
            await delegate?.onChange(false)
            return
        }
        
        // Verificar data de expiração manualmente
        if let expiration = transaction.expirationDate {
            if expiration > currentDate {
                // Assinatura ATIVA
                isUserPremium = true
                expirationDate = expiration
                await delegate?.onChange(true)
                
            } else {
                // Assinatura EXPIRADA
                isUserPremium = false
                expirationDate = expiration
                await delegate?.onChange(false)
            }
        } else {
            // Compra única (não expira)
            isUserPremium = true
            expirationDate = nil
            await delegate?.onChange(true)
        }
    }
    
    public func refreshStatus() async {
        
        do {
            try await AppStore.sync()
            await checkForTransactions()
        } catch {
            debugPrint("Erro ao tentar restaurar:", error)
        }
        
    }
    
}
