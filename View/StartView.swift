//
//  StartView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var store: AppStore
    
    @State private var textOpacity = 1.0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                if let viewModel = store.state.fourierData.viewModel {
                    ZStack(alignment: .leading) {
                        FourierDrawingView(viewModel: viewModel)
                            .scaleEffect(1.3)
                            .offset(y: 90)
                        
                        Text("Wavetrace")
                            .foregroundStyle(Color("PrimaryText"))
                            .font(.system(size: 72, weight: .heavy))
                            .padding(72)
                    }
                    
                } else {
                    ProgressView()
                }
                
                Text("tap anywhere to begin")
                    .foregroundStyle(Color("PrimaryText"))
                    .font(.title)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            textOpacity = 0.1
                        }
                    }
                
                Spacer()
                    .frame(height: geo.size.height * 0.3)
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color("Background"))
        .onTapGesture {
            withAnimation(.snappy(duration: 0.4)) {
                store.dispatch(.navigateToIntroduction)
            }
        }
    }
}

#Preview {
    StartView()
        .environmentObject(
            AppStore(initial: AppState(), reducer: appReducer)
        )
}
