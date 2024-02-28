//
//  EpicycleView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct EpicycleView: View {
    @EnvironmentObject var store: AppStore
    
    private enum texts: String {
        case title = " Building Signals with Epicycles"
        case body = "To visualize this symphony, imagine a series of circles, each rotating around the edge of another. These are called epicycles, and they can be combined in endless ways to trace out intricate patterns.\n\nThis is not just an artistic concept; it's a fundamental principle used to recreate complex signals, illustrating how simple waves come together to form intricate designs and functions."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Group {
                Text(Image(systemName: "pencil.circle"))
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
                .minimumScaleFactor(0.8)
                .font(.system(size: 28))
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal)
            
            ZStack {
                Group {
                    if let viewModel = store.state.fourierData.viewModel {
                        FourierDrawingView(viewModel: viewModel)
                            .scaleEffect(0.7)
                            .offset(y: -100)
                    } else {
                        ProgressView()
                    }
                }

                VStack {
                    Spacer()
                    
                    HStack {
                        Text("4 of 6")
                            .font(.system(size: 21))
                            .padding(.leading)
                            .foregroundStyle(Color("SecondaryText"))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToRealWorld)
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
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            store.dispatch(.loadSVG(named: .Curve, resetExpoent: false))
        }
        .padding([.horizontal, .top], 32)
        .padding(.bottom, 64)
        .background(Color("Background"))
    }
}

#Preview {
    EpicycleView()
        .environmentObject(AppStore(initial: AppState(), reducer: appReducer, middlewares: [svgLogic]))
}
