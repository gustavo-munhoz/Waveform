//
//  RealWorldView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct RealWorldView: View {
    @EnvironmentObject var store: AppStore
    @State private var localScale: CGFloat = 1.0
    
    private enum texts: String {
        case title = "  Fourier in the Real World"
        case body = "The magic of the Fourier Transform extends far beyond the classroom. It's pivotal in compressing images so they can be easily stored and shared.\n\nIt's crucial in cleaning up audio recordings, removing noise to reveal the clear sound beneath. It even helps us understand the universe, from analyzing the patterns of stars to unlocking the secrets of quantum mechanics.\n\nThe Fourier Transform is everywhere, acting as a universal translator for the language of the cosmos. Try increasing the zoom to see closely what is happening!"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Group {
                Text(Image(systemName: "globe.americas.fill"))
                    .foregroundColor(Color("FourierLineStroke"))
                + Text(texts.title.rawValue)
            }
            .minimumScaleFactor(0.8)
            .font(.system(size: 64))
            .fontWeight(.bold)
            .foregroundStyle(Color("PrimaryText"))
            .padding()
            .padding(.top)
            .background(Color("Background").opacity(0.85))
            .zIndex(1)
            
            Text(texts.body.rawValue)
                .font(.system(size: 28))
                .minimumScaleFactor(0.5)
                .foregroundStyle(Color("SecondaryText"))
                .padding([.horizontal, .bottom])
                .background(Color("Background").opacity(0.85))
                .zIndex(1)
            
            ZStack {
                Group {
                    if let viewModel = store.state.fourierData.viewModel {
                        VStack {
                            FourierDrawingView(viewModel: viewModel)
                                .scaleEffect(0.7)
                                .offset(y: -200)
                                .zIndex(-10)
                        }
                    } else {
                        ProgressView()
                    }
                }

                VStack {
                    VStack {
                        VStack(alignment: .center) {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("PrimaryText"))
                                .font(.system(size: 21))
                                .padding()
                            
                            VSlider(value: $localScale, in: log(1)...log(10000))
                                .padding(.bottom)
                                .onChange(of: localScale) { value in
                                    let linearValue = exp(value)
                                    
                                    store.state.fourierData.viewModel?.scale = linearValue
                                }
                        }
                        .frame(width: 50, height: 350)
                    }
                    .background(Color("Background").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("PrimaryText"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    
                    Spacer()
                    
                    HStack {
                        Text("5 of 6")
                            .font(.system(size: 21))
                            .padding()
                            .background(Color("Background").opacity(0.8))
                            .foregroundStyle(Color("PrimaryText"))
                            
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToTryYourself)
                            }
                        } label: {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Color("FourierLineStroke"))
                            .fontWeight(.black)
                            .font(.system(size: 21))
                            .padding()
                            .background(Color("Background").opacity(0.8))
                        }
                    }
                }
            }
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            store.dispatch(.loadSVG(named: .Planet, resetExpoent: false))
        }
        .padding([.horizontal, .top], 32)
        .padding(.bottom, 64)
        .background(Color("Background"))
    }
}

#Preview {
    RealWorldView()
        .environmentObject(
            AppStore(initial: AppState(), reducer: appReducer, middlewares: [svgLogic])
        )
}
