//
//  GuideView.swift
//
//
//  Created by Gustavo Munhoz Correa on 21/02/24.
//

import SwiftUI

struct GuideView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack {
            switch store.state.guideState {
                case .introduction:
                    IntroductionView()
                    
                case .smoothie:
                    SmoothieView()
                    
                case .frequency:
                    FrequencyView()
                    
                case .epicycle:
                    EpicycleView()
                    
                case .realWorld:
                    RealWorldView()
                    
                case .tryYourself:
                    TryYourselfView()
            }
        }
        .background(Color("Background"))
    }
}

#Preview {
    GuideView()
}
