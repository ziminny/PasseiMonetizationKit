//
//  PreviewsMoetizationType.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 27/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

#if DEBUG

import Foundation
public enum PreviewsMoetizationType {
    
    case a
    case b
    case c
    
    func makeProducts() -> [PreviewProducts] {
        
        let semanal = PreviewProducts(
            displayName: "Plano semanal",
            displayPrice: "R$ 10.99",
            description: "Acesso completo por 7 dias para testar todos os recursos."
        )
        
        let trimestral = PreviewProducts(
            displayName: "Plano trimestral",
            displayPrice: "R$ 85.99",
            description: "Economize com 3 meses de acesso ilimitado e suporte prioritário."
        )
        
        let mensal = PreviewProducts(
            displayName: "Plano mensal",
            displayPrice: "R$ 29.99",
            description: "Renovação automática com acesso mensal a todo o conteúdo.",
            hot: .init(desc: "-36%")
        )
        
        let anual = PreviewProducts(
            displayName: "Plano anual",
            displayPrice: "R$ 299.99",
            description: "Melhor custo-benefício: 12 meses de acesso premium com bônus exclusivos."
        )
        
        
        switch self {
        case .a:
            return [
                semanal,
                mensal,
                trimestral,
                anual
            ]
        case .b:
            return [
                mensal,
                anual
            ]
        case .c:
            return [
                mensal,
                trimestral,
                anual
            ]
        }
    }
}
#endif