//
//  PMKUIConfiguration.swift
//  
//
//  Created by Joel Lacerda on 24/08/25.
//

import UIKit

public struct PMKUIConfiguration {
    
    // MARK: - Cores
    public var primaryColor: UIColor
    public var secondaryColor: UIColor
    public var backgroundColor: UIColor
    
    // MARK: - Layout
    public enum TierLayoutStyle {
        case horizontalScroll
        case verticalScroll
    }
    public var tierLayoutStyle: TierLayoutStyle
    
    // MARK: - Botões
    public var buttonCornerRadius: CGFloat
    public var buttonTextColor: UIColor
    
    // MARK: - Fontes
    public var titleFont: UIFont
    public var subtitleFont: UIFont
    public var bodyFont: UIFont
    
    // MARK: - Textos customizáveis
    public var titleText: String
    public var subtitleText: String
    public var subscribeButtonText: String
    public var restoreButtonText: String
    public var dismissButtonText: String
    public var benefits: [String]
    
    // MARK: - Inicializador com valores padrão
    public init(
        primaryColor: UIColor = .systemBlue,
        secondaryColor: UIColor = .systemGray,
        backgroundColor: UIColor = .systemBackground,
        tierLayoutStyle: TierLayoutStyle = .horizontalScroll,
        buttonCornerRadius: CGFloat = 12,
        buttonTextColor: UIColor = .white,
        titleFont: UIFont = .preferredFont(forTextStyle: .largeTitle),
        subtitleFont: UIFont = .preferredFont(forTextStyle: .title2),
        bodyFont: UIFont = .preferredFont(forTextStyle: .body),
        titleText: String = "Assine e desbloqueie benefícios!",
        subtitleText: String = "Escolha um plano que melhor se adapta a você",
        subscribeButtonText: String = "Assinar agora",
        restoreButtonText: String = "Restaurar compras"
        dismissButtonText: String = "Talvez Depois",
        benefits: [String] = [
            "Responda simulados ilimitados e pratique sem parar.",
            "Acesse recursos exclusivos e maximize seu desempenho.",
            "Mais questões, mais aprendizado, mais resultados."
        ]
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.tierLayoutStyle = tierLayoutStyle
        self.buttonCornerRadius = buttonCornerRadius
        self.buttonTextColor = buttonTextColor
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.bodyFont = bodyFont
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.subscribeButtonText = subscribeButtonText
        self.restoreButtonText = restoreButtonText
        self.dismissButtonText = dismissButtonText
        self.benefits = benefits
    }
}
