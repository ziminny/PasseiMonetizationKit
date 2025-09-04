//
//  PreviewWrapper.swift
//  
//
//  Created by Joel Lacerda on 04/09/25.
//

import SwiftUI
import PasseiMonetizationKit

struct PreviewWrapper: View {
    var body: some View {
        PMKMonetizationView(
            viewModel: PMKPremiumCicleViewModel(),
            configuration: PMKUIConfiguration(
                primaryColor: .purple,
                titleText: "Seja Premium!",
                subtitleText: "Desbloqueie recursos exclusivos",
                benefits: [
                    "Simulados ilimitados",
                    "Recursos exclusivos",
                    "Mais aprendizado, mais resultados"
                ]
            )
        )
    }
}

#Preview {
    PreviewWrapper()
}

