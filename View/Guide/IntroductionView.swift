//
//  IntroductionView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct IntroductionView: View {
    @EnvironmentObject var store: AppStore
    
    private enum texts: String {
        case title = " Welcome to the Fourier Transform Guide!"
        case body = "Dive deep into the heart of waves, sounds, and even the very rhythm of nature through the lens of the Fourier Transform.\n\nThis journey will unravel the mystery of how complex patterns can be broken down into simpler, understandable pieces.\n\nGet ready to see the world from a whole new mathematical perspective."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Group {
                Text(Image(systemName: "waveform.path"))
                    .foregroundColor(Color("FourierLineStroke"))
                + Text(texts.title.rawValue)
            }
            .minimumScaleFactor(0.8)
            .lineSpacing(1)
            .font(.system(size: 64))
            .fontWeight(.bold)
            .foregroundStyle(Color("PrimaryText"))
            .padding()
        
            Text(texts.body.rawValue)
                .font(.system(size: 28))
                .minimumScaleFactor(0.5)
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal)
            
            ZStack {
                Image("fourier")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .minimumScaleFactor(0.8)

                VStack {
                    Spacer()
                    HStack {
                        Text("1 of 6")
                            .font(.system(size: 21))
                            .padding(.leading)
                            .foregroundStyle(Color("SecondaryText"))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToSmoothie)
                            }
                        } label: {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Color("FourierLineStroke"))
                            .fontWeight(.black)
                            .font(.system(size: 21))
                            .padding(.trailing)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding([.horizontal, .top], 32)
        .padding(.bottom, 64)
        .background(Color("Background"))
    }
}

#Preview {
    IntroductionView()
        .environmentObject(
            AppStore(initial: AppState(), reducer: appReducer, middlewares: [svgLogic])
        )
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        
    }
}
